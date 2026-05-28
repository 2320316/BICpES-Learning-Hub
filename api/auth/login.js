/**
 * Vercel API Route: POST /api/auth/login
 * Authenticate user and create session
 */

import crypto from "crypto";

export default async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Credentials", "true");
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(200).end();
  }

  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  try {
    const { student_number, password } = req.body;

    // Validation
    if (!student_number || !password) {
      return res
        .status(400)
        .json({ error: "Missing student number or password" });
    }

    // Handle user login (both admin and student)
    let user = null;

    // All users are stored in the database with role field
    const { createClient } = await import("@supabase/supabase-js");
    const supabase = createClient(
      process.env.VITE_SUPABASE_URL,
      process.env.VITE_SUPABASE_ANON_KEY,
    );

    const passwordHash = crypto
      .createHash("sha256")
      .update(password)
      .digest("hex");

    const { data, error } = await supabase
      .from("users")
      .select("*")
      .eq("student_number", student_number)
      .eq("password_hash", passwordHash)
      .single();

    if (error || !data) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    user = data;

    // Generate session token
    const token = crypto.randomBytes(32).toString("hex");
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();

    return res.status(200).json({
      user: {
        id: user.id,
        student_number: user.student_number,
        first_name: user.first_name,
        last_name: user.last_name,
      },
      role: user.role || "student",
      token,
      expiresAt,
    });
  } catch (error) {
    console.error("Login Error:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
}
