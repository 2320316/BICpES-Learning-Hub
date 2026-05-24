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
        openModal('modalEditOverlay');
    });

    btnPass.addEventListener('click', () => {
        closePanel();
        openModal('modalPassOverlay');
    });

    btnLogout.addEventListener('click', () => {
        closePanel();
        document.dispatchEvent(new CustomEvent('panel:logout'));
    });
}

/* ── MODAL HELPERS ── */
function openModal(id) {
    const overlay = document.getElementById(id);
    if (!overlay) return;
    overlay.classList.add('open');
    document.body.style.overflow = 'hidden';
}

function closeModal(id) {
    const overlay = document.getElementById(id);
    if (!overlay) return;
    overlay.classList.remove('open');
    document.body.style.overflow = '';
}

/* ── MODAL: Edit Information ── */
document.addEventListener('panel:editInfo', () => openModal('modalEditOverlay'));

document.addEventListener('click', (e) => {
    // Close buttons
    if (e.target.id === 'modalEditClose' || e.target.id === 'modalEditCancel')  closeModal('modalEditOverlay');
    if (e.target.id === 'modalPassClose' || e.target.id === 'modalPassCancel')  closeModal('modalPassOverlay');

    // Backdrop click
    if (e.target.id === 'modalEditBackdrop') closeModal('modalEditOverlay');
    if (e.target.id === 'modalPassBackdrop') closeModal('modalPassOverlay');

    // Save — Edit Info
    if (e.target.id === 'modalEditSave') {
        const btn = e.target;
        btn.textContent = '✓ Saved!';
        btn.classList.add('success');
        setTimeout(() => {
            btn.textContent = 'Save Changes';
            btn.classList.remove('success');
            closeModal('modalEditOverlay');
        }, 1400);
    }

    // Save — Change Password
    if (e.target.id === 'modalPassSave') {
        const newPass     = document.getElementById('newPass');
        const confirmPass = document.getElementById('confirmPass');
        const matchLabel  = document.getElementById('passMatchLabel');
        if (!newPass || !confirmPass) return;

        if (newPass.value !== confirmPass.value) {
            matchLabel.textContent = '⚠ Passwords do not match.';
            matchLabel.style.color = '#f87171';
            confirmPass.style.borderColor = 'rgba(248,113,113,0.60)';
            return;
        }
        if (newPass.value.length < 6) {
            matchLabel.textContent = '⚠ Password must be at least 6 characters.';
            matchLabel.style.color = '#f87171';
            return;
        }
        const btn = e.target;
        btn.textContent = '✓ Updated!';
        btn.classList.add('success');
        setTimeout(() => {
            btn.textContent = 'Update Password';
            btn.classList.remove('success');
            closeModal('modalPassOverlay');
            // reset fields
            document.getElementById('currentPass').value = '';
            newPass.value = '';
            confirmPass.value = '';
            matchLabel.textContent = '';
            document.getElementById('passStrengthFill').style.width = '0%';
            document.getElementById('passStrengthLabel').textContent = '';
        }, 1400);
    }

    // Toggle password visibility
    if (e.target.closest('.toggle-eye')) {
        const btn    = e.target.closest('.toggle-eye');
        const input  = document.getElementById(btn.dataset.target);
        if (!input) return;
        input.type = input.type === 'password' ? 'text' : 'password';
        btn.style.color = input.type === 'text'
            ? 'rgba(155,70,212,0.80)'
            : 'rgba(245,245,245,0.30)';
    }
});

/* ── PASSWORD STRENGTH METER ── */
document.addEventListener('input', (e) => {
    if (e.target.id !== 'newPass') return;
    const val    = e.target.value;
    const fill   = document.getElementById('passStrengthFill');
    const label  = document.getElementById('passStrengthLabel');
    if (!fill || !label) return;

    let strength = 0;
    if (val.length >= 6)  strength++;
    if (val.length >= 10) strength++;
    if (/[A-Z]/.test(val) && /[0-9]/.test(val)) strength++;
    if (/[^A-Za-z0-9]/.test(val)) strength++;

    const levels = [
        { w: '0%',    color: 'transparent',   text: '' },
        { w: '33%',   color: '#f87171',        text: 'Weak' },
        { w: '66%',   color: '#fb923c',        text: 'Fair' },
        { w: '88%',   color: '#facc15',        text: 'Good' },
        { w: '100%',  color: '#4ade80',        text: 'Strong' },
    ];
    const lvl = val.length === 0 ? levels[0] : levels[Math.min(strength, 4)];
    fill.style.width      = lvl.w;
    fill.style.background = lvl.color;
    label.textContent     = lvl.text;
    label.style.color     = lvl.color;
});

/* ── PASSWORD MATCH FEEDBACK ── */
document.addEventListener('input', (e) => {
    if (e.target.id !== 'confirmPass') return;
    const newPass     = document.getElementById('newPass');
    const confirmPass = e.target;
    const matchLabel  = document.getElementById('passMatchLabel');
    if (!newPass || !matchLabel) return;

    if (confirmPass.value === '') {
        matchLabel.textContent = '';
        confirmPass.style.borderColor = '';
        return;
    }
    if (confirmPass.value === newPass.value) {
        matchLabel.textContent = '✓ Passwords match';
        matchLabel.style.color = '#4ade80';
        confirmPass.style.borderColor = 'rgba(74,222,128,0.50)';
    } else {
        matchLabel.textContent = '✗ Passwords do not match';
        matchLabel.style.color = '#f87171';
        confirmPass.style.borderColor = 'rgba(248,113,113,0.50)';
    }
});

/* ── ESC key closes any open modal ── */
document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    closeModal('modalEditOverlay');
    closeModal('modalPassOverlay');
});