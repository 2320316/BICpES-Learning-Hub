// Front Page Hero Section Fade
window.addEventListener('scroll', () => {
        const headings = document.querySelector('.headings');
        const button = document.querySelector('.learn');
        
        const scrollY = window.scrollY;
        const triggerPoint = 400; // The scroll distance where they fully disappear

        // Calculate progress (0 to 1)
        let progress = scrollY / triggerPoint;
        progress = Math.min(Math.max(progress, 0), 1);

        const scale = 1 - (progress * 0.3); // Scales from 100% to 70%
        const opacity = 1 - progress;       // Fades from 100% to 0%

        // Apply to Headings
        if (headings) {
            headings.style.transform = `scale(${scale})`;
            headings.style.opacity = opacity;
        }

        // Apply to Button
        if (button) {
            button.style.transform = `scale(${scale})`;
            button.style.opacity = opacity;
        }
    });

// Login
document.addEventListener("DOMContentLoaded", () => {

    // Login/Signup Form Script
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const container = document.getElementById('login');
    const closeBtn = document.querySelector('.close_btn');

    signUpButton.addEventListener('click', () => {
        container.classList.add("right-panel-active");

        // change close button color
        closeBtn.style.color = "#9b46d4";
    });

    signInButton.addEventListener('click', () => {
        container.classList.remove("right-panel-active");

        // change close button color back
        closeBtn.style.color = "#efefef";
    });


    // Search bar toggle
    const searchToggle = document.getElementById('search');
    const searchInput = document.getElementById('searchInput');
    const searchBar = searchToggle.closest('.search_bar');

    searchToggle.addEventListener('click', () => {
        searchBar.classList.toggle('active');
        if (searchBar.classList.contains('active')) {
            searchInput.focus();
        }
    });

    document.addEventListener('click', (e) => {
        if (!searchBar.contains(e.target)) {
            if (searchInput.value.trim() === '') {
                searchBar.classList.remove('active');
            }
        }
    });

    searchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            searchBar.classList.remove('active');
            searchInput.value = '';
        }
    });

});

// Search filter
const searchInput = document.getElementById('topicSearch');
if (searchInput) {
    searchInput.addEventListener('input', function () {
        const q = this.value.toLowerCase();
        document.querySelectorAll('.topic-row').forEach(row => {
            const name = row.querySelector('.topic-name')?.textContent.toLowerCase() || '';
            const expand = row.querySelector('.topic-expand')?.textContent.toLowerCase() || '';
            row.style.display = (name.includes(q) || expand.includes(q)) ? '' : 'none';
        });
    });
};

// User Panel Loader
const panelRoot = document.getElementById('user-panel-root');
if (panelRoot) {
    fetch('user_panel.html')
        .then(r => r.text())
        .then(html => {
            panelRoot.innerHTML = html;
            initUserPanel();
        });
}

function initUserPanel() {
    const userBtn       = document.getElementById('userBtn');
    const panelOverlay  = document.getElementById('userPanelOverlay');
    const panelBackdrop = document.getElementById('panelBackdrop');
    const btnEdit       = document.getElementById('panelBtnEdit');
    const btnPass       = document.getElementById('panelBtnPass');
    const btnLogout     = document.getElementById('panelBtnLogout');

    if (!userBtn) return;

    function closePanel() { panelOverlay.classList.remove('open'); }
    function openPanel()  { panelOverlay.classList.add('open'); }

    userBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        panelOverlay.classList.contains('open') ? closePanel() : openPanel();
    });

    panelBackdrop.addEventListener('click', closePanel);

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closePanel();
    });

    btnEdit.addEventListener('click', () => {
        closePanel();
        document.dispatchEvent(new CustomEvent('panel:editInfo'));
    });

    btnPass.addEventListener('click', () => {
        closePanel();
        document.dispatchEvent(new CustomEvent('panel:changePass'));
    });

    btnLogout.addEventListener('click', () => {
        closePanel();
        document.dispatchEvent(new CustomEvent('panel:logout'));
    });
}