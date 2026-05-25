<?php
/**
 * db_connect.php — BICpES Learning Hub
 * Database connection for XAMPP localhost.
 */

define('DB_HOST',    'localhost');
define('DB_USER',    'root');   // XAMPP default — change if you set a custom MySQL user
define('DB_PASS',    '');       // XAMPP default MySQL root has NO password
define('DB_NAME',    'bicpes_hub');
define('DB_CHARSET', 'utf8mb4');

function get_db(): mysqli
{
    static $conn = null;
    if ($conn !== null) return $conn;

    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    try {
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $conn->set_charset(DB_CHARSET);
    } catch (mysqli_sql_exception $e) {
        error_log('[BICpES DB] Connection failed: ' . $e->getMessage());
        throw new RuntimeException('Database connection failed. Please try again later.');
    }
    return $conn;
}