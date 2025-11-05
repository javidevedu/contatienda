<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

// Configuración de conexión a la base de datos
$host = 'sql206.infinityfree.com';
$db   = 'if0_40216426_contatienda';
$user = 'if0_40216426';
$pass = 'qepqyiXERz';
$port = 3306; // Puerto por defecto de MySQL

// Intentar conexión con manejo de errores mejorado
$mysqli = @new mysqli($host, $user, $pass, $db, $port);

if ($mysqli->connect_errno) {
  http_response_code(500);
  $errorMsg = [
    'error' => 'DB connection failed',
    'detail' => $mysqli->connect_error,
    'errno' => $mysqli->connect_errno,
    'host' => $host,
    'db' => $db,
    'suggestion' => 'Verifica que la base de datos exista y las credenciales sean correctas'
  ];
  echo json_encode($errorMsg, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
  exit;
}

// Configurar charset
if (!$mysqli->set_charset('utf8mb4')) {
  http_response_code(500);
  echo json_encode([ 'error' => 'Failed to set charset', 'detail' => $mysqli->error ]);
  exit;
}

// Funciones helper
function json_ok($data){ 
  echo json_encode($data, JSON_UNESCAPED_UNICODE); 
}

function json_err($msg, $code=400){ 
  http_response_code($code); 
  echo json_encode([ 'error' => $msg ], JSON_UNESCAPED_UNICODE); 
}


