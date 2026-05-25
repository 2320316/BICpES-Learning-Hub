<?php
/**
 * reset_admin_password.php — BICpES Learning Hub
 * ─────────────────────────────────────────────────────────────────────────────
 * ONE-TIME USE TOOL. Run this in your browser ONCE to set the admin password
 * to "Admin@BICpES2026" using a proper PHP-generated bcrypt hash.
 *
 * HOW TO USE:
 *   1. Place this file in the root of your project (same folder as auth.php).
 *   2. Visit: http://localhost/your-project/reset_admin_password.php
 *   3. Confirm the success message.
 *   4. DELETE THIS FILE immediately. Never leave it on a live server.
 *
 * SECURITY: This file has a hardcoded secret token. Change RESET_TOKEN below
 * before deploying, or just delete the file right after use.
 * ─────────────────────────────────────────────────────────────────────────────
 */

// ── Simple one-time secret to prevent accidental / malicious resets ──────────
define('RESET_TOKEN', 'bicpes-reset-2026');   // ← change or remove after use

$token_ok = ($_GET['token'] ?? '') === RESET_TOKEN;

require_once __DIR__ . '/db_connect.php';

// ── What we want to set ───────────────────────────────────────────────────────
$new_password = 'Admin@BICpES2026';
$new_hash     = password_hash($new_password, PASSWORD_BCRYPT, ['cost' => 12]);

$result_msg   = '';
$result_ok    = false;

if ($token_ok && $_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $db   = get_db();
        $stmt = $db->prepare(
            "UPDATE users SET password_hash = ? WHERE role = 'admin' AND student_number IS NULL LIMIT 1"
        );
        $stmt->bind_param('s', $new_hash);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            $result_ok  = true;
            $result_msg = '✅ Admin password successfully updated to <strong>Admin@BICpES2026</strong>. '
                        . 'Delete this file now and log in at main.php.';
        } else {
            $result_msg = '⚠ No admin account found (student_number IS NULL, role = admin). '
                        . 'Did you import schema.sql first?';
        }
        $stmt->close();
    } catch (RuntimeException $e) {
        $result_msg = '❌ Database error: ' . htmlspecialchars($e->getMessage());
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>BICpES — Reset Admin Password</title>
<style>
  body { font-family: 'Segoe UI', sans-serif; background:#0e0e0e; color:#f5f5f5;
         display:flex; align-items:center; justify-content:center; min-height:100vh; margin:0; }
  .card { background:#161616; border:1px solid rgba(155,70,212,.35); border-radius:16px;
          padding:40px 48px; max-width:520px; width:100%; box-shadow:0 24px 60px rgba(0,0,0,.6); }
  h1  { font-size:22px; margin:0 0 6px; color:#cc88f5; }
  p   { font-size:14px; color:rgba(245,245,245,.65); line-height:1.7; }
  .warn { background:rgba(248,113,113,.10); border:1px solid rgba(248,113,113,.35);
          border-radius:10px; padding:14px 18px; font-size:13px; color:#fca5a5;
          margin:18px 0; }
  .info { background:rgba(155,70,212,.12); border:1px solid rgba(155,70,212,.30);
          border-radius:10px; padding:14px 18px; font-size:13px; color:#cc88f5;
          margin:18px 0; }
  .ok   { background:rgba(74,222,128,.10); border:1px solid rgba(74,222,128,.30);
          border-radius:10px; padding:14px 18px; font-size:13px; color:#4ade80;
          margin:18px 0; }
  button { width:100%; padding:14px; background:#9b46d4; color:#fff;
           border:none; border-radius:10px; font-size:15px; font-weight:600;
           cursor:pointer; margin-top:10px; transition:background .2s; }
  button:hover { background:#b060e8; }
  code { background:rgba(155,70,212,.15); padding:2px 8px; border-radius:4px;
         font-family:monospace; font-size:13px; color:#cc88f5; }
</style>
</head>
<body>
<div class="card">
  <h1>🔑 Reset Admin Password</h1>
  <p>This tool sets the admin account password to <code>Admin@BICpES2026</code> using a correct PHP bcrypt hash.</p>

  <?php if (!$token_ok): ?>
    <div class="warn">
      <strong>Access token required.</strong><br>
      Append <code>?token=<?= RESET_TOKEN ?></code> to the URL to proceed.
    </div>
  <?php elseif ($result_msg): ?>
    <div class="<?= $result_ok ? 'ok' : 'warn' ?>"><?= $result_msg ?></div>
    <?php if ($result_ok): ?>
      <p>Now go to <a href="main.php" style="color:#9b46d4;">main.php</a> and log in with:<br>
         Identifier: <code>ADMIN</code> &nbsp;|&nbsp; Password: <code>Admin@BICpES2026</code></p>
    <?php endif; ?>
  <?php else: ?>
    <div class="info">
      <strong>What this does:</strong><br>
      Runs <code>password_hash('Admin@BICpES2026', PASSWORD_BCRYPT, ['cost'=>12])</code> and
      updates the admin row in the <code>users</code> table. Safe to run multiple times.
    </div>
    <div class="warn">
      <strong>⚠ Security reminder:</strong> Delete this file immediately after use.
      Never leave password reset tools on a public-facing server.
    </div>
    <form method="post">
      <button type="submit">Set Admin Password Now</button>
    </form>
  <?php endif; ?>
</div>
</body>
</html>