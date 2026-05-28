-- BICpES Learning Hub - Supabase PostgreSQL Schema
-- Migrated from MySQL to PostgreSQL

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USERS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL PRIMARY KEY,
  student_number VARCHAR(50) NOT NULL UNIQUE,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  birthdate DATE NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'admin')),
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_student_number ON users(student_number);
CREATE INDEX idx_users_role ON users(role);

-- ============================================================================
-- PROJECTS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS projects (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  requirements TEXT NOT NULL,
  difficulty VARCHAR(50) NOT NULL DEFAULT 'Intermediate' 
    CHECK (difficulty IN ('Beginner', 'Intermediate', 'Advanced')),
  category VARCHAR(100) NOT NULL DEFAULT 'General',
  year INTEGER NOT NULL DEFAULT 2026,
  hero_tag VARCHAR(100),
  overview_body TEXT,
  components_json JSONB DEFAULT '[]'::jsonb,  -- Stores component list
  procedure_steps JSONB DEFAULT '[]'::jsonb,   -- Stores step-by-step instructions
  video_title VARCHAR(255),
  video_duration VARCHAR(50) DEFAULT '--:--',
  video_url VARCHAR(512),                      -- YouTube URL or video path
  video_type VARCHAR(50) CHECK (video_type IN ('url', 'file')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_projects_category ON projects(category);
CREATE INDEX idx_projects_difficulty ON projects(difficulty);
CREATE INDEX idx_projects_year ON projects(year);

-- ============================================================================
-- TOPICS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS topics (
  id BIGSERIAL PRIMARY KEY,
  topic_num INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(100) NOT NULL,
  overview_body TEXT,
  pdf_filename VARCHAR(255),                   -- Reference to Materials/filename
  activities JSONB DEFAULT '[]'::jsonb,       -- Stores activity/exercise list
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_topics_topic_num ON topics(topic_num);
CREATE INDEX idx_topics_category ON topics(category);
CREATE INDEX idx_topics_name ON topics(name);

-- ============================================================================
-- SIMULATION_TOOLS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS simulation_tools (
  id BIGSERIAL PRIMARY KEY,
  tool_name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  url_path VARCHAR(255) NOT NULL,              -- Path to tool page
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- USER_PROGRESS TABLE (Track student progress)
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_progress (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  project_id BIGINT REFERENCES projects(id) ON DELETE CASCADE,
  topic_id BIGINT REFERENCES topics(id) ON DELETE CASCADE,
  status VARCHAR(50) DEFAULT 'started' 
    CHECK (status IN ('not_started', 'started', 'in_progress', 'completed')),
  progress_percent INTEGER DEFAULT 0 CHECK (progress_percent >= 0 AND progress_percent <= 100),
  last_accessed TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, project_id),
  UNIQUE(user_id, topic_id)
);

CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_project ON user_progress(project_id);
CREATE INDEX idx_user_progress_topic ON user_progress(topic_id);
CREATE INDEX idx_user_progress_status ON user_progress(status);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert sample projects
INSERT INTO projects 
  (title, description, requirements, difficulty, category, year, hero_tag, overview_body, components_json, procedure_steps)
VALUES
  ('Logic Gates Boolean Algebra',
   'A practical exploration of fundamental logic gates (AND, OR, NOT, NAND, NOR, XOR) to implement and verify basic Boolean algebraic functions.',
   'Logic Gates',
   'Beginner',
   'General',
   2026,
   'Problem Solving',
   'This project introduces the core building blocks of digital computing. Students construct circuits on a breadboard or simulation software to map physical inputs to binary outputs (1 and 0). By testing various configurations, you verify how complex logical conditions can be simplified mathematically using algebraic theorems to reduce component counts.',
   '[]'::jsonb,
   '[]'::jsonb),

  ('Boolean Minterm and Maxterm',
   'Designing optimized combinational logic circuits directly from a truth table using Sum-of-Products (SOP) and Product-of-Sums (POS) standard forms.',
   'Logic Gates',
   'Beginner',
   'General',
   2026,
   'Problem Solving',
   'This project bridges the gap between a word problem and working hardware. You take a specific logic goal, map out its desired truth table, and extract either the Minterms (where the output must be active-high) or Maxterms (where the output must be active-low). These terms are then mapped into logic gates, demonstrating systematic circuit synthesis and design optimization.',
   '[]'::jsonb,
   '[]'::jsonb),

  ('De Morgan''s Theorem',
   'Experimental proof of De Morgan''s dual laws, demonstrating how NAND and NOR gates can completely replace and replicate individual AND/OR structures.',
   'Logic Gates',
   'Beginner',
   'General',
   2026,
   'Problem Solving',
   'De Morgan''s Laws state that ¬(A ∧ B) = ¬A ∨ ¬B and ¬(A ∨ B) = ¬A ∧ ¬B. This project requires building equivalent circuit branches alongside each other to prove these mathematical identities. It highlights a critical manufacturing principle: how engineers can construct any arbitrary digital system using only universal gates (NAND or NOR), reducing production overhead.',
   '[]'::jsonb,
   '[]'::jsonb),

  ('Flip-Flops',
   'An introduction to sequential logic networks using SR, D, JK, or T flip-flops to achieve stable, single-bit data storage.',
   'Logic Gates',
   'Beginner',
   'Circuits',
   2026,
   'Circuit',
   'Unlike combinational logic which reacts purely to current inputs, flip-flops introduce memory and feedback loops. In this project, you construct or analyze circuits that can hold a state (either Set or Reset) even after the initial input signal is gone. This forms the technological basis for registers, memory blocks, and state machine control units.',
   '[]'::jsonb,
   '[]'::jsonb);

-- Insert sample topics
INSERT INTO topics
  (topic_num, name, description, category, overview_body, pdf_filename)
VALUES
  (1, 'Introduction to Digital Logic', 'Foundations of Boolean algebra and digital systems', 'Digital Systems', 'Learn the fundamentals of digital logic, including binary numbers, Boolean algebra, and logic gates. This topic covers the theoretical foundation upon which all digital systems are built.', 'intro_digital_logic.pdf'),
  (2, 'Circuit Design Principles', 'Essential concepts for designing electronic circuits', 'Circuits & Electronics', 'Understand circuit design principles including Ohm''s law, Kirchhoff''s laws, and power consumption. Learn how to design efficient circuits for various applications.', 'circuit_design.pdf'),
  (3, 'Embedded Systems Fundamentals', 'Introduction to embedded systems and microcontrollers', 'Embedded & Programming', 'Get started with embedded systems development, including microcontroller programming, I/O operations, and real-time systems concepts.', 'embedded_fundamentals.pdf');

-- Insert simulation tools
INSERT INTO simulation_tools
  (tool_name, description, url_path)
VALUES
  ('NI Multisim System Interface', 'Professional environment for circuit tracing and simulation visualization analysis.', 'multisim.html'),
  ('Autodesk Tinkercad Prototyping Space', 'Interactive educational platform mapping virtual breadboards and live system logic validation.', 'tinkercad.html');

-- ============================================================================
-- AUTHENTICATION SETUP (Optional - integrate with Supabase Auth)
-- ============================================================================
-- Note: Supabase has built-in authentication via Auth API
-- This table is for additional user profile data
-- You can link it to Supabase's auth.users table using RLS policies

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE simulation_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Allow anyone to view projects and topics
CREATE POLICY "projects_are_public" ON projects FOR SELECT USING (true);
CREATE POLICY "topics_are_public" ON topics FOR SELECT USING (true);
CREATE POLICY "tools_are_public" ON simulation_tools FOR SELECT USING (true);

-- Users can only view their own progress
CREATE POLICY "users_can_view_own_progress" ON user_progress 
  FOR SELECT USING (auth.uid()::text = user_id::text);

-- Users can update their own progress
CREATE POLICY "users_can_update_own_progress" ON user_progress 
  FOR UPDATE USING (auth.uid()::text = user_id::text);

-- Only admins can modify projects and topics
-- (Requires custom claim or role management - configure in your API)
