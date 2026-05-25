<?php
require_once __DIR__ . '/auth.php';
require_admin();                      // redirects to main.php if not admin
require_once __DIR__ . '/nav_auth.php';

$db = get_db();

/* ══════════════════════════════════════════════════════════════════════════════
   AJAX / POST HANDLER  (all mutations go through here)
══════════════════════════════════════════════════════════════════════════════ */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    header('Content-Type: application/json');
    $input  = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = $input['action'] ?? '';

    // helper
    $ok  = fn(string $msg, array $extra = []) => json_encode(['success' => true,  'message' => $msg] + $extra);
    $err = fn(string $msg)                     => json_encode(['success' => false, 'message' => $msg]);

    switch ($action) {

        /* ── TOPICS ── */
        case 'topic_create':
            $num  = (int)   ($input['topic_num']   ?? 0);
            $name = trim($input['name']        ?? '');
            $desc = trim($input['description'] ?? '');
            $cat  = trim($input['category']    ?? '');
            if (!$num || !$name || !$desc || !$cat) { echo $err('All fields required.'); break; }
            $s = $db->prepare('INSERT INTO topics (topic_num,name,description,category) VALUES (?,?,?,?)');
            $s->bind_param('isss', $num, $name, $desc, $cat);
            if ($s->execute()) { echo $ok('Topic created.', ['id' => $db->insert_id]); }
            else               { echo $err('Failed: ' . $s->error); }
            $s->close();
            break;

        case 'topic_update':
            $id   = (int)   ($input['id']          ?? 0);
            $num  = (int)   ($input['topic_num']   ?? 0);
            $name = trim($input['name']        ?? '');
            $desc = trim($input['description'] ?? '');
            $cat  = trim($input['category']    ?? '');
            if (!$id || !$num || !$name || !$desc || !$cat) { echo $err('All fields required.'); break; }
            $s = $db->prepare('UPDATE topics SET topic_num=?,name=?,description=?,category=? WHERE id=?');
            $s->bind_param('isssi', $num, $name, $desc, $cat, $id);
            echo $s->execute() ? $ok('Topic updated.') : $err('Failed: ' . $s->error);
            $s->close();
            break;

        case 'topic_delete':
            $id = (int)($input['id'] ?? 0);
            if (!$id) { echo $err('Invalid ID.'); break; }
            $s = $db->prepare('DELETE FROM topics WHERE id=?');
            $s->bind_param('i', $id);
            echo $s->execute() ? $ok('Topic deleted.') : $err('Failed: ' . $s->error);
            $s->close();
            break;

        /* ── PROJECTS ── */
        case 'project_create':
            $title = trim($input['title']        ?? '');
            $desc  = trim($input['description']  ?? '');
            $req   = trim($input['requirements'] ?? '');
            $diff  = trim($input['difficulty']   ?? 'Intermediate');
            if (!$title || !$desc || !$req) { echo $err('Title, description and requirements are required.'); break; }
            $s = $db->prepare('INSERT INTO projects (title,description,requirements,difficulty) VALUES (?,?,?,?)');
            $s->bind_param('ssss', $title, $desc, $req, $diff);
            if ($s->execute()) { echo $ok('Project created.', ['id' => $db->insert_id]); }
            else               { echo $err('Failed: ' . $s->error); }
            $s->close();
            break;

        case 'project_update':
            $id    = (int)   ($input['id']           ?? 0);
            $title = trim($input['title']        ?? '');
            $desc  = trim($input['description']  ?? '');
            $req   = trim($input['requirements'] ?? '');
            $diff  = trim($input['difficulty']   ?? 'Intermediate');
            if (!$id || !$title || !$desc || !$req) { echo $err('All fields required.'); break; }
            $s = $db->prepare('UPDATE projects SET title=?,description=?,requirements=?,difficulty=? WHERE id=?');
            $s->bind_param('ssssi', $title, $desc, $req, $diff, $id);
            echo $s->execute() ? $ok('Project updated.') : $err('Failed: ' . $s->error);
            $s->close();
            break;

        case 'project_delete':
            $id = (int)($input['id'] ?? 0);
            if (!$id) { echo $err('Invalid ID.'); break; }
            $s = $db->prepare('DELETE FROM projects WHERE id=?');
            $s->bind_param('i', $id);
            echo $s->execute() ? $ok('Project deleted.') : $err('Failed: ' . $s->error);
            $s->close();
            break;

        /* ── TOOLS ── */
        case 'tool_create':
            $name = trim($input['tool_name']   ?? '');
            $desc = trim($input['description'] ?? '');
            $url  = trim($input['url_path']    ?? '');
            if (!$name || !$desc || !$url) { echo $err('All fields required.'); break; }
            $s = $db->prepare('INSERT INTO simulation_tools (tool_name,description,url_path) VALUES (?,?,?)');
            $s->bind_param('sss', $name, $desc, $url);
            if ($s->execute()) { echo $ok('Tool created.', ['id' => $db->insert_id]); }
            else               { echo $err('Failed: ' . $s->error); }
            $s->close();
            break;

        case 'tool_update':
            $id   = (int)   ($input['id']          ?? 0);
            $name = trim($input['tool_name']   ?? '');
            $desc = trim($input['description'] ?? '');
            $url  = trim($input['url_path']    ?? '');
            if (!$id || !$name || !$desc || !$url) { echo $err('All fields required.'); break; }
            $s = $db->prepare('UPDATE simulation_tools SET tool_name=?,description=?,url_path=? WHERE id=?');
            $s->bind_param('sssi', $name, $desc, $url, $id);
            echo $s->execute() ? $ok('Tool updated.') : $err('Failed: ' . $s->error);
            $s->close();
            break;

        case 'tool_delete':
            $id = (int)($input['id'] ?? 0);
            if (!$id) { echo $err('Invalid ID.'); break; }
            $s = $db->prepare('DELETE FROM simulation_tools WHERE id=?');
            $s->bind_param('i', $id);
            echo $s->execute() ? $ok('Tool deleted.') : $err('Failed: ' . $s->error);
            $s->close();
            break;

        default:
            http_response_code(400);
            echo $err('Unknown action.');
    }
    exit;
}

