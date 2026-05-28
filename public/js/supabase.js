// Supabase Configuration
// Use environment variables for production, fallback values for development

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || localStorage.getItem('SUPABASE_URL') || 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = process.env.VITE_SUPABASE_ANON_KEY || localStorage.getItem('SUPABASE_ANON_KEY') || 'YOUR_SUPABASE_ANON_KEY';

let supabaseClient = null;

/**
 * Initialize Supabase Client
 * For browser environments, we use the Supabase JS client library
 */
async function initSupabase() {
    // Dynamically import Supabase client
    const { createClient } = await import('https://esm.sh/@supabase/supabase-js@2');
    
    if (!supabaseClient) {
        supabaseClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    }
    return supabaseClient;
}

/**
 * Get the Supabase client
 */
async function getSupabaseClient() {
    if (!supabaseClient) {
        await initSupabase();
    }
    return supabaseClient;
}

// Export for use in other modules
window.initSupabase = initSupabase;
window.getSupabaseClient = getSupabaseClient;
