-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 28, 2026 at 11:41 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bicpes_hub`
--
CREATE DATABASE IF NOT EXISTS `bicpes_hub` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bicpes_hub`;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `requirements` text NOT NULL,
  `difficulty` enum('Beginner','Intermediate','Advanced') NOT NULL DEFAULT 'Intermediate',
  `category` varchar(100) NOT NULL DEFAULT 'General',
  `year` int(11) NOT NULL DEFAULT 2026,
  `hero_tag` varchar(100) DEFAULT NULL,
  `overview_body` longtext DEFAULT NULL COMMENT 'Detailed documentation string splits',
  `components_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Dynamic structured array mapping target parts list data' CHECK (json_valid(`components_json`)),
  `procedure_steps` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Array collection storing step-by-step building instructions' CHECK (json_valid(`procedure_steps`)),
  `video_title` varchar(255) DEFAULT NULL,
  `video_duration` varchar(50) DEFAULT '--:--',
  `video_url` varchar(512) DEFAULT NULL COMMENT 'YouTube direct embedded stream path, or raw video filesystem path',
  `video_type` enum('url','file') DEFAULT NULL COMMENT 'Lookup tracker flag to identify player engine type',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `title`, `description`, `requirements`, `difficulty`, `category`, `year`, `hero_tag`, `overview_body`, `components_json`, `procedure_steps`, `video_title`, `video_duration`, `video_url`, `video_type`, `created_at`) VALUES
(7, 'Logic Gates Boolean Algebra', 'A practical exploration of fundamental logic gates (AND, OR, NOT, NAND, NOR, XOR) to implement and verify basic Boolean algebraic functions.', 'Logic Gates', 'Beginner', 'General', 2026, 'Problem Solving', 'This project introduces the core building blocks of digital computing. Students construct circuits on a breadboard or simulation software to map physical inputs to binary outputs ($1$ and $0$). By testing various configurations, you verify how complex logical conditions can be simplified mathematically using algebraic theorems to reduce component counts.', '[]', '[]', '', '--:--', '', '', '2026-05-26 15:11:12'),
(8, 'Boolean Minterm and Maxterm', 'Designing optimized combinational logic circuits directly from a truth table using Sum-of-Products (SOP) and Product-of-Sums (POS) standard forms.', 'Logic Gates', 'Beginner', 'General', 2026, 'Problem Solving', 'This project bridges the gap between a word problem and working hardware. You take a specific logic goal, map out its desired truth table, and extract either the Minterms (where the output must be active-high) or Maxterms (where the output must be active-low). These terms are then mapped into logic gates, demonstrating systematic circuit synthesis and design optimization.', '[]', '[]', '', '--:--', '', '', '2026-05-26 15:13:55'),
(9, 'De Morgan\'s Theorem', 'Experimental proof of De Morgan\'s dual laws, demonstrating how NAND and NOR gates can completely replace and replicate individual AND/OR structures.', 'Logic Gates', 'Beginner', 'General', 2026, 'Problem Solving', 'De Morgan’s Laws state that $\\overline{A \\cdot B} = \\overline{A} + \\overline{B}$ and $\\overline{A + B} = \\overline{A} \\cdot \\overline{B}$. This project requires building equivalent circuit branches alongside each other to prove these mathematical identities. It highlights a critical manufacturing principle: how engineers can construct any arbitrary digital system using only universal gates (NAND or NOR), reducing production overhead.', '[]', '[]', '', '--:--', '', '', '2026-05-26 15:14:45'),
(11, 'Flip-Flops', 'An introduction to sequential logic networks using SR, D, JK, or T flip-flops to achieve stable, single-bit data storage.', 'Logic Gates', 'Beginner', 'Circuits', 2026, 'Circuit', 'Unlike combinational logic which reacts purely to current inputs, flip-flops introduce memory and feedback loops. In this project, you construct or analyze circuits that can hold a state (either Set or Reset) even after the initial input signal is gone. This forms the technological basis for registers, memory blocks, and state machine control units.', '[]', '[]', '', '--:--', '', '', '2026-05-26 15:16:18'),
(12, '7 Segment Display', 'Driving a standard 7-segment numerical display component using a dedicated BCD-to-7-Segment decoder/driver integrated circuit (like the 74LS47 or 74LS48).', '7 Segment Display, Logic Gates, Jumping Wires', 'Intermediate', 'Circuits', 2026, 'Circuit', 'This project explores the decoding logic required to convert a 4-bit Binary Coded Decimal (BCD) signal into a layout capable of illuminating specific numeric glyphs ($0$ through $9$). You will work through common-anode or common-cathode electrical configurations, learning how individual pin lines are selected dynamically to present numbers to users.', '[{\"name\":\"74LS47 IC\",\"spec\":\"\",\"qty\":\"1\"},{\"name\":\"74LS90\",\"spec\":\"\",\"qty\":\"1\"},{\"name\":\"7-Segment Display\",\"spec\":\"Common Anode or Common Cathode\",\"qty\":\"1\"},{\"name\":\"Resistors\",\"spec\":\"\",\"qty\":\"\"},{\"name\":\"Power Supply\",\"spec\":\"\",\"qty\":\"\"},{\"name\":\"Breadboard\",\"spec\":\"\",\"qty\":\"\"}]', '[{\"title\":\"Mount the Components\",\"description\":\"Insert the decoder IC (74LS47/48) and the 7-segment display onto the breadboard.\",\"note\":null},{\"title\":\"Connect Decoder to Display\",\"description\":\"Wire the output pins ($a, b, c, d, e, f, g$) of the decoder IC to the corresponding segment pins of the 7-segment display.\",\"note\":null},{\"title\":\"Install Current Protection\",\"description\":\"Place a 330Ω resistor in series on each of the seven connection lines between the decoder outputs and display segments.\",\"note\":null},{\"title\":\"Wire Power Connections\",\"description\":\"Connect Pin 16 of the IC to the +5V rail and Pin 8 to Ground. Connect the common pin(s) of the display to +5V (for Common Anode) or Ground (for Common Cathode).\",\"note\":null},{\"title\":\"Set Up Binary Inputs\",\"description\":\"Connect the four binary input pins ($A, B, C, D$) of the decoder IC either to the outputs of a BCD counter IC or to four manual switches tied to pull-up/pull-down resistors.\",\"note\":null},{\"title\":\"Power On and Test\",\"description\":\"Apply 5V power and change the binary inputs to verify that the display illuminates the matching decimal digits ($0$ through $9$).\",\"note\":null}]', '7-segment-display', '--:--', 'youtube.com/watch?si=fTgptLIzIlWplBa_&fbclid=IwY2xjawSDBBZleHRuA2FlbQIxMABicmlkETFhNmZHVzB6VUw5MmVXRm1tc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHrhMenUUvYiv6bSHXGMGfizTMVLfO2l0nvCVCoy5wZEmZoZixe31L8RaBcFC_aem_Lif_9pKmeuy5_LekN6DLSw&v=smeUN1Bxj3M&feature=youtu.be', 'url', '2026-05-26 15:22:30'),
(13, '24 Shot Clock', 'A complete synchronous down-counter system designed to mimic a basketball shot clock, counting down from 24 to 0 seconds with reset controls.', '7 segment Display, Timer, Jumping wires', 'Advanced', 'PCB Design', 2026, 'Circuit', 'As a capstone logic assembly, this project integrates sequential clocks, cascading down-counters (such as the 74LS192), and logic decoding logic. It features a stable 1Hz clock source (typically built using a 555 timer IC) that continuously ticks down dual 7-segment display digits. The system incorporates hardwired logic gates to freeze the timer at zero and illuminate a buzzer/indicator, alongside dedicated manual overrides to reset the timer instantly back to 24 seconds.', '[{\"name\":\"NE555\",\"spec\":\"\",\"qty\":\"1\"},{\"name\":\"74LS192\",\"spec\":\"\",\"qty\":\"2\"},{\"name\":\"74LS47\",\"spec\":\"\",\"qty\":\"2\"},{\"name\":\"74LS08\",\"spec\":\"\",\"qty\":\"1\"},{\"name\":\"7-Segment Displays\",\"spec\":\"\",\"qty\":\"2\"},{\"name\":\"Resistors\",\"spec\":\"\",\"qty\":\"\"},{\"name\":\"Capacitors\",\"spec\":\"\",\"qty\":\"\"},{\"name\":\"Push Buttons\",\"spec\":\"\",\"qty\":\"2\"},{\"name\":\"Toggle Switch\",\"spec\":\"\",\"qty\":\"2\"},{\"name\":\"Jumping wire\",\"spec\":\"\",\"qty\":\"\"},{\"name\":\"Power Supply\",\"spec\":\"12V\",\"qty\":\"1\"}]', '[{\"title\":\"Build the 1Hz Clock Circuit\",\"description\":\"Assemble the NE555 timer in astable mode using the 10kΩ potentiometer and 10µF capacitor to output a stable 1-second pulse from Pin 3.\",\"note\":null},{\"title\":\"Wire the Counters\",\"description\":\"Connect the 1Hz clock signal to the \\\"Count Down\\\" input pin of the first 74LS192 IC (seconds units). Cascade the \\\"Borrow\\\" pin of the first counter to the \\\"Count Down\\\" pin of the second counter (seconds tens).\",\"note\":null},{\"title\":\"Connect Decoder Drivers\",\"description\":\"Route the 4-bit BCD output pins ($Q_A, Q_B, Q_C, Q_D$) from each counter IC into the input pins of their respective 74LS47/74LS48 decoder ICs.\",\"note\":null},{\"title\":\"Wire the 7-Segment Display\",\"description\":\" Wire the output pins ($a$ through $g$) of each decoder IC to the matching segment pins of the 7-segment displays through 330Ω current-limiting resistors.\",\"note\":null},{\"title\":\"Set the 24-Second Load Logic\",\"description\":\"Use the AND gate IC to hardwire the asynchronous load lines so that pressing the Reset button automatically pre-loads a binary 2 (0010) into the tens counter and a binary 4 (0100) into the units counter.\",\"note\":null},{\"title\":\"Apply Power and Test\",\"description\":\"Turn on the 5V power supply, press the reset button to verify the display reads 24, and adjust the potentiometer until the timer counts down exactly once per second.\",\"note\":null}]', '24-shotclock', '--:--', 'https://www.youtube.com/watch?v=q_kh7eOHoOM', 'url', '2026-05-26 15:27:48');

-- --------------------------------------------------------

--
-- Table structure for table `simulation_tools`
--

CREATE TABLE `simulation_tools` (
  `id` int(10) UNSIGNED NOT NULL,
  `tool_name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `url_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `simulation_tools`
--

INSERT INTO `simulation_tools` (`id`, `tool_name`, `description`, `url_path`, `created_at`) VALUES
(1, 'NI Multisim System Interface', 'Professional environment for circuit tracing and simulation visualization analysis.', 'multisim_view.html', '2026-05-26 13:55:01'),
(2, 'Autodesk Tinkercad Prototyping Space', 'Interactive educational platform mapping virtual breadboards and live system logic validation.', 'tinkercad_view.html', '2026-05-26 13:55:01');

-- --------------------------------------------------------

--
-- Table structure for table `topics`
--

CREATE TABLE `topics` (
  `id` int(10) UNSIGNED NOT NULL,
  `topic_num` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(100) NOT NULL,
  `overview_body` longtext DEFAULT NULL COMMENT 'Pipe-separated text blocks rendered as paragraphs',
  `pdf_filename` varchar(255) DEFAULT NULL COMMENT 'Target filename reference within Materials directory',
  `activities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Dynamic object list detailing structured tasks and experiments' CHECK (json_valid(`activities`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `topics`
