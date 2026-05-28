/**
 * Authentication Module for BICpES Learning Hub
 * Uses Supabase Authentication
 */

// Global auth state
let authState = {
    isLoggedIn: false,
    user: null,
    role: null
};

/**
 * Initialize authentication
 */
async function initAuth() {
    try {
        // Check if user is already logged in (from localStorage)
        const session = localStorage.getItem('bicpes_session');
        if (session) {
            const sessionData = JSON.parse(session);
            if (sessionData.expiresAt && new Date(sessionData.expiresAt) > new Date()) {
                authState.isLoggedIn = true;
                authState.user = sessionData.user;
                authState.role = sessionData.role;
                updateAuthUI();
                return;
            } else {
                localStorage.removeItem('bicpes_session');
            }
        }
        updateAuthUI();
    } catch (error) {
        console.error('Error initializing auth:', error);
    }
}

/**
 * Sign up new user
 */
async function signUp(studentNumber, firstName, lastName, birthdate, password, confirmPassword) {
    try {
        if (password !== confirmPassword) {
            throw new Error('Passwords do not match');
        }

        const response = await fetch('/api/auth/signup', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                student_number: studentNumber,
                first_name: firstName,
                last_name: lastName,
                birthdate: birthdate,
                password: password
            })
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message || 'Sign up failed');
        }

        const data = await response.json();
        
        // Store session
        const sessionData = {
            user: data.user,
            role: data.role,
            token: data.token,
            expiresAt: data.expiresAt
        };
        localStorage.setItem('bicpes_session', JSON.stringify(sessionData));
        
        authState.isLoggedIn = true;
        authState.user = data.user;
        authState.role = data.role;
        
        updateAuthUI();
        alert('Account created successfully! You are now logged in.');
        location.href = '#topics';
        
        return true;
    } catch (error) {
        console.error('Sign up error:', error);
        alert('Sign up failed: ' + error.message);
        return false;
    }
}

/**
 * Login user
 */
async function login(studentNumber, password) {
    try {
        const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                student_number: studentNumber,
                password: password
            })
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message || 'Login failed');
        }

        const data = await response.json();
        
        // Store session
        const sessionData = {
            user: data.user,
            role: data.role,
            token: data.token,
            expiresAt: data.expiresAt
        };
        localStorage.setItem('bicpes_session', JSON.stringify(sessionData));
        
        authState.isLoggedIn = true;
        authState.user = data.user;
        authState.role = data.role;
        
        updateAuthUI();
        
        // Close login modal and redirect
        document.getElementById('login').style.display = 'none';
        location.href = '#topics';
        
        return true;
    } catch (error) {
        console.error('Login error:', error);
        alert('Login failed: ' + error.message);
        return false;
    }
}

/**
 * Logout user
 */
function logout() {
    try {
        localStorage.removeItem('bicpes_session');
        authState.isLoggedIn = false;
        authState.user = null;
        authState.role = null;
        updateAuthUI();
        location.href = '#home';
    } catch (error) {
        console.error('Logout error:', error);
    }
}

/**
 * Check if user is logged in
 */
function isLoggedIn() {
    return authState.isLoggedIn;
}

/**
 * Get current user
 */
function getCurrentUser() {
    return authState.user;
}

/**
 * Get current user role
 */
function getCurrentRole() {
    return authState.role;
}

/**
 * Check if current user is admin
 */
function isAdmin() {
    return authState.isLoggedIn && authState.role === 'admin';
}

/**
 * Update UI based on auth state
 */
function updateAuthUI() {
    const navRight = document.getElementById('navRight');
    const startLearningBtn = document.getElementById('startLearningBtn');
    const viewMoreProjectsBtn = document.getElementById('viewMoreProjectsBtn');
    const viewMoreTopicsBtn = document.getElementById('viewMoreTopicsBtn');
    
    if (navRight) {
        navRight.innerHTML = '';
        if (authState.isLoggedIn) {
            navRight.innerHTML = `
                <a href="#" id="userNameLink">${authState.user.first_name || 'User'}</a>
                <a href="#" id="logoutLink">Logout</a>
            `;
            
            document.getElementById('userNameLink')?.addEventListener('click', (e) => {
                e.preventDefault();
                location.href = 'pages/user-panel.html';
            });
            
            document.getElementById('logoutLink')?.addEventListener('click', (e) => {
                e.preventDefault();
                logout();
            });
            
            if (startLearningBtn) startLearningBtn.href = '#topics';
            if (viewMoreProjectsBtn) viewMoreProjectsBtn.href = 'pages/projects.html';
            if (viewMoreTopicsBtn) viewMoreTopicsBtn.href = 'pages/topics.html';
        } else {
            navRight.innerHTML = `
                <a href="#login" id="loginLink">Login</a>
            `;
            
            if (startLearningBtn) startLearningBtn.href = '#login';
            if (viewMoreProjectsBtn) viewMoreProjectsBtn.href = '#login';
            if (viewMoreTopicsBtn) viewMoreTopicsBtn.href = '#login';
        }
    }
}

/**
 * Require login - redirect if not logged in
 */
function requireLogin() {
    if (!isLoggedIn()) {
        location.href = '../index.html#login';
    }
}

// Initialize auth when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    initAuth();
});

// Export for use in other modules
window.auth = {
    signUp,
    login,
    logout,
    isLoggedIn,
    getCurrentUser,
    getCurrentRole,
    isAdmin,
    requireLogin
};
