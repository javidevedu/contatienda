<?php
require_once __DIR__ . '/db.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  $res = $mysqli->query("SELECT id, comprador, monto, fecha, estado, created_at FROM deudas ORDER BY id DESC");
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
  $comprador = isset($payload['comprador']) ? $payload['comprador'] : null;
  $monto = isset($payload['monto']) ? floatval($payload['monto']) : null;
  $fecha = isset($payload['fecha']) ? $payload['fecha'] : null;
  $estado = isset($payload['estado']) && $payload['estado'] === 'pagado' ? 'pagado' : 'pendiente';
  if (!$comprador || !$monto || !$fecha) { json_err('Campos requeridos'); exit; }
  $stmt = $mysqli->prepare("INSERT INTO deudas (comprador, monto, fecha, estado) VALUES (?,?,?,?)");
  if (!$stmt) {
    json_err('Error al preparar consulta: ' . $mysqli->error, 500);
    exit;
  }
  $stmt->bind_param('sdss', $comprador, $monto, $fecha, $estado);
  if(!$stmt->execute()){
    json_err('No se pudo insertar: ' . $stmt->error, 500);
    $stmt->close();
    exit;
  }
  json_ok([ 'id' => $stmt->insert_id ]);
  $stmt->close();
  exit;
}

if ($method === 'DELETE') {
  $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
  if ($id <= 0) { json_err('id requerido'); exit; }
  $stmt = $mysqli->prepare("DELETE FROM deudas WHERE id = ?");
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


