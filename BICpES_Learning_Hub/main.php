<?php require_once __DIR__ . '/auth.php'; ?>
<?php require_once __DIR__ . '/nav_auth.php'; ?>
<?php
// ── Fetch first 3 projects and topics for homepage previews ──────────────────
$db = get_db();

$home_projects = [];
$home_topics   = [];

try {
    $res = $db->query('SELECT id, title, category, difficulty, year FROM projects ORDER BY id ASC LIMIT 3');
    if ($res) $home_projects = $res->fetch_all(MYSQLI_ASSOC);
} catch (Exception $e) { /* non-fatal */ }

try {
    $res = $db->query('SELECT id, topic_num, name, category FROM topics ORDER BY topic_num ASC LIMIT 3');
    if ($res) $home_topics = $res->fetch_all(MYSQLI_ASSOC);
} catch (Exception $e) { /* non-fatal */ }

// Placeholder gradient classes for project cards on home page
$ph_classes = ['p1','p2','p3','p4','p5','p6','p7','p8','p9'];
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" type="text/css" href="design.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400;1,600&family=Manrope:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="user_design.css">
        <script src="script.js"></script>
        <title>BICpES Learning Hub</title>
        <style>
            html { scroll-behavior: smooth; }
        </style>
    </head>

    <body>
        <nav>
            <a href="#home" class="left-side"><img src="Images/Logo/BICpES Learning Hub Logo.png" alt="Logo"></a>

            <div class="center">
                <a href="#about_us">About Us</a>
                <a href="#topics">Topics</a>
                <a href="#projects">Projects</a>
                <a href="#tools">Tools</a>
            </div>

            <div class="right-side">
                <?php echo nav_right_html(); ?>
            </div>
        </nav>

        <!-- Login/Signup Form -->
        <section class="container-log" id="login">
            <div class="log-container">
                <a href="#stay" class="close_btn">&times;</a>
                <div class="new_acc">
                    <form>
                        <h1>Create Account</h1>
                        <input type="number" placeholder="Student Number"/><br>
                        <input type="text" placeholder="Last Name"/><br>
                        <input type="text" placeholder="First Name"/><br>
                        <input type="date" name="birthdate"/><br>
                        <input type="password" placeholder="Password"/><br>
                        <input type="password" placeholder="Confirm Password"/><br>
                        <button type="submit">Sign Up</button>
                    </form>
                </div>

                <div class="old_acc">
                    <form>
                        <h1>Login</h1>
                        <p style="font-size:12px;color:rgba(245,245,245,.55);margin-bottom:8px;line-height:1.5;">
                            Students: enter your Student Number.<br>
                            Admin: enter <strong>ADMIN</strong> as the identifier.
                        </p>
                        <input type="text" placeholder="Student Number / ADMIN"/><br>
                        <input type="password" placeholder="Password"/><br>
                        <button type="submit">Login</button>
                    </form>
                </div>

                <div class="overlay-container">
                    <div class="overlay">
                        <div class="overlay_left">
                            <h1>Welcome Back!</h1>
                            <p>Explore more with us — please login with your existing account</p>
                            <button id="signIn">Login</button>
                        </div>
                        <div class="overlay_right">
                            <h1>Hello, Fellow CPE Student!</h1>
                            <p>Enter your personal details and start your journey with us</p>
                            <button id="signUp">Sign Up</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="home">
            <div class="headings">
                <h1>BICpES Learning Hub</h1>
                <h2>Discover, Learn, and Grow with us</h2>
                <h3>Explore topics, tools, and concepts that will guide you through your CpE journey</h3>
            </div>
            <a href="#login"><button class="learn">Start Learning</button></a>

            <div class="skills_box">
                <div class="box"></div>
                <div class="box_in"></div>
            </div>
        </section>

        <section id="skills">
            <ul>
                <li>Solving</li>
                <li>Designing</li>
                <li>Etching</li>
                <li>Soldering</li>
            </ul>
        </section>

        <!-- ── PROJECTS SECTION ─────────────────────────────────────────── -->
        <section id="projects">
            <h1>Projects</h1>
            <div class="projects_container">
                <?php if (!empty($home_projects)): ?>
                    <?php foreach ($home_projects as $i => $proj): ?>
                        <?php $ph = $ph_classes[$i % count($ph_classes)]; ?>
                        <?php if (is_logged_in()): ?>
                            <a class="project_box" href="project_view.php?id=<?= $proj['id'] ?>">
                                <img src="Images/Sample.png" alt="<?= htmlspecialchars($proj['title']) ?>">
                                <p><?= htmlspecialchars($proj['title']) ?></p>
                            </a>
                        <?php else: ?>
                            <a class="project_box" href="#login">
                                <img src="Images/Sample.png" alt="<?= htmlspecialchars($proj['title']) ?>">
                                <p><?= htmlspecialchars($proj['title']) ?></p>
                            </a>
                        <?php endif; ?>
                    <?php endforeach; ?>
                <?php else: ?>
                    <?php /* Fallback if DB is empty */ ?>
                    <?php for ($i = 1; $i <= 3; $i++): ?>
                        <a class="project_box" href="<?= is_logged_in() ? 'project_view.php' : '#login' ?>">
                            <img src="Images/Sample.png" alt="Project <?= $i ?>">
                            <p>Project <?= $i ?></p>
                        </a>
                    <?php endfor; ?>
                <?php endif; ?>
            </div>
            <?php if (is_logged_in()): ?>
                <a href="projects_section.php"><h2>VIEW MORE</h2></a>
            <?php else: ?>
                <a href="#login"><h2>VIEW MORE</h2></a>
            <?php endif; ?>
        </section>

        <!-- ── TOPICS SECTION ──────────────────────────────────────────── -->
        <section id="topics">
            <div class="topics_container">
                <h1>Topics</h1>
                <?php if (!empty($home_topics)): ?>
                    <?php foreach ($home_topics as $topic): ?>
                        <?php if (is_logged_in()): ?>
                            <a href="topic_view.php?id=<?= $topic['id'] ?>">
                                <p><?= htmlspecialchars($topic['name']) ?></p>
                            </a>
                        <?php else: ?>
                            <a href="#login">
                                <p><?= htmlspecialchars($topic['name']) ?></p>
                            </a>
                        <?php endif; ?>
                    <?php endforeach; ?>
                <?php else: ?>
                    <?php for ($i = 1; $i <= 3; $i++): ?>
                        <a href="<?= is_logged_in() ? 'topic_view.php' : '#login' ?>">
                            <p>Topic <?= $i ?></p>
                        </a>
                    <?php endfor; ?>
                <?php endif; ?>
                <?php if (is_logged_in()): ?>
                    <a href="topics_section.php"><h2>VIEW MORE</h2></a>
                <?php else: ?>
                    <a href="#login"><h2>VIEW MORE</h2></a>
                <?php endif; ?>
            </div>

            <div class="right_box">
                <div class="inside_right_box"></div>
            </div>

            <div class="under_box"></div>
        </section>

        <section id="tools">
            <h1>Simulation Tools</h1>
            <div class="simulation_tools">
                <?php if (is_logged_in()): ?>
                    <a href="multisim_view.html" class="tool_box_border">
                        <span class="tool_title">MULTISIM</span>
                        <p>Description for MULTISIM</p>
                    </a>
                    <a href="tinkercad_view.html" class="tool_box_border">
                        <span class="tool_title">TINKERCAD</span>
                        <p>Description for TINKERCAD</p>
                    </a>
                <?php else: ?>
                    <a href="#login" class="tool_box_border">
                        <span class="tool_title">MULTISIM</span>
                        <p>Description for MULTISIM</p>
                    </a>
                    <a href="#login" class="tool_box_border">
                        <span class="tool_title">TINKERCAD</span>
                        <p>Description for TINKERCAD</p>
                    </a>
                <?php endif; ?>
            </div>
        </section>

        <section id="about_us">
            <div class="left_box">About Us Description</div>
            <div class="about_text"><p>About Us</p></div>
        </section>

        <footer class="footer">
            <p>@ 2026 BICpES Learning Hub | Do not share my personal information</p>
            <div class="links">
                <a href="https://www.facebook.com/BICpES" target="_blank"><strong>Facebook</strong></a>
            </div>
        </footer>

        <?php echo nav_scripts_html(); ?>
    </body>
</html>