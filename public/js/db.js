/**
 * Database Functions for BICpES Learning Hub
 * Communicates with Supabase PostgreSQL backend
 */

/**
 * Fetch projects for homepage (limited)
 */
async function fetchHomeProjects() {
    try {
        const response = await fetch('/api/projects?limit=3');
        if (!response.ok) throw new Error('Failed to fetch projects');
        return await response.json();
    } catch (error) {
        console.error('Error fetching home projects:', error);
        return [];
    }
}

/**
 * Fetch all projects (with pagination)
 */
async function fetchAllProjects(page = 1, pageSize = 12) {
    try {
        const offset = (page - 1) * pageSize;
        const response = await fetch(`/api/projects?offset=${offset}&limit=${pageSize}`);
        if (!response.ok) throw new Error('Failed to fetch all projects');
        return await response.json();
    } catch (error) {
        console.error('Error fetching all projects:', error);
        return { data: [], count: 0 };
    }
}

/**
 * Fetch single project by ID
 */
async function fetchProjectById(id) {
    try {
        const response = await fetch(`/api/projects/${id}`);
        if (!response.ok) throw new Error('Failed to fetch project');
        return await response.json();
    } catch (error) {
        console.error('Error fetching project:', error);
        return null;
    }
}

/**
 * Fetch topics for homepage (limited)
 */
async function fetchHomeTopics() {
    try {
        const response = await fetch('/api/topics?limit=3');
        if (!response.ok) throw new Error('Failed to fetch topics');
        return await response.json();
    } catch (error) {
        console.error('Error fetching home topics:', error);
        return [];
    }
}

/**
 * Fetch all topics (with pagination)
 */
async function fetchAllTopics(page = 1, pageSize = 12) {
    try {
        const offset = (page - 1) * pageSize;
        const response = await fetch(`/api/topics?offset=${offset}&limit=${pageSize}`);
        if (!response.ok) throw new Error('Failed to fetch all topics');
        return await response.json();
    } catch (error) {
        console.error('Error fetching all topics:', error);
        return { data: [], count: 0 };
    }
}

/**
 * Fetch single topic by ID
 */
async function fetchTopicById(id) {
    try {
        const response = await fetch(`/api/topics/${id}`);
        if (!response.ok) throw new Error('Failed to fetch topic');
        return await response.json();
    } catch (error) {
        console.error('Error fetching topic:', error);
        return null;
    }
}

/**
 * Fetch simulation tools
 */
async function fetchSimulationTools() {
    try {
        const response = await fetch('/api/simulation-tools');
        if (!response.ok) throw new Error('Failed to fetch simulation tools');
        return await response.json();
    } catch (error) {
        console.error('Error fetching simulation tools:', error);
        return [];
    }
}

/**
 * Search projects by category or keyword
 */
async function searchProjects(query) {
    try {
        const response = await fetch(`/api/projects/search?q=${encodeURIComponent(query)}`);
        if (!response.ok) throw new Error('Failed to search projects');
        return await response.json();
    } catch (error) {
        console.error('Error searching projects:', error);
        return [];
    }
}

/**
 * Search topics by keyword
 */
async function searchTopics(query) {
    try {
        const response = await fetch(`/api/topics/search?q=${encodeURIComponent(query)}`);
        if (!response.ok) throw new Error('Failed to search topics');
        return await response.json();
    } catch (error) {
        console.error('Error searching topics:', error);
        return [];
    }
}

// Export functions for use in other modules
window.db = {
    fetchHomeProjects,
    fetchAllProjects,
    fetchProjectById,
    fetchHomeTopics,
    fetchAllTopics,
    fetchTopicById,
    fetchSimulationTools,
    searchProjects,
    searchTopics
};
