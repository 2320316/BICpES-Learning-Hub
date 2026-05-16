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

