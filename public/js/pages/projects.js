/**
 * Projects page logic
 */

document.addEventListener("DOMContentLoaded", async () => {
  window.auth.requireLogin();
  await loadProjects();
  initFilterButtons();
});

let allProjects = [];

async function loadProjects() {
  const grid = document.getElementById("projectsGrid");
  const countSpan = document.getElementById("projectCount");

  try {
    const apiUrl = window.API_URL || '/api';
    const response = await fetch(`${apiUrl}/projects?limit=100`);
    if (!response.ok) throw new Error("Failed to fetch projects");

    const result = await response.json();
    allProjects = result.data;
    countSpan.textContent = result.total || allProjects.length;

    displayProjects(allProjects);
  } catch (error) {
    console.error("Error loading projects:", error);
    grid.innerHTML =
      '<p style="color:rgba(255,255,255,.4);">Error loading projects</p>';
  }
}

function displayProjects(projects) {
  const grid = document.getElementById("projectsGrid");

  if (projects.length === 0) {
    grid.innerHTML =
      '<p style="color:rgba(255,255,255,.4);">No projects found</p>';
    return;
  }

  const categoryImages = {
    General: "../images/Projects/general.jpg",
    Circuits: "../images/Projects/circuits.jpg",
    Embedded: "../images/Projects/embedded.jpg",
    IoT: "../images/Projects/iot.jpg",
    "PCB Design": "../images/Projects/pcb_design.jpg",
    Robotics: "../images/Projects/robotics.jpg",
  };
  const fallback = "../images/Projects/general.jpg";

  grid.innerHTML = projects
    .map((project) => {
      const img = categoryImages[project.category] || fallback;
      return `
      <div class="project-card" data-category="${project.category}" onclick="location.href='project.html?id=${project.id}'">
        <div class="card-thumb">
          <img class="ph" src="${img}" alt="${project.title}" onerror="this.src='${fallback}'">
          <span class="card-pill">${project.category}</span>
        </div>
        <div class="card-body">
          <div class="card-name">${project.title}</div>
          <div class="card-footer-row">
            <span class="card-meta">${project.category} · ${project.year}</span>
            <div class="card-btn">›</div>
          </div>
        </div>
      </div>
    `;
    })
    .join("");
}

function initFilterButtons() {
  const buttons = document.querySelectorAll(".filter-btn");

  buttons.forEach((button) => {
    button.addEventListener("click", () => {
      // Remove active class from all
      buttons.forEach((b) => b.classList.remove("active"));
      // Add to clicked
      button.classList.add("active");

      const filter = button.dataset.filter;
      let filtered = allProjects;

      if (filter !== "all") {
        filtered = allProjects.filter((p) => p.category === filter);
      }

      displayProjects(filtered);
    });
  });
}
