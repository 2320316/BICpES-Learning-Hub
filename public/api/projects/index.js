/**
 * Vercel API Route: GET /api/projects
 * Fetch projects with pagination and filtering
 */

export default async function handler(req, res) {
  // Enable CORS
  res.setHeader("Access-Control-Allow-Credentials", "true");
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(200).end();
  }

  if (req.method !== "GET") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  try {
    const { limit = 10, offset = 0, category } = req.query;

    // Initialize Supabase client
    const { createClient } = await import("@supabase/supabase-js");
    const supabase = createClient(
      process.env.VITE_SUPABASE_URL,
      process.env.VITE_SUPABASE_ANON_KEY,
    );

    let query = supabase
      .from("projects")
      .select("id, title, description, category, difficulty, year", {
        count: "exact",
      });

    if (category) {
      query = query.eq("category", category);
    }

    const { data, error, count } = await query
      .order("id", { ascending: true })
      .range(offset, offset + parseInt(limit) - 1);

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      data,
      total: count,
      limit: parseInt(limit),
      offset: parseInt(offset),
    });
  } catch (error) {
    console.error("API Error:", error);
    return res.status(500).json({ error: error.message });
  }
}
