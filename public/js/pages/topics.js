/**
 * Topics page logic
 */

document.addEventListener('DOMContentLoaded', async () => {
  window.auth.requireLogin();
  await loadTopics();
  initSearch();
});

let allTopics = [];

async function loadTopics() {
  try {
    const response = await fetch('../api/topics?limit=100');
    if (!response.ok) throw new Error('Failed to fetch topics');
    
    const result = await response.json();
    allTopics = result.data;
    
    displayDisciplines();
    displayTopics(allTopics);
  } catch (error) {
    console.error('Error loading topics:', error);
    document.getElementById('topicList').innerHTML = 
      '<p style="color:rgba(255,255,255,.4);">Error loading topics</p>';
  }
}

function displayDisciplines() {
  const disciplines = [...new Set(allTopics.map(t => t.category))];
  const icons = {
    'Circuits & Electronics': '⚡',
    'Digital Systems': '💡',
    'Embedded & Programming': '🔧',
    'Soldering & Fabrication': '🔩'
  };

  const container = document.getElementById('disciplineCards');
  container.innerHTML = disciplines.map(cat => {
    const topicCount = allTopics.filter(t => t.category === cat).length;
    return `
      <div class="disc-card">
        <span class="disc-icon">${icons[cat] || '📖'}</span>
        <div class="disc-name">${cat}</div>
        <div class="disc-count">${topicCount} topic${topicCount !== 1 ? 's' : ''}</div>
      </div>
    `;
  }).join('');
}

function displayTopics(topics) {
  const list = document.getElementById('topicList');
  
  if (topics.length === 0) {
    list.innerHTML = '<p style="color:rgba(255,255,255,.4);">No topics found</p>';
    return;
  }

  list.innerHTML = topics.map(topic => `
    <a href="topic.html?id=${topic.id}" class="topic-row">
      <div class="topic-num">${topic.topic_num}</div>
      <div class="topic-info">
        <div class="topic-name">${topic.name}</div>
        <div class="topic-category">${topic.category}</div>
      </div>
    </a>
  `).join('');
}

function initSearch() {
  const searchInput = document.getElementById('topicSearch');
  
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      const query = e.target.value.toLowerCase();
      
      if (query.length === 0) {
        displayTopics(allTopics);
        return;
      }
      
      const filtered = allTopics.filter(topic =>
        topic.name.toLowerCase().includes(query) ||
        topic.description.toLowerCase().includes(query) ||
        topic.category.toLowerCase().includes(query)
      );
      
      displayTopics(filtered);
    });
  }
}
