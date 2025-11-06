<?php
require_once __DIR__ . '/db.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  $res = $mysqli->query("SELECT id, monto, fecha, descripcion, created_at FROM egresos ORDER BY id DESC");
  if (!$res) {
    json_err('Error al consultar: ' . $mysqli->error, 500);
    exit;
  }
  $rows = [];
  while ($row = $res->fetch_assoc()) { $rows[] = $row; }
  json_ok($rows);
  exit;
}

if ($method === 'POST') {
  $payload = json_decode(file_get_contents('php://input'), true);
  if (!$payload) { $payload = $_POST; }
  if (isset($payload['_method']) && $payload['_method'] === 'DELETE') {
    if (isset($payload['id'])) { $_GET['id'] = $payload['id']; }
    $method = 'DELETE';
  } else {
    $monto = isset($payload['monto']) ? floatval($payload['monto']) : null;
    $fecha = isset($payload['fecha']) ? $payload['fecha'] : null;
    $descripcion = isset($payload['descripcion']) ? $payload['descripcion'] : null;
    if (!$monto || !$fecha || !$descripcion) { json_err('Campos requeridos'); exit; }
    $stmt = $mysqli->prepare("INSERT INTO egresos (monto, fecha, descripcion) VALUES (?,?,?)");
    if (!$stmt) {
      json_err('Error al preparar consulta: ' . $mysqli->error, 500);
      exit;
    }
    $stmt->bind_param('dss', $monto, $fecha, $descripcion);
    if(!$stmt->execute()){
      json_err('No se pudo insertar: ' . $stmt->error, 500);
      $stmt->close();
      exit;
    }
    json_ok([ 'id' => $stmt->insert_id ]);
    $stmt->close();
    exit;
  }
}

if ($method === 'DELETE') {
  $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
  if ($id <= 0) { json_err('id requerido'); exit; }
  $stmt = $mysqli->prepare("DELETE FROM egresos WHERE id = ?");
  if (!$stmt) {
    json_err('Error al preparar consulta: ' . $mysqli->error, 500);
    exit;
  }
  $stmt->bind_param('i', $id);
  if(!$stmt->execute()){
    json_err('No se pudo eliminar: ' . $stmt->error, 500);
    $stmt->close();
    exit;
  }
  json_ok([ 'ok' => true, 'deleted' => $stmt->affected_rows ]);
  $stmt->close();
  exit;
}

json_err('Método no soportado', 405);


