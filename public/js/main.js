/**
 * Main homepage logic
 * Fetches projects, topics, and tools from the API
 */

document.addEventListener('DOMContentLoaded', async () => {
    await loadHomeProjects();
    await loadHomeTopics();
    await loadSimulationTools();
});

/**
 * Load and display home projects
 */
async function loadHomeProjects() {
    const container = document.getElementById('homeProjects');
    if (!container) return;

    const categoryImages = {
        'General':    'images/Projects/general.jpg',
        'Circuits':   'images/Projects/circuits.jpg',
        'Embedded':   'images/Projects/embedded.jpg',
        'IoT':        'images/Projects/iot.jpg',
        'PCB Design': 'images/Projects/pcb_design.jpg',
        'Robotics':   'images/Projects/robotics.jpg',
    };
    const fallbackImage = 'images/Projects/general.jpg';

    try {
        const projects = await window.db.fetchHomeProjects();
        
        if (projects.length === 0) {
            container.innerHTML = '<p style="color:rgba(255,255,255,.4);">No projects available yet.</p>';
            return;
        }

        container.innerHTML = projects.map(project => {
            const imgSrc = categoryImages[project.category] || fallbackImage;
            const href = window.auth.isLoggedIn() 
                ? `pages/project.html?id=${project.id}` 
                : '#login';
            
            return `
                <a class="project_box" href="${href}">
                    <img src="${imgSrc}" alt="${project.title}" onerror="this.src='${fallbackImage}'">
                    <p>${project.title}</p>
                </a>
            `;
        }).join('');
    } catch (error) {
        console.error('Error loading home projects:', error);
        container.innerHTML = '<p style="color:rgba(255,255,255,.4);">Error loading projects.</p>';
    }
}

/**
 * Load and display home topics
 */
async function loadHomeTopics() {
    const container = document.getElementById('homeTopics');
    if (!container) return;

    try {
        const topics = await window.db.fetchHomeTopics();
        
        if (topics.length === 0) {
            container.innerHTML = '<p style="color:rgba(255,255,255,.4);">No topics available yet.</p>';
            return;
        }

        container.innerHTML = topics.map(topic => {
            const href = window.auth.isLoggedIn() 
                ? `pages/topic.html?id=${topic.id}` 
                : '#login';
            
            return `<a href="${href}"><p>${topic.name}</p></a>`;
        }).join('');
    } catch (error) {
        console.error('Error loading home topics:', error);
        container.innerHTML = '<p style="color:rgba(255,255,255,.4);">Error loading topics.</p>';
    }
}

/**
 * Load and display simulation tools
 */
async function loadSimulationTools() {
    const container = document.getElementById('simulationTools');
    if (!container) return;

    try {
        const tools = await window.db.fetchSimulationTools();
        
        if (tools.length === 0) {
            // Fallback to default tools
            container.innerHTML = `
                <a href="${window.auth.isLoggedIn() ? 'pages/multisim.html' : '#login'}" class="tool_box_border">
                    <span class="tool_title">MULTISIM</span>
                    <p>Professional circuit simulation environment for electronics exercises.</p>
                </a>
                <a href="${window.auth.isLoggedIn() ? 'pages/tinkercad.html' : '#login'}" class="tool_box_border">
                    <span class="tool_title">TINKERCAD</span>
                    <p>Interactive platform for simulating electronics with beautiful visualizations.</p>
                </a>
            `;
            return;
        }

        container.innerHTML = tools.map(tool => {
            const href = window.auth.isLoggedIn() 
                ? `pages/${tool.url_path.replace('.html', '.html')}` 
                : '#login';
            
            return `
                <a href="${href}" class="tool_box_border">
                    <span class="tool_title">${tool.tool_name}</span>
                    <p>${tool.description}</p>
                </a>
            `;
        }).join('');
    } catch (error) {
        console.error('Error loading simulation tools:', error);
        // Fallback
        container.innerHTML = `
            <a href="#login" class="tool_box_border">
                <span class="tool_title">MULTISIM</span>
                <p>Professional circuit simulation environment.</p>
            </a>
            <a href="#login" class="tool_box_border">
                <span class="tool_title">TINKERCAD</span>
                <p>Interactive simulation platform.</p>
            </a>
        `;
    }
}
