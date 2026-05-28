/**
 * Navigation and Form Handler
 */

document.addEventListener('DOMContentLoaded', () => {
    initLoginForms();
    initSkillTabs();
    initScrollEffects();
});

/**
 * Initialize login and signup forms
 */
function initLoginForms() {
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const container = document.getElementById('login');
    const closeBtn = document.querySelector('.close_btn');
    const loginForm = document.getElementById('loginForm');
    const signupForm = document.getElementById('signupForm');

    if (signUpButton) {
        signUpButton.addEventListener('click', () => {
            container.classList.add("right-panel-active");
            if (closeBtn) closeBtn.style.color = "#9b46d4";
        });
    }

    if (signInButton) {
        signInButton.addEventListener('click', () => {
            container.classList.remove("right-panel-active");
            if (closeBtn) closeBtn.style.color = "#efefef";
        });
    }

    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            container.style.display = 'none';
        });
    }

    // Login form submission
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const studentNumber = document.getElementById('loginStudentNumber').value;
            const password = document.getElementById('loginPassword').value;
            
            const success = await window.auth.login(studentNumber, password);
            if (success) {
                loginForm.reset();
                container.style.display = 'none';
            }
        });
    }

    // Signup form submission
    if (signupForm) {
        signupForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const studentNumber = document.getElementById('signupStudentNumber').value;
            const firstName = document.getElementById('signupFirstName').value;
            const lastName = document.getElementById('signupLastName').value;
            const birthdate = document.getElementById('signupBirthdate').value;
            const password = document.getElementById('signupPassword').value;
            const confirmPassword = document.getElementById('signupConfirmPassword').value;
            
            const success = await window.auth.signUp(studentNumber, firstName, lastName, birthdate, password, confirmPassword);
            if (success) {
                signupForm.reset();
                container.style.display = 'none';
            }
        });
    }
}

/**
 * Initialize skill tabs
 */
function initSkillTabs() {
    const tabs = document.querySelectorAll('li.skill-tab');
    const imgs = {
        solving:   document.getElementById('skill-img-solving'),
        designing: document.getElementById('skill-img-designing'),
        etching:   document.getElementById('skill-img-etching'),
        soldering: document.getElementById('skill-img-soldering')
    };

    if (tabs.length === 0) return;

    // Hide all images immediately on load
    Object.values(imgs).forEach(function(img) {
        if (img) {
            img.style.visibility = 'hidden';
            img.style.opacity    = '0';
        }
    });

    // Remove active highlight from all tabs
    function clearTabs() {
        tabs.forEach(function(t) {
            t.style.color            = '';
            t.style.backgroundColor  = '';
            t.style.borderRadius     = '';
            t.style.padding          = '';
        });
    }

    // Show one skill: highlight tab + show matching image
    function showSkill(key) {
        // Hide all images
        Object.values(imgs).forEach(function(img) {
            if (img) {
                img.style.visibility = 'hidden';
                img.style.opacity    = '0';
            }
        });

        // Clear all tab highlights
        clearTabs();

        // Highlight the active tab
        const activeTab = document.querySelector('li.skill-tab[data-skill="' + key + '"]');
        if (activeTab) {
            activeTab.style.color           = '#101010';
            activeTab.style.backgroundColor = '#ffffff';
            activeTab.style.borderRadius    = '50px';
            activeTab.style.padding         = '18px 22px';
        }

        // Show the matching image
        const img = imgs[key];
        if (img) {
            img.style.visibility = 'visible';
            img.style.opacity    = '1';
        }
    }

    // Attach click to each tab
    tabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            showSkill(tab.dataset.skill);
        });
    });

    // Default: show Solving on page load
    showSkill('solving');
}

/**
 * Initialize scroll effects
 */
function initScrollEffects() {
    window.addEventListener('scroll', () => {
        const headings = document.querySelector('.headings');
        const button = document.querySelector('.learn');
        
        const scrollY = window.scrollY;
        const triggerPoint = 400;

        let progress = scrollY / triggerPoint;
        progress = Math.min(Math.max(progress, 0), 1);

        const scale = 1 - (progress * 0.3);
        const opacity = 1 - progress;

        if (headings) {
            headings.style.transform = `scale(${scale})`;
            headings.style.opacity = opacity;
        }

        if (button) {
            button.style.transform = `scale(${scale})`;
            button.style.opacity = opacity;
        }
    });
}
