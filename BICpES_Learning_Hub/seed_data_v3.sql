-- ==============================================================================
--  BICpES Learning Hub — Complete Master Schema & Production Seeding Suite v3
--  Engine : InnoDB   |  Charset : utf8mb4_unicode_ci
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `bicpes_hub` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bicpes_hub`;

-- ──────────────────────────────────────────────────────────────────────────────
-- 1. USERS TABLE
-- ──────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `student_number` VARCHAR(50) NULL UNIQUE COMMENT 'Left NULL for Admin accounts',
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL COMMENT 'Secure bcrypt string',
    `role` ENUM('admin', 'student') NOT NULL DEFAULT 'student',
    `date_of_birth` DATE NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ──────────────────────────────────────────────────────────────────────────────
-- 2. TOPICS TABLE (Includes: Overview text paragraphs, PDF paths, and JSON activities)
-- ──────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `topics`;
CREATE TABLE `topics` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `topic_num` INT NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `category` VARCHAR(100) NOT NULL,
    `overview_body` LONGTEXT NULL COMMENT 'Pipe-separated text blocks rendered as paragraphs',
    `pdf_filename` VARCHAR(255) NULL COMMENT 'Target filename reference within Materials directory',
    `activities` JSON NULL COMMENT 'Dynamic object list detailing structured tasks and experiments',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ──────────────────────────────────────────────────────────────────────────────
-- 3. PROJECTS TABLE (Includes: Overview, Components JSON, Procedure JSON, & Video details)
-- ──────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `requirements` TEXT NOT NULL,
    `difficulty` ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL DEFAULT 'Intermediate',
    `category` VARCHAR(100) NOT NULL DEFAULT 'General',
    `year` INT NOT NULL DEFAULT 2026,
    `hero_tag` VARCHAR(100) NULL,
    `overview_body` LONGTEXT NULL COMMENT 'Detailed documentation string splits',
    `components_json` JSON NULL COMMENT 'Dynamic structured array mapping target parts list data',
    `procedure_steps` JSON NULL COMMENT 'Array collection storing step-by-step building instructions',
    `video_title` VARCHAR(255) NULL,
    `video_duration` VARCHAR(50) NULL DEFAULT '--:--',
    `video_url` VARCHAR(512) NULL COMMENT 'YouTube direct embedded stream path, or raw video filesystem path',
    `video_type` ENUM('url', 'file') NULL DEFAULT NULL COMMENT 'Lookup tracker flag to identify player engine type',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ──────────────────────────────────────────────────────────────────────────────
-- 4. SIMULATION TOOLS TABLE
-- ──────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `simulation_tools`;
CREATE TABLE `simulation_tools` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `tool_name` VARCHAR(100) NOT NULL,
    `description` TEXT NOT NULL,
    `url_path` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ==============================================================================
--  SEED TESTING DATA SETSUITE
-- ==============================================================================

-- Core Authentication Profiles (Password hash evaluates to 'password' across standard algorithms)
INSERT INTO `users` (`id`, `student_number`, `first_name`, `last_name`, `password_hash`, `role`, `date_of_birth`) VALUES
(1, NULL, 'System', 'Administrator', '$2y$12$R31m7P7K.rXoVym5E5k8AeuG0WkW1/fH2aL9vBC2xZmHeO.uH4f1C', 'admin', '1995-01-01'),
(2, '2026-0001-STUDENT', 'Juan', 'Dela Cruz', '$2y$12$R31m7P7K.rXoVym5E5k8AeuG0WkW1/fH2aL9vBC2xZmHeO.uH4f1C', 'student', '2005-06-15');

-- Seeding Complete Educational Topic Tracks (1 through 6)
INSERT INTO `topics` (`id`, `topic_num`, `name`, `description`, `category`, `overview_body`, `pdf_filename`, `activities`) VALUES
(1, 1, 'Introduction to BICpES Layouts', 'An initial overview covering fundamental electrical loops and engineering parameters.', 'Circuits & Electronics', 'Welcome to the BICpES Learning Hub Core.|This layout step handles circuit pathways, systemic voltage structures, and signal nodes.', 'topic1_foundations.pdf', '[{"type":"Laboratory","title":"Multimeter Calibration","description":"Perform functional reading validation across fixed validation resistors."}]'),
(2, 2, 'Ohm''s Law and Power Rules', 'Deep exploration concerning potential variance, electric current paths, and resistance variables.', 'Circuits & Electronics', 'Ohm''s Law represents the basic balancing equation governing power transmission systems.|By analyzing potential drops, users can map node voltages accurately.', 'topic2_ohms_law.pdf', '[{"type":"Simulation","title":"Verification Loop","description":"Construct a fundamental load trace network inside your simulation board environment."}]'),
(3, 3, 'Series and Parallel Circuits', 'Tracing behavior metrics across grouped series paths versus parallel structural nodes.', 'Circuits & Electronics', 'Components configured back-to-back form structured inline tracks.|Parallel legs provide completely redundant system pathways, preserving common source node drops.', 'topic3_networks.pdf', '[{"type":"Exercise","title":"Equivalent Resistance Formulas","description":"Calculate manual schematic configurations and double-check metrics via software instrumentation."}]'),
(4, 4, 'Kirchhoff''s Laws (KVL/KCL)', 'Advanced loop analytics assessing incoming currents and terminal voltage drops.', 'Circuits & Electronics', 'Kirchhoff''s Current Rule states that complete currents meeting at a joint equivalent perfectly to zero.|Loop variations track total accumulated dissipation variables.', 'topic4_kcl_kvl.pdf', '[{"type":"Experiment","title":"Mesh Analysis Challenge","description":"Solve complex multiple source matrixes using automated nodal trace software hooks."}]'),
(5, 5, 'Boolean Algebra & Logic Gates', 'The foundational structural logic models operating underneath modern digital microcontrollers.', 'Digital Systems', 'Boolean calculations manage variable states constrained strictly to binary High or Low expressions.|Logic operations allow processing structures to execute state routines.', 'topic5_logic.pdf', '[{"type":"Design Task","title":"Combinational Logic Array","description":"Reduce raw logic configurations using algebraic methods and map the output array via digital NAND chips."}]'),
(6, 6, 'Flip-Flops and Sequential Elements', 'An overview tracing structural data latch components and temporary execution memory buffers.', 'Digital Systems', 'Unlike stateless combinational nodes, sequential elements depend explicitly on system clock pulse tracking updates.|This enables real-time storage loops.', 'topic6_sequential.pdf', '[{"type":"Laboratory","title":"4-Bit Shift Array","description":"Construct asynchronous tracking registers using connected digital edge-triggered JK latch elements."}]');

-- Seeding Complete High-Detail Implementation Projects (1 through 4)
INSERT INTO `projects` (`id`, `title`, `description`, `requirements`, `difficulty`, `category`, `year`, `hero_tag`, `overview_body`, `components_json`, `procedure_steps`, `video_title`, `video_duration`, `video_url`, `video_type`) VALUES
(1, 'Regulated Variable DC Power Supply', 'Build a robust bench utility transforming raw alternating line power to smooth adjustable system grids.', 'Transformer core, IC regulators, filter arrays, soldering toolkit.', 'Intermediate', 'Circuits', 2026, 'Power Delivery · 2026', 'A reliable bench voltage reference source forms the foundational core engine for troubleshooting complex designs.|This module steps through high-voltage stepping, rectifying operations, bulk filtering, and fine feedback linear modification loops.', '[{"name":"Transformer 220V to 12V","spec":"Step-down iron core element","qty":"1"},{"name":"Bridge Rectifier 1N4007","spec":"Silicon diode array block","qty":"4"},{"name":"LM317T Regulator","spec":"TO-220 linear adjustable package","qty":"1"}]', '["Carefully route primary transformer wire pairs to high-voltage safety entries.","Connect rectifier bridge junctions across secondary low-voltage outputs.","Wire linear filtering capacitors to isolate residual ripple waves.","Integrate control potentiometers directly along adjust validation pathways."]', 'Variable Power Units Walkthrough', '18:40', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'url'),
(2, 'Automated Home Weather Station', 'An outdoor sensor hub running on ESP32 boards tracking environment variations to streaming tracking panels.', 'ESP32 chip, custom environment sensor breakout array, micro solar controller setups.', 'Advanced', 'IoT', 2026, 'IoT Systems · 2026', 'Monitoring ambient atmospheric dynamics demands accurate instrumentation configurations.|This project integrates real-time distance calculations with responsive motor tracking software algorithms to map optimal travel paths around barriers.', '[{"name":"ESP32 Development Panel","spec":"Dual-core wireless transceiver board","qty":"1"},{"name":"BME280 Breakout Board","spec":"I2C environmental tracking module","qty":"1"},{"name":"LiPo Module TP4056","spec":"Integrated battery protection module","qty":"1"}]', '["Wire sensor communication loops into targeted microcontroller pins.","Configure communication parameters to transmit payload packets via REST connection routes.","Flash deep sleep routines to preserve system battery voltages during idle intervals."]', 'Deploying IoT Nodes Guide', '24:15', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'url'),
(3, '555 Precision Square-Wave Generator', 'A highly reliable astable pulse framework block delivering variable hardware driving pulses.', 'NE555 Timer IC, timing resistors, ceramic output filtering capacitors.', 'Beginner', 'Circuits', 2026, 'Signal Clocks · 2026', 'Clock generators orchestrate logic updates across complex operational environments.|This build outlines frequency manipulation via external resistance variations.', '[{"name":"NE555 Master Timer","spec":"Standard 8-pin inline system IC","qty":"1"},{"name":"10k Potentiometer","spec":"Rotary adjustment resistor block","qty":"2"}]', '["Seat the 8-pin execution IC securely across your prototyping board.","Bridge targeted discharge parameters across configuration tracking resistors.","Connect scope capture instrumentation probes across output pin layouts to verify pulse symmetry."]', '555 Timing Systems Analysis', '12:05', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'url'),
(4, 'Autonomous Maze-Solving Vehicle', 'A specialized robotics layout blending ultrasound sensor tracking paths with proportional motor balancing loops.', 'Chassis framework, geardown motors, tracking sensor modules.', 'Advanced', 'Robotics', 2026, 'Robotics · 2026', 'Navigating unknown structural labyrinths demands instant runtime recalculations.|This project integrates real-time distance calculations with responsive motor tracking software algorithms to map optimal travel paths around barriers.', '[{"name":"Arduino Uno R3","spec":"ATmega328P processing module","qty":"1"},{"name":"HC-SR04 Transceiver","spec":"Ultrasonic distance tracking node","qty":"3"},{"name":"L298N Motor Driver","spec":"Dual H-Bridge power management block","qty":"1"}]', '["Assemble the structural mobility frame and mount the drive wheels.","Wire ultrasonic sensor clusters facing key forward and peripheral tracking vectors.","Establish feedback loops inside software logic routines to handle course updates dynamically."]', 'Robotics Navigation Logic Systems', '31:50', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'url');

-- Seeding Simulation Resource Directories
INSERT INTO `simulation_tools` (`id`, `tool_name`, `description`, `url_path`) VALUES
(1, 'NI Multisim System Interface', 'Professional environment for circuit tracing and simulation visualization analysis.', 'multisim_view.html'),
(2, 'Autodesk Tinkercad Prototyping Space', 'Interactive educational platform mapping virtual breadboards and live system logic validation.', 'tinkercad_view.html');