--

INSERT INTO `topics` (`id`, `topic_num`, `name`, `description`, `category`, `overview_body`, `pdf_filename`, `activities`, `created_at`) VALUES
(8, 2, 'Kirchhoff\'s Laws', 'Mathematical principles managing the conservation of electrical charge and energy throughout electrical circuit loops and junctions.', 'Circuits & Electronics', 'kirchoffs', '', '[]', '2026-05-26 15:31:29'),
(9, 3, 'K-Mapping (Karnaugh Maps)', 'A visual grid-based method used to simplify multi-variable Boolean algebra expressions without using complex mathematical theorems.', 'Circuits & Electronics', NULL, NULL, NULL, '2026-05-26 15:31:51'),
(10, 4, 'Boolean Algebra', 'A specialized branch of mathematics dealing with binary variables and logical operations where values are restricted to true ($1$) or false ($0$).', 'Circuits & Electronics', NULL, NULL, NULL, '2026-05-26 15:32:14'),
(11, 5, 'Flip-Flops', 'Clock-driven sequential circuit structures capable of storing a single bit of binary memory indefinitely until rewritten.', 'Circuits & Electronics', NULL, NULL, NULL, '2026-05-26 15:32:44'),
(12, 6, '7-Segment Display', 'An electronic packaging array composed of seven individual LED bars arranged in a figure-8 pattern to display numerical figures.', 'Circuits & Electronics', 'This is project for the logic circuits.', '7-Segment_f680e6.pdf', '[{\"type\":\"Experiment\",\"title\":\"24 Shot Cock\",\"description\":\"A complete synchronous down-counter system designed to mimic a basketball shot clock, counting down from 24 to 0 seconds with reset controls.\"},{\"type\":\"Exercise\",\"title\":\"Manual BCD-to-7-Segment Decoder Input Verification\",\"description\":\" Students construct a basic 7-segment driver circuit on a breadboard using a 74LS47 or 74LS48 decoder IC. Instead of a clock signal, four manual slide switches or jumper wires are used to input static 4-bit binary values ($0000$ to $1001$) to manually test and record how each input translates to numerical characters ($0$ to $9$) on the display.\"},{\"type\":\"Exercise\",\"title\":\"Hardware Reaction Timer\",\"description\":\"An experiment where a high-speed clock signal streams into a synchronous counter hooked up to a 7-segment display module. A push-button configuration acts as a stop switch; when a supervisor drops a signal or activates the timer, the student must press the button as fast as possible to freeze the display, creating a visual measurement of their physical reaction time in fractions of a second.\"}]', '2026-05-26 15:33:49'),
(13, 7, '24 Shot Clock Lesson', 'This is for some basic information of 24 shot clock.', 'Soldering & Fabrication', 'This lesson will help student to build their own shot clock.', '24-Second-Shot-Clock.pdf', '[{\"type\":\"Exercise\",\"title\":\"Reversed Count 24 Shot clock\",\"description\":\"This project is a 24 shot clocks that enable the clock to count  in reversed.\"}]', '2026-05-27 00:01:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `student_number` varchar(50) DEFAULT NULL COMMENT 'Left NULL for Admin accounts',
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL COMMENT 'Secure bcrypt string',
  `role` enum('admin','student') NOT NULL DEFAULT 'student',
  `date_of_birth` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `student_number`, `first_name`, `last_name`, `password_hash`, `role`, `date_of_birth`, `created_at`) VALUES
