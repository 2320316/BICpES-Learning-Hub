/**
 * Vercel API Route: POST /api/auth/signup
 * Register a new user account
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
    const { student_number, first_name, last_name, birthdate, password } =
      req.body;

    // Validation
    if (
      !student_number ||
      !first_name ||
      !last_name ||
      !password ||
      !birthdate
    ) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    if (password.length < 6) {
      return res
        .status(400)
        .json({ error: "Password must be at least 6 characters" });
    }

    const { createClient } = await import("@supabase/supabase-js");
    const supabase = createClient(
      process.env.VITE_SUPABASE_URL,
      process.env.VITE_SUPABASE_ANON_KEY,
    );

    // Check if student already exists
    const { data: existingUser } = await supabase
      .from("users")
      .select("id")
      .eq("student_number", student_number)
      .single();

    if (existingUser) {
      return res
        .status(409)
        .json({ error: "Student number already registered" });
    }

    // Hash password
    const passwordHash = crypto
      .createHash("sha256")
      .update(password)
      .digest("hex");

    // Create user
    const { data, error } = await supabase
      .from("users")
      .insert([
        {
          student_number,
          first_name,
          last_name,
          birthdate,
          password_hash: passwordHash,
          role: "student",
        },
      ])
      .select()
      .single();

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    // Generate session token
    const token = crypto.randomBytes(32).toString("hex");
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();

    return res.status(201).json({
      user: {
        id: data.id,
        student_number: data.student_number,
        first_name: data.first_name,
        last_name: data.last_name,
      },
      role: "student",
      token,
      expiresAt,
    });
  } catch (error) {
    console.error("Signup Error:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
}
