<?php
require_once __DIR__ . '/db.php';

// Simple router via method + params
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  // list all
  $res = $mysqli->query("SELECT id, monto, fecha, notas, created_at FROM ventas ORDER BY id DESC");
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
    $notas = isset($payload['notas']) ? $payload['notas'] : null;
    if (!$monto || !$fecha) { json_err('Campos requeridos'); exit; }
    $stmt = $mysqli->prepare("INSERT INTO ventas (monto, fecha, notas) VALUES (?,?,?)");
    if (!$stmt) {
      json_err('Error al preparar consulta: ' . $mysqli->error, 500);
      exit;
    }
    $stmt->bind_param('dss', $monto, $fecha, $notas);
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

// DELETE real o emulado via POST _method=DELETE (JSON o form)
if ($method === 'DELETE') {
  // Obtener id desde query, JSON o form
  $id = 0;
  if (isset($_GET['id'])) { $id = intval($_GET['id']); }
  // id puede venir de $_GET (o fue inyectado desde POST emulado)
  if ($id <= 0 && isset($_POST['id'])) { $id = intval($_POST['id']); }
  if ($id <= 0) { json_err('id requerido'); exit; }

  $stmt = $mysqli->prepare("DELETE FROM ventas WHERE id = ?");
  if (!$stmt) { json_err('Error al preparar consulta: ' . $mysqli->error, 500); exit; }
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


