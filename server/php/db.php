<?php
// TEMP: mostrar errores para depuración (quítalo cuando funcione)
ini_set('display_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');

$host = 'sql206.infinityfree.com';
$db   = 'if0_40216426_contatienda';
$user = 'if0_40216426';
$pass = 'qepqyiXERz'; // <- reemplaza por tu contraseña real

$dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
$options = [
  PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
];

try {
  $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
  http_response_code(500);
  echo json_encode(['error' => 'DB connection failed']);
  exit;
}
?>