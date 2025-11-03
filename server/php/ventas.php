<?php
require_once 'db.php';
header('Content-Type: application/json; charset=utf-8');
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  $stmt = $pdo->query("SELECT * FROM ventas ORDER BY fecha ASC, id ASC");
  echo json_encode($stmt->fetchAll());
  exit;
}

if ($method === 'POST') {
  $data = json_decode(file_get_contents('php://input'), true);
  if (!$data) { http_response_code(400); echo json_encode(['error'=>'invalid json']); exit; }
  $stmt = $pdo->prepare("INSERT INTO ventas (monto, fecha, notas) VALUES (?, ?, ?)");
  $stmt->execute([ $data['monto'], $data['fecha'], $data['notas'] ?? null ]);
  echo json_encode(['id' => $pdo->lastInsertId()]);
  exit;
}

if ($method === 'DELETE') {
  $id = $_GET['id'] ?? null;
  if (!$id) { http_response_code(400); echo json_encode(['error'=>'id required']); exit; }
  $stmt = $pdo->prepare("DELETE FROM ventas WHERE id = ?");
  $stmt->execute([$id]);
  http_response_code(204);
  exit;
}

http_response_code(405);
echo json_encode(['error'=>'method not allowed']);
?>