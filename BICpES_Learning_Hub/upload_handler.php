<?php
/**
 * upload_handler.php — BICpES Learning Hub
 * Handles multipart file uploads for:
 *   - Topic PDFs  → saved to Materials/
 *   - Project Videos → saved to Videos/
 *
 * Called via AJAX (fetch) from admin_dashboard.php.
 * Requires admin session.
 */

require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json');

// Must be admin
if (!is_admin()) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Unauthorized.']);
    exit;
}

// Must be POST with a file
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed.']);
    exit;
}

$type = $_POST['upload_type'] ?? ''; // 'pdf' or 'video'
$id   = (int)($_POST['record_id'] ?? 0);

// ── CONFIG ────────────────────────────────────────────────────────────────────
const PDF_DIR      = __DIR__ . '/Materials/';
const VIDEO_DIR    = __DIR__ . '/Videos/';
const PDF_MAX_MB   = 50;
const VIDEO_MAX_MB = 500;

$allowed_pdf   = ['application/pdf'];
$allowed_video = ['video/mp4', 'video/webm', 'video/ogg', 'video/quicktime', 'video/x-msvideo'];
$allowed_video_ext = ['mp4', 'webm', 'ogv', 'ogg', 'mov', 'avi'];

// ── ENSURE UPLOAD DIRECTORIES EXIST ──────────────────────────────────────────
foreach ([PDF_DIR, VIDEO_DIR] as $dir) {
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }
}

// ── ROUTE BY TYPE ─────────────────────────────────────────────────────────────
if ($type === 'pdf') {
    handlePdfUpload($id);
} elseif ($type === 'video') {
    handleVideoUpload($id);
} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Unknown upload_type.']);
}
exit;

// ─────────────────────────────────────────────────────────────────────────────
// PDF UPLOAD  (for topics)
// ─────────────────────────────────────────────────────────────────────────────
function handlePdfUpload(int $topic_id): void
{
    global $allowed_pdf;

    if (empty($_FILES['pdf_file']) || $_FILES['pdf_file']['error'] !== UPLOAD_ERR_OK) {
        $code = $_FILES['pdf_file']['error'] ?? -1;
        echo json_encode(['success' => false, 'message' => 'Upload error code: ' . $code]);
        return;
    }

    $file     = $_FILES['pdf_file'];
    $origName = basename($file['name']);
    $ext      = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
    $mime     = mime_content_type($file['tmp_name']);
    $sizeMB   = $file['size'] / (1024 * 1024);

    // Validate
    if ($ext !== 'pdf') {
        echo json_encode(['success' => false, 'message' => 'Only PDF files are allowed.']);
        return;
    }
    if (!in_array($mime, $allowed_pdf, true)) {
        echo json_encode(['success' => false, 'message' => 'Invalid MIME type: ' . $mime]);
        return;
    }
    if ($sizeMB > PDF_MAX_MB) {
        echo json_encode(['success' => false, 'message' => 'File too large. Maximum is ' . PDF_MAX_MB . ' MB.']);
        return;
    }

    // Sanitize filename — keep original name but strip unsafe chars
    $safeName = preg_replace('/[^A-Za-z0-9._\- ]/', '_', $origName);
    $safeName = preg_replace('/\s+/', '_', $safeName);
    $destPath = PDF_DIR . $safeName;

    // If filename collision, append a short hash
    if (file_exists($destPath)) {
        $base     = pathinfo($safeName, PATHINFO_FILENAME);
        $safeName = $base . '_' . substr(md5(uniqid()), 0, 6) . '.pdf';
        $destPath = PDF_DIR . $safeName;
    }

    if (!move_uploaded_file($file['tmp_name'], $destPath)) {
        echo json_encode(['success' => false, 'message' => 'Failed to save file. Check server permissions on Materials/ folder.']);
        return;
    }

    // If a topic_id was provided, update the DB record immediately
    if ($topic_id > 0) {
        $db   = get_db();
        $stmt = $db->prepare('UPDATE topics SET pdf_filename = ? WHERE id = ?');
        $stmt->bind_param('si', $safeName, $topic_id);
        $stmt->execute();
        $stmt->close();
    }

    echo json_encode([
        'success'  => true,
        'message'  => 'PDF uploaded successfully.',
        'filename' => $safeName,
    ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// VIDEO UPLOAD  (for projects)
// ─────────────────────────────────────────────────────────────────────────────
function handleVideoUpload(int $project_id): void
{
    global $allowed_video, $allowed_video_ext;

    if (empty($_FILES['video_file']) || $_FILES['video_file']['error'] !== UPLOAD_ERR_OK) {
        $code = $_FILES['video_file']['error'] ?? -1;
        $msgs = [
            0 => 'No error',
            1 => 'File exceeds upload_max_filesize in php.ini',
            2 => 'File exceeds MAX_FILE_SIZE in form',
            3 => 'File was only partially uploaded',
            4 => 'No file was uploaded',
            6 => 'Missing temporary folder',
            7 => 'Failed to write file to disk',
            8 => 'Upload stopped by extension',
        ];
        $msg = $msgs[$code] ?? 'Unknown upload error (code ' . $code . ')';
        echo json_encode(['success' => false, 'message' => $msg]);
        return;
    }

    $file     = $_FILES['video_file'];
    $origName = basename($file['name']);
    $ext      = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
    $mime     = mime_content_type($file['tmp_name']);
    $sizeMB   = $file['size'] / (1024 * 1024);

    // Validate extension
    if (!in_array($ext, $allowed_video_ext, true)) {
        echo json_encode(['success' => false, 'message' => 'Unsupported video format. Allowed: MP4, WebM, OGV, MOV, AVI.']);
        return;
    }
    if ($sizeMB > VIDEO_MAX_MB) {
        echo json_encode(['success' => false, 'message' => 'File too large. Maximum is ' . VIDEO_MAX_MB . ' MB.']);
        return;
    }

    // Sanitize filename
    $safeName = preg_replace('/[^A-Za-z0-9._\- ]/', '_', $origName);
    $safeName = preg_replace('/\s+/', '_', $safeName);
    $destPath = VIDEO_DIR . $safeName;

    // Collision guard
    if (file_exists($destPath)) {
        $base     = pathinfo($safeName, PATHINFO_FILENAME);
        $safeName = $base . '_' . substr(md5(uniqid()), 0, 6) . '.' . $ext;
        $destPath = VIDEO_DIR . $safeName;
    }

    if (!move_uploaded_file($file['tmp_name'], $destPath)) {
        echo json_encode(['success' => false, 'message' => 'Failed to save file. Check server permissions on Videos/ folder.']);
        return;
    }

    // If a project_id was provided, update the DB
    if ($project_id > 0) {
        $db   = get_db();
        // Store video filename in video_url column (see schema migration below)
        $stmt = $db->prepare('UPDATE projects SET video_url = ? WHERE id = ?');
        $stmt->bind_param('si', $safeName, $project_id);
        $stmt->execute();
        $stmt->close();
    }

    echo json_encode([
        'success'  => true,
        'message'  => 'Video uploaded successfully.',
        'filename' => $safeName,
    ]);
}