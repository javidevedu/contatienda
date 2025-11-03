<?php
<?php
require_once 'db.php';
header('Content-Type: application/json; charset=utf-8');
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  $stmt = $pdo->query("SELECT * FROM deudas ORDER BY fecha ASC, id ASC");
  echo json_encode($stmt->fetchAll());
  exit;
}

if ($method === 'POST') {
  $data = json_decode(file_get_contents('php://input'), true);
  if (!$data) { http_response_code(400); echo json_encode(['error'=>'invalid json']); exit; }
  $stmt = $pdo->prepare("INSERT INTO deudas (comprador, monto, fecha, estado) VALUES (?, ?, ?, 'pendiente')");
  $stmt->execute([ $data['comprador'], $data['monto'], $data['fecha'] ]);
  echo json_encode(['id' => $pdo->lastInsertId()]);
  exit;
}

if ($method === 'PUT') {
  // Soporta: PUT /deudas.php?id=123&action=pagar
  $id = $_GET['id'] ?? null;
  $action = $_GET['action'] ?? null;
  if ($id && $action === 'pagar') {
    $stmt = $pdo->prepare("UPDATE deudas SET estado = 'pagado' WHERE id = ?");
    $stmt->execute([$id]);
    echo json_encode(['ok' => true]);
    exit;
  }
  http_response_code(400);
  echo json_encode(['error'=>'bad request']);
  exit;
}

if ($method === 'DELETE') {
  $id = $_GET['id'] ?? null;
  if (!$id) { http_response_code(400); echo json_encode(['error'=>'id required']); exit; }
  $stmt = $pdo->prepare("DELETE FROM deudas WHERE id = ?");
  $stmt->execute([$id]);
  http_response_code(204);
  exit;
}

http_response_code(405);
echo json_encode(['error'=>'method not allowed']);
?>