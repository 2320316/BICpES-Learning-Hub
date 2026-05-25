-- ============================================================
--  BICpES Learning Hub — Database Schema (UPDATED)
--  Engine : InnoDB   |  Charset : utf8mb4_unicode_ci
--
--  CHANGES FROM PREVIOUS VERSION:
--    - projects table: added procedure_steps (JSON), video_title, video_duration
--    - topics table: added overview_extra (JSON), activities (JSON), pdf_filename
--    - Both tables: first 3 records seeded with full detail data
--
--  Admin login: Identifier = ADMIN | Password = password
--  Then change password from the user panel.
-- ============================================================

CREATE DATABASE IF NOT EXISTS `bicpes_hub`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `bicpes_hub`;

-- ── USERS ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `users` (
    `id`             INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    `student_number` VARCHAR(20)      NULL DEFAULT NULL COMMENT 'NULL for admin accounts',
    `last_name`      VARCHAR(60)      NOT NULL,
    `first_name`     VARCHAR(60)      NOT NULL,
    `date_of_birth`  DATE             NOT NULL,
    `password_hash`  VARCHAR(255)     NOT NULL COMMENT 'bcrypt via password_hash()',
    `role`           ENUM('student','admin') NOT NULL DEFAULT 'student',
    `created_at`     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_student_number` (`student_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── TOPICS ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `topics` (
    `id`            INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    `topic_num`     SMALLINT      NOT NULL COMMENT 'Display order number (01, 02 …)',
    `name`          VARCHAR(120)  NOT NULL,
    `description`   TEXT          NOT NULL,
    `category`      VARCHAR(80)   NOT NULL COMMENT 'e.g. Circuits & Electronics',
    `overview_body` TEXT          NULL     COMMENT 'Full overview paragraphs (pipe-delimited, split on | in PHP)',
    `pdf_filename`  VARCHAR(255)  NULL     COMMENT 'Filename inside Materials/ folder e.g. Basic_Circuit_Theory.pdf',
    `activities`    JSON          NULL     COMMENT 'Array of {type, title, description} objects',
    `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_topic_num` (`topic_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── PROJECTS ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `projects` (
    `id`               INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title`            VARCHAR(150) NOT NULL,
    `description`      TEXT         NOT NULL,
    `requirements`     TEXT         NOT NULL COMMENT 'Parts list / prerequisites as plain text or JSON',
    `difficulty`       ENUM('Beginner','Intermediate','Advanced') NOT NULL DEFAULT 'Intermediate',
    `category`         VARCHAR(80)  NOT NULL DEFAULT 'General'   COMMENT 'e.g. Embedded, IoT, PCB Design',
    `year`             SMALLINT     NOT NULL DEFAULT 2026,
    `hero_tag`         VARCHAR(120) NOT NULL DEFAULT 'Embedded Systems',
    `overview_body`    TEXT         NULL     COMMENT 'Additional overview paragraphs (pipe-delimited)',
    `procedure_steps`  JSON         NULL     COMMENT 'Array of {title, description, note?} objects',
    `components_json`  JSON         NULL     COMMENT 'Array of {name, spec, qty} objects',
    `video_title`      VARCHAR(200) NULL,
    `video_duration`   VARCHAR(20)  NULL     COMMENT 'e.g. 42:17',
    `created_at`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── SIMULATION TOOLS ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `simulation_tools` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `tool_name`   VARCHAR(80)  NOT NULL,
    `description` TEXT         NOT NULL,
    `url_path`    VARCHAR(255) NOT NULL COMMENT 'Relative path to the tool detail page',
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_tool_name` (`tool_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── SEED DATA ────────────────────────────────────────────────────────────────

-- Admin account (password: "password" — change immediately after setup)
INSERT INTO `users` (`student_number`, `last_name`, `first_name`, `date_of_birth`, `password_hash`, `role`)
VALUES (
    NULL,
    'Administrator',
    'BICpES',
    '1990-01-01',
    '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'admin'
);

-- ── TOPICS SEED ──────────────────────────────────────────────────────────────
INSERT INTO `topics` (`topic_num`, `name`, `description`, `category`, `overview_body`, `pdf_filename`, `activities`) VALUES
(1, 'Basic Circuit Theory',
 'Ohm''s Law, Kirchhoff''s Laws, mesh & nodal analysis, and Thevenin/Norton equivalents.',
 'Circuits & Electronics',
 'Basic Circuit Theory forms the bedrock of every electrical and electronic system you will ever design, analyze, or troubleshoot. Understanding how voltage, current, and resistance interact — governed by Ohm''s Law — gives you a universal tool for predicting circuit behavior before you touch a single component.|Kirchhoff''s Voltage Law (KVL) and Kirchhoff''s Current Law (KCL) extend this foundation to complex multi-loop networks, enabling systematic mesh and nodal analysis of any linear circuit. Mastery of Thevenin and Norton equivalent circuits further allows you to simplify an entire sub-network into two components, dramatically reducing analysis complexity.|This topic covers the full analytical toolkit expected in CPE coursework and board examinations: from simple resistive dividers to multi-source networks, superposition, and source transformation.',
 'Basic_Circuit_Theory.pdf',
 '[{"type":"Exercise","title":"Ohm''s Law Drill","description":"Solve 20 resistor problems using Ohm''s Law. Given any two of V, I, R — compute the third. Problems range from single resistors to series-parallel combinations."},{"type":"Exercise","title":"KVL & KCL Analysis","description":"Apply Kirchhoff''s Laws to three multi-loop circuits provided on the worksheet. Write the mesh equations, solve the system, and verify using simulation in Tinkercad or Multisim."},{"type":"Activity","title":"Build a Voltage Divider","description":"Using a breadboard, two resistors (1kΩ and 2.2kΩ), and a 9V battery, construct a voltage divider. Measure Vout with a multimeter. Compare your measured value to the theoretical prediction and calculate percent error."},{"type":"Experiment","title":"Thevenin Equivalent Lab","description":"Given a 5-component resistive network with a 12V source, find the Thevenin equivalent (Vth and Rth) analytically. Then verify experimentally by measuring open-circuit voltage and short-circuit current on the physical breadboard build. Document all steps and discrepancies in a lab report."}]'
),
(2, 'Semiconductor Devices',
 'Diodes, BJTs, MOSFETs — operation, biasing, and small-signal models for amplifier design.',
 'Circuits & Electronics',
 'Semiconductor devices are the fundamental active building blocks of all modern electronics. This topic begins with the p-n junction diode — exploring its I-V characteristics, forward and reverse bias behavior, and practical applications including rectifiers, clipping circuits, and Zener regulators.|Bipolar Junction Transistors (BJTs) are treated in depth: NPN and PNP structures, active/saturation/cutoff regions, DC biasing for stable Q-point design, and the small-signal hybrid-π model for AC amplifier analysis. Common-emitter, common-base, and common-collector configurations are compared with respect to gain, input impedance, and output impedance.|Metal-Oxide-Semiconductor Field-Effect Transistors (MOSFETs) complete the picture — enhancement and depletion modes, threshold voltage, the square-law model, and CMOS inverter operation. Together these devices underpin every amplifier, switch, and logic gate in CPE curriculum.',
 'Semiconductor_Devices.pdf',
 '[{"type":"Exercise","title":"Diode I-V Curve Sketch","description":"Sketch the I-V characteristic curve for a silicon diode (0.7V forward drop). Mark the forward, reverse, and breakdown regions. Label key parameters: Vf, VRRM, Iz."},{"type":"Exercise","title":"BJT Q-Point Design","description":"Design a voltage-divider bias circuit for an NPN BJT (β = 100) with VCC = 12V targeting IC = 5mA and VCE = 6V. Calculate R1, R2, RC, and RE. Verify in Multisim."},{"type":"Activity","title":"Rectifier Circuit Build","description":"Construct a full-wave bridge rectifier on a breadboard using 4× 1N4007 diodes, a 470µF filter capacitor, and a 12V AC transformer secondary. Measure DC output voltage and calculate ripple factor."},{"type":"Experiment","title":"MOSFET Switching Lab","description":"Using an IRF540 N-channel MOSFET, build a low-side switch circuit to control a 12V DC motor from a 5V Arduino PWM signal. Measure gate threshold voltage by sweeping VGS and recording drain current. Plot the transfer characteristic."}]'
),
(3, 'Operational Amplifiers',
 'Ideal op-amp model, inverting/non-inverting configs, integrators, differentiators, and active filters.',
 'Circuits & Electronics',
 'The operational amplifier is one of the most versatile analog building blocks ever created. Starting from the ideal op-amp model — infinite gain, infinite input impedance, zero output impedance — this topic builds intuition for how negative feedback transforms the op-amp into a precision analog processing element.|Core configurations are covered in depth: inverting and non-inverting amplifiers with gain derivation from the virtual-ground concept, summing amplifiers for audio mixing and DAC design, difference amplifiers for sensor interfacing, and voltage followers for impedance buffering.|The topic then progresses to dynamic applications: integrators and differentiators essential for waveform shaping and PID control loops, followed by active first-order and second-order Butterworth filters — both low-pass and high-pass — and comparator circuits. Real op-amp limitations (slew rate, input offset, GBW product) are also addressed.',
 'Operational_Amplifiers.pdf',
 '[{"type":"Exercise","title":"Gain Calculation Set","description":"For each of 8 op-amp circuits (inverting, non-inverting, difference, summing), calculate the output voltage given the input voltages and resistor values. Show all working using the virtual-ground method."},{"type":"Exercise","title":"Filter Design Worksheet","description":"Design a 2nd-order Sallen-Key low-pass Butterworth filter with fc = 1kHz and unity DC gain. Choose standard resistor and capacitor values. Verify your design in Multisim by plotting the Bode magnitude response."},{"type":"Activity","title":"Audio Summing Mixer","description":"Build a 3-input inverting summing amplifier using an LM741 or TL071 op-amp. Use three signal generators as inputs with different amplitudes. Measure the output on an oscilloscope and verify the superposition of signals."},{"type":"Experiment","title":"Integrator & Square-to-Triangle Converter","description":"Connect an op-amp integrator (with feedback capacitor) driven by a 1kHz square wave from a function generator. Observe the triangular wave output on an oscilloscope. Vary the RC time constant and record how it affects amplitude and linearity. Submit oscilloscope screenshots and analysis."}]'
),
(4, 'PCB Design & Etching',
 'Schematic capture, layout rules, trace width, DRC, and chemical etching.',
 'Circuits & Electronics',
 'Printed Circuit Board (PCB) design is the process of translating an electrical schematic into a physical layout where connections are made through copper traces etched onto an insulating substrate. It is one of the most foundational practical skills in Computer Engineering, bridging the gap between theory and real hardware.|Etching is the chemical process that removes excess copper from the board, leaving only the desired trace pattern. Learning both gives you the ability to produce permanent, professional-grade circuit boards from scratch — a core skill for every CPE student heading into hardware design, embedded systems, or product development.|This topic covers the full cycle: EDA software layout, design rule checking, Gerber export, photo or laser transfer, chemical etching, drilling, and basic inspection techniques.',
 'PCB_Design_and_Etching.pdf',
 '[{"type":"Exercise","title":"Trace Width Calculator","description":"Given a circuit carrying 2A on a 1oz copper trace in a 25°C ambient environment, calculate the minimum required trace width using the IPC-2221 standard formula. Compare your result with the KiCad trace width calculator."},{"type":"Exercise","title":"DRC Error Hunt","description":"Open the provided KiCad project file with 8 intentional DRC violations. Identify and fix every error — clearance violations, unrouted nets, missing courtyard, and silkscreen overlaps. Submit the corrected file and a written list of each fix."},{"type":"Activity","title":"Design a Single-Layer Power Supply PCB","description":"Using KiCad, design a single-layer PCB for a 5V / 1A regulated power supply using an LM7805 voltage regulator. The board must pass DRC, include proper decoupling capacitors, and use traces wide enough to handle the full output current. Export Gerbers and submit for peer review."},{"type":"Experiment","title":"Full PCB Fabrication: Etch Your Own Board","description":"Take your LM7805 power supply design all the way to a physical board. Print the copper layer on transparency film, perform UV or toner transfer onto a copper-clad FR4 board, etch using the ferric chloride process, drill pad holes, and apply a protective coating. Verify with a multimeter continuity test and solder one set of components. Document the process with photos at each stage."}]'
),
(5, 'Boolean Algebra & Logic Gates',
 'Truth tables, SOP/POS, Karnaugh maps, De Morgan''s laws, and universal gate implementation.',
 'Digital Systems',
 NULL, NULL, NULL),
(6, 'Sequential Logic & Flip-Flops',
 'SR, D, JK, T flip-flops; registers, counters, and finite state machines.',
 'Digital Systems',
 NULL, NULL, NULL),
(7, 'FPGA & Verilog/VHDL',
 'HDL syntax, synthesis, simulation, timing constraints, and hands-on Basys3 implementation.',
 'Digital Systems',
 NULL, NULL, NULL),
(8, 'Microcontroller Programming',
 'AVR/PIC/ARM architecture, registers, interrupts, timers, PWM, and peripheral interfacing in C/C++.',
 'Embedded & Programming',
 NULL, NULL, NULL),
(9, 'IoT & Wireless Protocols',
 'MQTT, WiFi, BLE, LoRa — protocol comparison and IoT pipeline construction.',
 'Embedded & Programming',
 NULL, NULL, NULL),
(10, 'Through-Hole Soldering',
 'Tool selection, flux, heat management, joint inspection, and defect troubleshooting for THT components.',
 'Soldering & Fabrication',
 NULL, NULL, NULL),
(11, 'SMD Soldering & Rework',
 'Hot air, reflow techniques, stencil paste, and BGA reballing basics for surface-mount work.',
 'Soldering & Fabrication',
 NULL, NULL, NULL),
(12, 'PCB Fabrication Process',
 'From Gerber export to chemical etching, drilling, masking, and quality-checking the final board.',
 'Soldering & Fabrication',
 NULL, NULL, NULL);


-- ── PROJECTS SEED ────────────────────────────────────────────────────────────
INSERT INTO `projects` (`title`, `description`, `requirements`, `difficulty`, `category`, `year`, `hero_tag`, `overview_body`, `procedure_steps`, `components_json`, `video_title`, `video_duration`) VALUES
(
  'Smart Home Controller',
  'An offline, ESP32-powered home automation architecture utilizing double-layer hardware routing, specialized multi-channel relay modules, and dedicated peripheral arrays.',
  'ESP32 DevKit v1, 5V Relay Module ×8, DHT22 Sensor ×3, TFT Touch Display 2.4", LM2596 Buck Converter ×2, PIR Motion Sensor ×4, Custom PCB (2-layer), 12V DC Power Supply',
  'Advanced', 'Embedded', 2026, 'Embedded Systems · 2026',
  'The Smart Home Controller is an ESP32-based automation hub designed to manage lighting, temperature, and security systems across a household. It uses MQTT protocol, a custom Android companion app, and a local voice command interface — all without any cloud dependency.|The physical system is built around a custom double-layer PCB with a power regulation circuit, an 8-channel relay driver array, and a 2.4" TFT touch display for local feedback. All communication is encrypted over local Wi-Fi, making it fully offline-capable.|This project was developed as part of CPE 421 (Embedded Systems Design) and covers the complete design cycle: schematic capture, PCB layout, etching, soldering, firmware development, and mobile app integration.',
  '[{"title":"Schematic Design & PCB Layout","description":"Open KiCad or EasyEDA and recreate the circuit schematic from the provided reference diagram. Assign component footprints, run the ERC (Electrical Rules Check), then switch to PCB layout view. Route all traces following the design rules: power traces at minimum 1mm width, signal traces at 0.4mm. Add a ground fill to both layers and run DRC before exporting Gerbers.","note":"💡 Keep the relay driver section physically separated from the ESP32 signal area to minimize electromagnetic interference."},{"title":"PCB Etching & Drilling","description":"Print the Gerber top-copper layer on a transparency film at 1:1 scale using a laser printer. Transfer the pattern onto a copper-clad FR4 board using the UV exposure method or toner transfer. Etch using ferric chloride solution (40°C, ~15 minutes), rinse thoroughly with water, then neutralize with baking soda solution. Drill all holes using 0.8mm and 1.0mm drill bits at the designated pad locations.","note":null},{"title":"Component Soldering","description":"Begin with passive components (resistors, capacitors) and work toward larger components. Solder the LM2596 buck converters first and verify regulated 5V output before proceeding. Solder pin headers, relay modules, and finally the ESP32 DevKit. Use flux paste on all joints and inspect each solder joint under magnification for bridges or cold joints.","note":"⚠ Do not solder the ESP32 until power supply output has been verified with a multimeter."},{"title":"Firmware Upload & Configuration","description":"Open the provided Arduino sketch in VS Code with the PlatformIO extension. Install required libraries: PubSubClient (MQTT), Adafruit ILI9341 (TFT), and DHT sensor library. Configure your local Wi-Fi credentials and MQTT broker IP in the config.h file. Upload to the ESP32 via USB and open the Serial Monitor at 115200 baud to verify successful connection.","note":null},{"title":"Mobile App Setup & Testing","description":"Install the companion APK on an Android device connected to the same local network. Open the app, enter the MQTT broker IP, and pair with the controller. Test each relay individually from the app, verify DHT22 sensor readings appear on the TFT display, and confirm PIR motion alerts are published to the correct MQTT topics. Perform a full system test by running all 8 zones simultaneously for 10 minutes.","note":null}]',
  '[{"name":"ESP32 DevKit v1","spec":"240 MHz dual-core, Wi-Fi + Bluetooth","qty":"×1"},{"name":"5V Relay Module","spec":"10A / 250VAC, optocoupler isolated","qty":"×8"},{"name":"DHT22 Sensor","spec":"Temperature & Humidity, ±0.5°C accuracy","qty":"×3"},{"name":"TFT Touch Display","spec":"2.4\\\" ILI9341, 240×320, SPI interface","qty":"×1"},{"name":"LM2596 Buck Converter","spec":"Input 12V → Output 5V / 3A regulated","qty":"×2"},{"name":"PIR Motion Sensor","spec":"HC-SR501, adjustable sensitivity & delay","qty":"×4"},{"name":"Custom PCB (2-layer)","spec":"FR4 substrate, 1oz copper, HASL finish","qty":"×1"},{"name":"12V DC Power Supply","spec":"2A minimum, barrel jack connector","qty":"×1"},{"name":"Jumper Wires & Headers","spec":"Male/female, 2.54mm pitch assorted","qty":"×1 set"}]',
  'Smart Home Controller — Complete Build Guide', '42:17'
),
(
  'Custom Arduino Shield',
  'A multi-purpose prototyping shield for Arduino Uno featuring a dedicated OLED display header, onboard sensor breakouts, and a prototyping area with power rails.',
  'Arduino Uno R3, 0.96" OLED Display (SSD1306), DS3231 RTC Module, LM35 Temperature Sensor, PCB Single-layer, Male/female pin headers, SMD bypass capacitors',
  'Intermediate', 'PCB Design', 2025, 'PCB Design · 2025',
  'This project walks through the design and fabrication of a custom Arduino Uno shield — an add-on PCB that stacks directly onto the Arduino''s headers. The shield integrates a 0.96" OLED display, a DS3231 real-time clock module, an LM35 temperature sensor, and a 20×10 prototyping grid for additional circuits.|The schematic is captured in KiCad, respecting the Uno''s standard pinout. The PCB uses a single copper layer with all components on the top face, making it suitable for home etching or low-cost fab house production.|Learning outcomes include shield design constraints, header footprint assignment, keepout zones around Arduino USB and power connectors, and best practices for decoupling capacitors on I2C and SPI signal lines.',
  '[{"title":"Shield Schematic Capture","description":"Start in KiCad Schematic Editor. Import the Arduino Uno shield template (available on GitHub: arduino-kicad-library). Wire the OLED to I2C (SDA/SCL = A4/A5), the DS3231 RTC to the same I2C bus with a 4.7kΩ pull-up, and the LM35 to A0 with a 100nF bypass cap. Run ERC before proceeding.","note":null},{"title":"PCB Layout & Design Rules","description":"Set board outline to 68.58mm × 53.34mm (Uno footprint). Place all components within the shield area respecting Arduino connector keepout zones. Route power traces at 0.8mm, signal traces at 0.4mm. Add a silkscreen label for each header pin. Run DRC — zero errors required.","note":"💡 Place decoupling capacitors as close as possible to each IC VCC pin. Distance matters more than value for high-frequency noise."},{"title":"Fabricate the PCB","description":"Export Gerbers (F.Cu, Edge.Cuts, F.SilkS, F.Mask). Either send to JLCPCB/PCBWay for 5-day delivery, or etch in-lab using toner transfer on single-layer copper-clad board. Drill all holes at 1.0mm for through-hole headers.","note":null},{"title":"Solder Components","description":"Solder SMD bypass capacitors (0805 package) first using hot-air station or soldering iron. Then solder all through-hole headers. Finally solder the OLED display and RTC module to their pin headers. Inspect all joints.","note":"⚠ The OLED operates at 3.3V logic. If using a 5V Uno, add a 2-resistor voltage divider on SDA and SCL to prevent logic damage."},{"title":"Upload Test Sketch","description":"Flash the provided Arduino sketch that reads LM35 temperature, fetches time from DS3231, and displays both on the OLED. Verify correct I2C addresses (OLED: 0x3C, RTC: 0x68). Confirm display shows correct data and RTC holds time after power cycle.","note":null}]',
  '[{"name":"Arduino Uno R3","spec":"ATmega328P, 16 MHz, 5V logic","qty":"×1"},{"name":"0.96\\\" OLED Display","spec":"SSD1306, 128×64, I2C interface","qty":"×1"},{"name":"DS3231 RTC Module","spec":"±2ppm accuracy, I2C, coin cell backup","qty":"×1"},{"name":"LM35 Temperature Sensor","spec":"±0.5°C accuracy, 10mV/°C output","qty":"×1"},{"name":"PCB Single-layer","spec":"FR4, 1oz copper, toner-transfer etched","qty":"×1"},{"name":"Pin Headers","spec":"2.54mm pitch, male & female stackable","qty":"×1 set"},{"name":"100nF Bypass Capacitors","spec":"0805 SMD, X7R ceramic","qty":"×5"},{"name":"4.7kΩ Resistors","spec":"I2C pull-up, 0805 SMD","qty":"×2"}]',
  'Custom Arduino Shield — Full PCB Design Walkthrough', '28:45'
),
(
  'Op-Amp Audio Amplifier',
  'A dual-stage audio amplifier built around the NE5532 op-amp, delivering 500mW into 8Ω with tone control and input selection for use as a desktop speaker amplifier.',
  'NE5532 Dual Op-Amp ×2, 100kΩ Stereo Potentiometer ×3, 8Ω 1W Speaker, LM7812/LM7912 Dual Supply, PCB single-layer, Various resistors and capacitors',
  'Intermediate', 'Circuits', 2025, 'Analog Electronics · 2025',
  'This project builds a practical, listenable audio amplifier using the NE5532 — a low-noise, high-slew-rate op-amp favored in professional audio equipment. The design consists of two stages: a Baxandall tone control (bass/treble) followed by a non-inverting power amplifier stage with adjustable gain.|The amplifier operates from a ±12V split supply generated by LM7812 and LM7912 linear regulators from a 24V center-tapped transformer. Input switching selects between two sources (e.g. phone and PC). Output coupling is direct, relying on the split supply to eliminate DC at the speaker terminal.|All design decisions — component values, bias, slew rate requirements — are traced back to audio engineering principles covered in Electronics 1 & 2. The final board is built on a single-layer PCB and tested with a sweep generator and oscilloscope.',
  '[{"title":"Circuit Design & Gain Calculation","description":"Using the NE5532 datasheet, design a non-inverting amplifier with Av = 20 (26 dB). Calculate R_feedback and R_input. Design the Baxandall tone control network with ±12 dB boost/cut at 100 Hz (bass) and 10 kHz (treble). Simulate the full chain in Multisim and verify frequency response before building.","note":null},{"title":"PCB Layout","description":"Lay out the PCB in KiCad on a single copper layer. Separate the signal ground and power ground planes, joining at a single star point near the power supply. Keep signal traces away from power supply traces to minimize hum. Place a 100nF bypass cap on each op-amp VCC and VEE pin.","note":"💡 Use a ground plane even on single-layer boards by patterning copper fills around traces — it dramatically reduces interference."},{"title":"Power Supply Build","description":"Build the dual ±12V supply on a separate small PCB: 24V center-tapped transformer → bridge rectifier → 4700µF filter caps → LM7812 and LM7912. Verify both rails before connecting to the amplifier board.","note":"⚠ Verify polarity of electrolytic capacitors. Reversed caps on the rail will fail immediately and potentially explosively."},{"title":"Solder & Assemble","description":"Solder passive components first (resistors, capacitors, potentiometers). Then install op-amp DIP sockets — never solder ICs directly. Insert NE5532 chips only after verifying supply voltages. Wire the speaker via a 4700µF DC-blocking capacitor if you switched to single-supply operation.","note":null},{"title":"Audio Testing","description":"Connect a 1kHz sine wave at 100mV from a phone or function generator. Measure output voltage with oscilloscope — expect ~2V peak at Av=20. Sweep from 20Hz to 20kHz and check for clipping, oscillation, or unexpected roll-off. Finally listen with an 8Ω speaker and verify tone controls work.","note":null}]',
  '[{"name":"NE5532 Dual Op-Amp","spec":"Low noise, 13V/µs slew rate, DIP-8","qty":"×2"},{"name":"100kΩ Stereo Potentiometer","spec":"Log taper for volume/tone, 6mm shaft","qty":"×3"},{"name":"8Ω 1W Speaker","spec":"Full-range driver for testing","qty":"×1"},{"name":"LM7812 / LM7912","spec":"±12V linear regulators, TO-220","qty":"×1 each"},{"name":"4700µF Electrolytic Cap","spec":"25V, power supply filter","qty":"×2"},{"name":"100nF Bypass Caps","spec":"Ceramic, 25V, per op-amp","qty":"×8"},{"name":"PCB Single-layer","spec":"FR4, 1oz copper, 100×80mm","qty":"×1"},{"name":"24V Center-Tapped Transformer","spec":"500mA secondary current minimum","qty":"×1"}]',
  'Op-Amp Audio Amplifier — Design, Build & Test', '35:22'
),
(
  'Wireless Sensor Network',
  'An ESP32-mesh network of 6 sensor nodes reporting temperature, humidity, and air quality to a central MQTT broker dashboard.',
  'ESP32 (×6), DHT22, MQ-135 Air Quality Sensor, SSD1306 OLED, Li-Ion 18650 Battery, TP4056 Charger Module',
  'Advanced', 'IoT', 2026, 'IoT · 2026',
  NULL, NULL, NULL, NULL, NULL
),
(
  'Line-Following Robot',
  'An Arduino Mega-based differential-drive robot using IR sensor arrays and PID control for smooth line tracking at competitive speeds.',
  'Arduino Mega 2560, L298N Motor Driver, IR Sensor Array (8-channel), DC Gear Motors ×2, Li-Po 7.4V Battery, Chassis & wheels',
  'Intermediate', 'Robotics', 2025, 'Robotics · 2025',
  NULL, NULL, NULL, NULL, NULL
),
(
  'FPGA Digital Clock',
  'A Basys3 FPGA implementation of a 7-segment display clock with alarm, stopwatch, and lap timer modes written entirely in Verilog.',
  'Digilent Basys3 FPGA Board, Vivado Design Suite, 7-segment display (onboard), Push buttons (onboard), USB cable',
  'Advanced', 'Embedded', 2026, 'Embedded · 2026',
  NULL, NULL, NULL, NULL, NULL
),
(
  'Switched-Mode Power Supply',
  'A flyback SMPS design from schematic to PCB, producing 5V/2A and 12V/1A outputs from a 90-240V AC universal input.',
  'UC3842 PWM Controller, ETD39 Core Transformer, IRFP460 MOSFET, UF4007 Diodes, Opto-isolator PC817, Bulk capacitors',
  'Advanced', 'PCB Design', 2025, 'PCB Design · 2025',
  NULL, NULL, NULL, NULL, NULL
),
(
  '555 Timer Oscillator',
  'An exploration of the venerable 555 timer IC in astable and monostable modes, culminating in a precision square-wave generator with adjustable frequency and duty cycle.',
  'NE555 Timer IC, 100kΩ potentiometer, Various resistors and capacitors, LED indicators, Breadboard',
  'Beginner', 'Circuits', 2025, 'Circuits · 2025',
  NULL, NULL, NULL, NULL, NULL
),
(
  'Weather Station Node',
  'A solar-powered outdoor IoT node using ESP32 + BME280 to publish temperature, humidity, pressure, and UV index to a cloud dashboard every 5 minutes.',
  'ESP32-S2, BME280 Environmental Sensor, VEML6075 UV Sensor, 6V 2W Solar Panel, TP4056 + 18650 LiPo, Waterproof enclosure',
  'Intermediate', 'IoT', 2026, 'IoT · 2026',
  NULL, NULL, NULL, NULL, NULL
);


-- ── SIMULATION TOOLS ─────────────────────────────────────────────────────────
INSERT INTO `simulation_tools` (`tool_name`, `description`, `url_path`) VALUES
('MULTISIM',  'Industry-standard SPICE-based circuit simulation environment for analog & digital circuit analysis.', 'multisim_view.html'),
('TINKERCAD', 'Free browser-based tool from Autodesk for 3D modeling and Arduino circuit simulation.', 'tinkercad_view.html');