(1, NULL, 'System', 'Administrator', '$2y$12$5jFv63PMXzS6bnANfttIR.gz7Q0V4wl6CvIjC4Dz1kxkTCU6XusHe', 'admin', '1995-01-01', '2026-05-26 13:55:01'),
(2, '2026-0001-STUDENT', 'Juan', 'Dela Cruz', '$2y$12$R31m7P7K.rXoVym5E5k8AeuG0WkW1/fH2aL9vBC2xZmHeO.uH4f1C', 'student', '2005-06-15', '2026-05-26 13:55:01'),
(3, '2321171', 'Guian Jaundell', 'Manalo', '$2y$12$3dkOh/m4MhtP1KyAxJfqKee.5aiuvBuelSZ74WDuaQ3J4F32kYAX2', 'student', '2004-12-22', '2026-05-26 16:55:47');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `simulation_tools`
--
ALTER TABLE `simulation_tools`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `topic_num` (`topic_num`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_number` (`student_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `simulation_tools`
--
ALTER TABLE `simulation_tools`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `topics`
--
ALTER TABLE `topics`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

--
-- Dumping data for table `pma__designer_settings`
--

INSERT INTO `pma__designer_settings` (`username`, `settings_data`) VALUES
('root', '{\"angular_direct\":\"direct\",\"relation_lines\":\"true\",\"snap_to_grid\":\"off\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"bicpes_hub\",\"table\":\"users\"},{\"db\":\"bicpes_hub\",\"table\":\"topics\"},{\"db\":\"bicpes_hub\",\"table\":\"projects\"},{\"db\":\"bicpes_db\",\"table\":\"students\"},{\"db\":\"bicpes_db\",\"table\":\"admins\"},{\"db\":\"bicpes_db\",\"table\":\"topics\"},{\"db\":\"accounts\",\"table\":\"student_info\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2026-05-28 09:41:06', '{\"Console\\/Mode\":\"collapse\",\"Export\\/file_template_server\":\"BLH_database\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