/* ══════════════════════════════════════════════════════════════════════════════
   FETCH DATA FOR PAGE RENDER
══════════════════════════════════════════════════════════════════════════════ */
$topics   = $db->query('SELECT * FROM topics            ORDER BY topic_num ASC')->fetch_all(MYSQLI_ASSOC);
$projects = $db->query('SELECT * FROM projects          ORDER BY created_at DESC')->fetch_all(MYSQLI_ASSOC);
$tools    = $db->query('SELECT * FROM simulation_tools  ORDER BY id ASC')->fetch_all(MYSQLI_ASSOC);

$topic_count   = count($topics);
$project_count = count($projects);
$tool_count    = count($tools);

// Count students
$user_count = $db->query("SELECT COUNT(*) as c FROM users WHERE role='student'")->fetch_assoc()['c'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BICpES — Admin Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400;1,600&family=Manrope:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="user_design.css">
    <style>
    *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; text-decoration:none; }

    :root {
        --bg:         #101010;
        --bg-card:    #161616;
        --bg-raised:  #1e1e1e;
        --violet:     #9b46d4;
        --violet-dim: rgba(155,70,212,0.18);
        --violet-gl:  rgba(155,70,212,0.35);
        --white:      #f5f5f5;
        --w70:        rgba(245,245,245,0.70);
        --w40:        rgba(245,245,245,0.40);
        --w15:        rgba(245,245,245,0.15);
        --w08:        rgba(245,245,245,0.08);
        --border:     rgba(245,245,245,0.10);
        --border-v:   rgba(155,70,212,0.30);
        --red:        #f87171;
        --green:      #4ade80;
        --footer:     #160620;
    }

    html { scroll-behavior: smooth; }
    body { background: var(--bg); color: var(--white); font-family: 'Manrope', sans-serif;
           overflow-x: hidden; min-height: 100vh; }

    /* ── NAV ── */
    nav {
        position: fixed; top:0; left:0; right:0;
        display: flex; align-items: center;
        padding: 5px 20px;
        background: var(--bg);
        border-bottom: 1px solid var(--border);
        z-index: 200;
    }
    nav a { color: var(--white); font-family: Arial, sans-serif; font-size: 20px; padding: 10px 20px; }
    .left-side { display:flex; align-items:center; }
    .left-side img { width:75px; height:75px; border-radius:50%; }
    .nav-center { margin-left: auto; margin-right: 50px; }
    .nav-center span { color: var(--violet); }
    .right-side { display:flex; align-items:center; margin-left:auto; }

    /* ── LAYOUT ── */
    .admin-wrap {
        display: flex;
        min-height: 100vh;
        padding-top: 87px;
    }

    /* ── SIDEBAR ── */
    .sidebar {
        width: 240px;
        flex-shrink: 0;
        background: var(--bg-card);
        border-right: 1px solid var(--border);
        position: fixed;
        top: 87px; left: 0; bottom: 0;
        overflow-y: auto;
        z-index: 100;
        display: flex;
        flex-direction: column;
        gap: 4px;
        padding: 24px 12px;
    }

    .sidebar-label {
        font-size: 10px; letter-spacing: 3px; text-transform: uppercase;
        color: var(--w40); font-weight: 700;
        padding: 0 10px 8px; margin-top: 8px;
    }

    .sidebar-btn {
        display: flex; align-items: center; gap: 12px;
        padding: 11px 14px;
        border-radius: 12px;
        border: none; background: transparent;
        color: var(--w70); font-size: 13px; font-weight: 500;
        font-family: 'Manrope', sans-serif;
        cursor: pointer; width: 100%; text-align: left;
        transition: background .2s, color .2s;
    }
    .sidebar-btn:hover  { background: var(--w08); color: var(--white); }
    .sidebar-btn.active { background: var(--violet-dim); color: var(--white);
                          border: 1px solid var(--border-v); }
    .sidebar-btn .icon { font-size: 17px; width: 22px; text-align:center; }
    .sidebar-divider { height:1px; background: var(--border); margin: 10px 4px; }

    .stat-chips { display:flex; flex-direction:column; gap:6px; padding: 12px 10px; }
    .stat-chip {
        display:flex; align-items:center; justify-content:space-between;
        padding: 8px 12px; border-radius: 10px;
        background: var(--w08); border: 1px solid var(--border);
        font-size: 12px; color: var(--w70);
    }
    .stat-chip span { font-weight:700; color: var(--violet); font-size:14px; }

    /* ── MAIN CONTENT ── */
    .main-content {
        flex: 1;
        margin-left: 240px;
        padding: 40px 48px 80px;
        min-height: calc(100vh - 87px);
    }

    /* ── PAGE HEADER ── */
    .page-header {
        display: flex; align-items: flex-end;
        justify-content: space-between;
        margin-bottom: 36px;
        flex-wrap: wrap; gap: 16px;
    }
    .page-title {
        font-family: 'Cormorant Garamond', serif;
        font-size: clamp(36px, 5vw, 56px);
        font-weight: 700; line-height: 1.0;
        color: var(--white); letter-spacing: -1px;
    }
    .page-title em { font-style:italic; color: #b87ae8; }
    .page-subtitle { font-size: 13px; color: var(--w40); margin-top: 4px; }

    /* ── SECTION ── */
    .section { display: none; animation: fadeUp .4s ease both; }
    .section.active { display: block; }

    .section-head {
        display: flex; align-items: center;
        justify-content: space-between;
        margin-bottom: 24px; flex-wrap: wrap; gap: 12px;
    }
    .section-title {
        font-family: 'Cormorant Garamond', serif;
        font-size: 28px; font-weight: 600; color: var(--white);
    }

    /* ── ADD BUTTON ── */
    .btn-add {
        display: flex; align-items: center; gap: 8px;
        padding: 10px 20px;
        background: var(--violet); color: #fff;
        border: none; border-radius: 12px;
        font-size: 13px; font-weight: 600;
        font-family: 'Manrope', sans-serif;
        cursor: pointer;
        transition: background .2s, transform .2s, box-shadow .2s;
    }
    .btn-add:hover { background:#b060e8; transform:translateY(-1px); box-shadow:0 0 18px var(--violet-gl); }

    /* ── TABLE ── */
    .table-wrap {
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 16px;
        overflow: hidden;
    }
    table { width:100%; border-collapse:collapse; }
    thead tr { border-bottom: 1px solid var(--border); }
    th {
        font-size: 10px; letter-spacing: 2.5px; text-transform: uppercase;
        color: var(--w40); font-weight:700;
        padding: 14px 20px; text-align:left;
    }
    td {
        padding: 14px 20px;
        border-bottom: 1px solid var(--w08);
        font-size: 13px; color: var(--w70);
        vertical-align: middle;
    }
    tr:last-child td { border-bottom: none; }
    td:first-child { color: var(--white); font-weight:600; }

    .td-desc { max-width: 280px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
    .pill {
        display:inline-block; padding:3px 12px; border-radius:50px; font-size:11px; font-weight:700;
        background: var(--violet-dim); border: 1px solid var(--border-v); color: #cc88f5;
    }
    .pill.beg  { background:rgba(74,222,128,.12); border-color:rgba(74,222,128,.30); color:#4ade80; }
    .pill.int  { background:rgba(251,146,60,.12);  border-color:rgba(251,146,60,.30);  color:#fb923c; }
    .pill.adv  { background:rgba(248,113,113,.12); border-color:rgba(248,113,113,.30); color:#f87171; }

    .td-actions { display:flex; gap:8px; }
    .btn-icon {
        padding: 6px 14px; border-radius:8px; border:none;
        font-size:12px; font-weight:600; cursor:pointer;
        font-family:'Manrope',sans-serif; transition: all .2s;
    }
    .btn-edit   { background: var(--violet-dim); color:#cc88f5; border:1px solid var(--border-v); }
    .btn-edit:hover   { background:rgba(155,70,212,.30); color:var(--white); }
    .btn-delete { background:rgba(248,113,113,.10); color:var(--red); border:1px solid rgba(248,113,113,.25); }
    .btn-delete:hover { background:rgba(248,113,113,.22); }

    /* ── MODAL ── */
    .crud-overlay {
        position: fixed; inset:0; z-index:400;
        display:flex; align-items:center; justify-content:center;
        padding:20px;
        background: rgba(0,0,0,.75);
        backdrop-filter:blur(6px);
        opacity:0; pointer-events:none;
        transition: opacity .3s;
    }
    .crud-overlay.open { opacity:1; pointer-events:all; }

    .crud-box {
        width:100%; max-width:540px;
        background: var(--bg-card);
        border: 1px solid var(--border-v);
        border-radius: 20px; overflow:hidden;
        box-shadow: 0 32px 80px rgba(0,0,0,.7);
        transform: translateY(20px) scale(.97);
        opacity:0;
        transition: transform .35s cubic-bezier(.34,1.56,.64,1), opacity .25s;
    }
    .crud-overlay.open .crud-box { transform:translateY(0) scale(1); opacity:1; }

    .crud-header {
        display:flex; align-items:center; gap:14px;
        padding: 22px 24px 18px;
        background: linear-gradient(135deg,#2a0a50 0%,#9b46d4 100%);
    }
    .crud-icon {
        width:38px; height:38px; border-radius:10px;
        background:rgba(255,255,255,.15); border:1px solid rgba(255,255,255,.25);
        display:flex; align-items:center; justify-content:center;
        font-size:18px; flex-shrink:0;
    }
    .crud-title { font-size:17px; font-weight:700; color:#fff; font-family:'Manrope',sans-serif; }
    .crud-close {
        margin-left:auto; width:32px; height:32px; border-radius:50%;
        background:rgba(255,255,255,.12); border:1px solid rgba(255,255,255,.20);
        color:rgba(255,255,255,.80); font-size:20px; cursor:pointer;
        display:flex; align-items:center; justify-content:center;
        transition: background .2s, transform .2s;
    }
    .crud-close:hover { background:rgba(255,255,255,.25); transform:rotate(90deg); }

    .crud-body { padding:24px; display:flex; flex-direction:column; gap:16px; max-height:65vh; overflow-y:auto; }

    .field-group { display:flex; flex-direction:column; gap:7px; }
    .field-label {
        font-size:11px; letter-spacing:1.5px; text-transform:uppercase;
        font-weight:700; color:rgba(155,70,212,.90); font-family:'Manrope',sans-serif;
    }
    .field-input, .field-textarea, .field-select {
        padding:11px 14px;
        background: var(--bg-raised);
        border: 1.5px solid var(--border);
        border-radius:10px;
        color:var(--white); font-size:13px;
        font-family:'Manrope',sans-serif;
        outline:none;
        transition: border-color .25s, box-shadow .25s;
        width:100%;
    }
    .field-input:focus, .field-textarea:focus, .field-select:focus {
        border-color: rgba(155,70,212,.60);
        box-shadow: 0 0 0 3px rgba(155,70,212,.12);
    }
    .field-textarea { resize:vertical; min-height:90px; }
    .field-select option { background:#1e1e1e; }
    .field-row { display:flex; gap:12px; }
    .field-row .field-group { flex:1; }

    .crud-footer {
        display:flex; justify-content:flex-end; gap:10px;
        padding: 18px 24px;
        border-top: 1px solid var(--border);
    }
    .btn-cancel {
        padding:10px 22px; border-radius:10px; border:1px solid var(--border);
        background: var(--w08); color:var(--w40); font-size:13px; font-weight:600;
        font-family:'Manrope',sans-serif; cursor:pointer; transition:all .2s;
    }
    .btn-cancel:hover { background:var(--w15); color:var(--white); }
    .btn-save {
        padding:10px 22px; border-radius:10px; border:1px solid rgba(155,70,212,.50);
        background: var(--violet); color:#fff; font-size:13px; font-weight:600;
        font-family:'Manrope',sans-serif; cursor:pointer; transition:all .2s;
    }
    .btn-save:hover { background:#b060e8; box-shadow:0 0 16px var(--violet-gl); transform:translateY(-1px); }
    .btn-save.success { background:#2e7d4f; border-color:#2e7d4f; }

    /* ── CONFIRM DELETE ── */
    .confirm-overlay {
        position:fixed; inset:0; z-index:500;
        display:flex; align-items:center; justify-content:center;
        background:rgba(0,0,0,.80); backdrop-filter:blur(6px);
        opacity:0; pointer-events:none; transition:opacity .25s;
    }
    .confirm-overlay.open { opacity:1; pointer-events:all; }
    .confirm-box {
        background:var(--bg-card); border:1px solid rgba(248,113,113,.30);
        border-radius:18px; padding:32px; max-width:380px; width:100%;
        text-align:center;
        transform:scale(.95); opacity:0;
        transition:transform .3s cubic-bezier(.34,1.56,.64,1), opacity .25s;
    }
    .confirm-overlay.open .confirm-box { transform:scale(1); opacity:1; }
    .confirm-icon { font-size:36px; margin-bottom:14px; }
    .confirm-title { font-size:18px; font-weight:700; color:var(--white); margin-bottom:8px; }
    .confirm-sub { font-size:13px; color:var(--w70); line-height:1.6; margin-bottom:24px; }
    .confirm-btns { display:flex; gap:10px; justify-content:center; }
    .btn-confirm-del {
        padding:10px 24px; border-radius:10px;
        background:rgba(248,113,113,.15); border:1px solid rgba(248,113,113,.40);
        color:var(--red); font-size:13px; font-weight:700;
        font-family:'Manrope',sans-serif; cursor:pointer; transition:all .2s;
    }
    .btn-confirm-del:hover { background:rgba(248,113,113,.28); }

    /* ── TOAST ── */
    .toast {
        position:fixed; bottom:28px; right:28px; z-index:9999;
        padding:14px 20px; border-radius:12px;
        font-size:13px; font-weight:600; font-family:'Manrope',sans-serif;
        display:flex; align-items:center; gap:10px;
        transform:translateY(80px); opacity:0;
        transition:transform .35s cubic-bezier(.34,1.56,.64,1), opacity .3s;
        pointer-events:none; max-width:340px;
    }
    .toast.show { transform:translateY(0); opacity:1; }
    .toast.ok  { background:#1a3a28; border:1px solid rgba(74,222,128,.35); color:var(--green); }
    .toast.err { background:#3a1a1a; border:1px solid rgba(248,113,113,.35); color:var(--red); }

    /* ── EMPTY STATE ── */
    .empty {
        text-align:center; padding:48px 24px; color:var(--w40); font-size:14px;
    }
    .empty-icon { font-size:36px; margin-bottom:12px; }

    /* ── FOOTER ── */
    footer { margin-left:240px; padding:30px 48px; text-align:center;
             background:var(--footer); color:rgba(255,255,255,.40); font-size:12px; }

    @keyframes fadeUp { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <a href="main.php" class="left-side"><img src="Images/Logo/BICpES Learning Hub Logo.png" alt="Logo"></a>
    <div class="nav-center">
        <a href="main.php"><span><strong>BICpES</strong></span> Learning Hub</a>
    </div>
    <div class="right-side">
        <?php echo nav_right_html(); ?>
    </div>
</nav>

<div class="admin-wrap">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-label">Overview</div>
        <div class="stat-chips">
            <div class="stat-chip">Topics   <span><?= $topic_count ?></span></div>
            <div class="stat-chip">Projects <span><?= $project_count ?></span></div>
            <div class="stat-chip">Tools    <span><?= $tool_count ?></span></div>
            <div class="stat-chip">Students <span><?= $user_count ?></span></div>
        </div>

        <div class="sidebar-divider"></div>
        <div class="sidebar-label">Manage</div>

        <button class="sidebar-btn active" data-tab="topics">
            <span class="icon">📚</span> Topics
        </button>
        <button class="sidebar-btn" data-tab="projects">
            <span class="icon">🔧</span> Projects
        </button>
        <button class="sidebar-btn" data-tab="tools">
            <span class="icon">💻</span> Sim Tools
        </button>

        <div class="sidebar-divider"></div>
        <button class="sidebar-btn" onclick="location.href='main.php'">
            <span class="icon">🏠</span> Back to Site
        </button>
    </aside>

    <!-- MAIN -->
    <main class="main-content">
        <div class="page-header">
            <div>
                <div class="page-title">Admin <em>Dashboard</em></div>
                <div class="page-subtitle">Manage platform content — Topics, Projects, and Tools</div>
            </div>
        </div>

        <!-- ═══ TOPICS SECTION ═══ -->
        <div class="section active" id="tab-topics">
            <div class="section-head">
                <div class="section-title">Topics</div>
                <button class="btn-add" onclick="openCrud('topic','create')">＋ Add Topic</button>
            </div>
            <div class="table-wrap">
                <?php if (empty($topics)): ?>
                    <div class="empty"><div class="empty-icon">📭</div>No topics yet. Add one!</div>
                <?php else: ?>
                <table>
                    <thead><tr>
                        <th>#</th><th>Name</th><th>Category</th><th>Description</th><th>Actions</th>
                    </tr></thead>
                    <tbody>
                    <?php foreach ($topics as $t): ?>
                    <tr>
                        <td><span class="pill"><?= str_pad($t['topic_num'],2,'0',STR_PAD_LEFT) ?></span></td>
                        <td><?= htmlspecialchars($t['name']) ?></td>
                        <td><?= htmlspecialchars($t['category']) ?></td>
                        <td class="td-desc"><?= htmlspecialchars($t['description']) ?></td>
                        <td><div class="td-actions">
                            <button class="btn-icon btn-edit"
                                onclick='openCrud("topic","edit",<?= json_encode($t) ?>)'>Edit</button>
                            <button class="btn-icon btn-delete"
                                onclick='confirmDelete("topic",<?= $t["id"] ?>,"<?= htmlspecialchars(addslashes($t["name"])) ?>")'>Delete</button>
                        </div></td>
                    </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
                <?php endif; ?>
            </div>
        </div>

        <!-- ═══ PROJECTS SECTION ═══ -->
        <div class="section" id="tab-projects">
            <div class="section-head">
                <div class="section-title">Projects</div>
                <button class="btn-add" onclick="openCrud('project','create')">＋ Add Project</button>
            </div>
            <div class="table-wrap">
                <?php if (empty($projects)): ?>
                    <div class="empty"><div class="empty-icon">📭</div>No projects yet. Add one!</div>
                <?php else: ?>
                <table>
                    <thead><tr>
                        <th>Title</th><th>Difficulty</th><th>Description</th><th>Actions</th>
                    </tr></thead>
                    <tbody>
                    <?php foreach ($projects as $p): ?>
                    <tr>
                        <td><?= htmlspecialchars($p['title']) ?></td>
                        <td><span class="pill <?= strtolower(substr($p['difficulty'],0,3)) ?>">
                            <?= $p['difficulty'] ?></span></td>
                        <td class="td-desc"><?= htmlspecialchars($p['description']) ?></td>
                        <td><div class="td-actions">
                            <button class="btn-icon btn-edit"
                                onclick='openCrud("project","edit",<?= json_encode($p) ?>)'>Edit</button>
                            <button class="btn-icon btn-delete"
                                onclick='confirmDelete("project",<?= $p["id"] ?>,"<?= htmlspecialchars(addslashes($p["title"])) ?>")'>Delete</button>
                        </div></td>
                    </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
                <?php endif; ?>
            </div>
        </div>

        <!-- ═══ TOOLS SECTION ═══ -->
        <div class="section" id="tab-tools">
            <div class="section-head">
                <div class="section-title">Simulation Tools</div>
                <button class="btn-add" onclick="openCrud('tool','create')">＋ Add Tool</button>
            </div>
            <div class="table-wrap">
                <?php if (empty($tools)): ?>
                    <div class="empty"><div class="empty-icon">📭</div>No tools yet. Add one!</div>
                <?php else: ?>
                <table>
                    <thead><tr>
                        <th>Tool Name</th><th>URL / Path</th><th>Description</th><th>Actions</th>
                    </tr></thead>
                    <tbody>
                    <?php foreach ($tools as $tl): ?>
                    <tr>
                        <td><?= htmlspecialchars($tl['tool_name']) ?></td>
                        <td><code style="font-size:11px;color:#cc88f5;"><?= htmlspecialchars($tl['url_path']) ?></code></td>
                        <td class="td-desc"><?= htmlspecialchars($tl['description']) ?></td>
                        <td><div class="td-actions">
                            <button class="btn-icon btn-edit"
                                onclick='openCrud("tool","edit",<?= json_encode($tl) ?>)'>Edit</button>
                            <button class="btn-icon btn-delete"
                                onclick='confirmDelete("tool",<?= $tl["id"] ?>,"<?= htmlspecialchars(addslashes($tl["tool_name"])) ?>")'>Delete</button>
                        </div></td>
                    </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
                <?php endif; ?>
            </div>
        </div>

    </main>
</div>

<footer>© 2026 BICpES Learning Hub — Admin Panel</footer>

<!-- ══ CRUD MODAL ══ -->
<div class="crud-overlay" id="crudOverlay">
    <div class="crud-box">
        <div class="crud-header">
            <div class="crud-icon" id="crudIcon">📝</div>
            <div class="crud-title" id="crudTitle">Add Topic</div>
            <button class="crud-close" onclick="closeCrud()">×</button>
        </div>
        <div class="crud-body" id="crudBody"><!-- dynamic --></div>
        <div class="crud-footer">
            <button class="btn-cancel" onclick="closeCrud()">Cancel</button>
            <button class="btn-save" id="btnSave" onclick="saveCrud()">Save</button>
        </div>
    </div>
</div>

<!-- ══ DELETE CONFIRM ══ -->
<div class="confirm-overlay" id="confirmOverlay">
    <div class="confirm-box">
        <div class="confirm-icon">🗑️</div>
        <div class="confirm-title">Delete this item?</div>
        <div class="confirm-sub" id="confirmSub">This action cannot be undone.</div>
        <div class="confirm-btns">
            <button class="btn-cancel" onclick="closeConfirm()">Cancel</button>
            <button class="btn-confirm-del" id="btnConfirmDel">Yes, Delete</button>
        </div>
    </div>
</div>

<!-- ══ TOAST ══ -->
<div class="toast" id="toast"></div>

<?php echo nav_scripts_html(); ?>

<script>
/* ── STATE ── */
let crudType = '';   // 'topic' | 'project' | 'tool'
let crudMode = '';   // 'create' | 'edit'
let crudId   = 0;

/* ── TAB SWITCHING ── */
document.querySelectorAll('.sidebar-btn[data-tab]').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.sidebar-btn[data-tab]').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
    });
});

/* ── FORM DEFINITIONS ── */
const forms = {
    topic: {
        icon: '📚', label: 'Topic',
        create: (d={}) => `
            <div class="field-row">
                <div class="field-group" style="max-width:100px">
                    <label class="field-label">Topic #</label>
                    <input class="field-input" id="f_topic_num" type="number" min="1" value="${d.topic_num||''}" placeholder="01">
                </div>
                <div class="field-group">
                    <label class="field-label">Name</label>
                    <input class="field-input" id="f_name" type="text" value="${esc(d.name||'')}" placeholder="e.g. Basic Circuit Theory">
                </div>
            </div>
            <div class="field-group">
                <label class="field-label">Category</label>
                <select class="field-select" id="f_category">
                    ${['Circuits & Electronics','Digital Systems','Embedded & Programming','Soldering & Fabrication']
                        .map(c=>`<option value="${c}"${(d.category||'')==c?' selected':''}>${c}</option>`).join('')}
                </select>
            </div>
            <div class="field-group">
                <label class="field-label">Description</label>
                <textarea class="field-textarea" id="f_description" placeholder="Brief description of this topic...">${esc(d.description||'')}</textarea>
            </div>`,
    },
    project: {
        icon: '🔧', label: 'Project',
        create: (d={}) => `
            <div class="field-group">
                <label class="field-label">Title</label>
                <input class="field-input" id="f_title" type="text" value="${esc(d.title||'')}" placeholder="e.g. Smart Home Controller">
            </div>
            <div class="field-group">
                <label class="field-label">Difficulty</label>
                <select class="field-select" id="f_difficulty">
                    ${['Beginner','Intermediate','Advanced']
                        .map(d2=>`<option value="${d2}"${(d.difficulty||'Intermediate')==d2?' selected':''}>${d2}</option>`).join('')}
                </select>
            </div>
            <div class="field-group">
                <label class="field-label">Description</label>
                <textarea class="field-textarea" id="f_description" placeholder="Overview of the project...">${esc(d.description||'')}</textarea>
            </div>
            <div class="field-group">
                <label class="field-label">Requirements / Parts List</label>
                <textarea class="field-textarea" id="f_requirements" placeholder="List components, tools, prerequisites...">${esc(d.requirements||'')}</textarea>
            </div>`,
    },
    tool: {
        icon: '💻', label: 'Simulation Tool',
        create: (d={}) => `
            <div class="field-group">
                <label class="field-label">Tool Name</label>
                <input class="field-input" id="f_tool_name" type="text" value="${esc(d.tool_name||'')}" placeholder="e.g. MULTISIM">
            </div>
            <div class="field-group">
                <label class="field-label">URL / Page Path</label>
                <input class="field-input" id="f_url_path" type="text" value="${esc(d.url_path||'')}" placeholder="e.g. multisim_view.html">
            </div>
            <div class="field-group">
                <label class="field-label">Description</label>
                <textarea class="field-textarea" id="f_description" placeholder="What does this tool do?">${esc(d.description||'')}</textarea>
            </div>`,
    },
};

function esc(s) {
    return String(s).replace(/&/g,'&amp;').replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

/* ── OPEN CRUD ── */
function openCrud(type, mode, data={}) {
    crudType = type; crudMode = mode; crudId = data.id || 0;
    const f = forms[type];
    document.getElementById('crudIcon').textContent  = f.icon;
    document.getElementById('crudTitle').textContent = (mode==='create'?'Add ':'Edit ') + f.label;
    document.getElementById('crudBody').innerHTML    = f.create(data);
    document.getElementById('btnSave').textContent   = mode==='create' ? 'Create' : 'Save Changes';
    document.getElementById('btnSave').classList.remove('success');
    document.getElementById('crudOverlay').classList.add('open');
}
function closeCrud() { document.getElementById('crudOverlay').classList.remove('open'); }

/* ── SAVE ── */
async function saveCrud() {
    const g = id => document.getElementById(id)?.value ?? '';
    let payload = { action: '' };

    if (crudType === 'topic') {
        payload = { action: 'topic_' + crudMode, topic_num: +g('f_topic_num'),
                    name: g('f_name'), description: g('f_description'), category: g('f_category') };
    } else if (crudType === 'project') {
        payload = { action: 'project_' + crudMode, title: g('f_title'),
                    description: g('f_description'), requirements: g('f_requirements'), difficulty: g('f_difficulty') };
    } else if (crudType === 'tool') {
        payload = { action: 'tool_' + crudMode, tool_name: g('f_tool_name'),
                    description: g('f_description'), url_path: g('f_url_path') };
    }

    if (crudMode === 'edit') payload.id = crudId;

    const res = await api(payload);
    if (res.success) {
        const btn = document.getElementById('btnSave');
        btn.textContent = '✓ Saved!'; btn.classList.add('success');
        toast('ok', res.message);
        setTimeout(() => { closeCrud(); location.reload(); }, 900);
    } else {
        toast('err', res.message);
    }
}

/* ── DELETE CONFIRM ── */
let pendingDelete = null;
function confirmDelete(type, id, name) {
    pendingDelete = { type, id };
    document.getElementById('confirmSub').textContent = `"${name}" will be permanently removed.`;
    document.getElementById('confirmOverlay').classList.add('open');
    document.getElementById('btnConfirmDel').onclick = doDelete;
}
function closeConfirm() { document.getElementById('confirmOverlay').classList.remove('open'); pendingDelete = null; }

async function doDelete() {
    if (!pendingDelete) return;
    const res = await api({ action: pendingDelete.type + '_delete', id: pendingDelete.id });
    closeConfirm();
    if (res.success) { toast('ok', res.message); setTimeout(() => location.reload(), 800); }
    else              { toast('err', res.message); }
}

/* ── API HELPER ── */
async function api(payload) {
    try {
        const r = await fetch('admin_dashboard.php', {
            method:'POST', headers:{'Content-Type':'application/json'},
            body: JSON.stringify(payload),
        });
        return await r.json();
    } catch { return { success:false, message:'Network error.' }; }
}

/* ── TOAST ── */
let toastTimer;
function toast(type, msg) {
    const el = document.getElementById('toast');
    el.className = `toast ${type}`;
    el.textContent = (type==='ok'?'✓ ':'✗ ') + msg;
    el.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => el.classList.remove('show'), 3200);
}

/* ── ESC TO CLOSE ── */
document.addEventListener('keydown', e => {
    if (e.key === 'Escape') { closeCrud(); closeConfirm(); }
});
</script>
</body>
</html>
