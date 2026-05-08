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