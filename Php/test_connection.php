<?php
/**
 * Archivo de prueba de conexión a la base de datos
 * Accede a: http://tu-dominio.com/Php/test_connection.php
 */

header('Content-Type: text/html; charset=utf-8');

// Configuración de conexión
$host = 'sql206.infinityfree.com';
$db   = 'if0_40216426_contatienda';
$user = 'if0_40216426';
$pass = 'qepqyiXERz';
$port = 3306;

echo "<h2>Prueba de Conexión a Base de Datos</h2>";
echo "<pre>";

// Intentar conexión
echo "1. Intentando conectar a: $host:$port\n";
echo "   Base de datos: $db\n";
echo "   Usuario: $user\n\n";

$mysqli = @new mysqli($host, $user, $pass, $db, $port);

if ($mysqli->connect_errno) {
    echo "❌ <strong>ERROR DE CONEXIÓN</strong>\n";
    echo "   Código de error: " . $mysqli->connect_errno . "\n";
    echo "   Mensaje: " . $mysqli->connect_error . "\n\n";
    
    echo "<h3>Posibles causas:</h3>\n";
    echo "   - La base de datos no existe\n";
    echo "   - Las credenciales son incorrectas\n";
    echo "   - El servidor no permite conexiones remotas\n";
    echo "   - El puerto está bloqueado\n\n";
    
    echo "<h3>Soluciones:</h3>\n";
    echo "   1. Verifica que la base de datos '$db' exista en phpMyAdmin\n";
    echo "   2. Verifica que el usuario '$user' tenga permisos\n";
    echo "   3. Ejecuta el script SQL en phpMyAdmin para crear las tablas\n";
    exit;
}

echo "✅ <strong>CONEXIÓN EXITOSA</strong>\n\n";

// Verificar charset
if ($mysqli->set_charset('utf8mb4')) {
    echo "✅ Charset configurado: utf8mb4\n";
} else {
    echo "⚠️  No se pudo configurar charset: " . $mysqli->error . "\n";
}

// Verificar si las tablas existen
echo "\n2. Verificando tablas...\n\n";

$tables = ['ventas', 'egresos', 'deudas'];
$allTablesExist = true;

foreach ($tables as $table) {
    $result = $mysqli->query("SHOW TABLES LIKE '$table'");
    if ($result && $result->num_rows > 0) {
        echo "✅ Tabla '$table' existe\n";
        
        // Contar registros
        $count = $mysqli->query("SELECT COUNT(*) as total FROM $table");
        if ($count) {
            $row = $count->fetch_assoc();
            echo "   Registros: " . $row['total'] . "\n";
        }
    } else {
        echo "❌ Tabla '$table' NO existe\n";
        $allTablesExist = false;
    }
}

if (!$allTablesExist) {
    echo "\n⚠️  <strong>FALTAN TABLAS</strong>\n";
    echo "   Ejecuta el script SQL '001_create_tables.sql' en phpMyAdmin\n";
}

// Prueba de inserción (solo si las tablas existen)
if ($allTablesExist) {
    echo "\n3. Prueba de inserción en 'ventas'...\n";
    $stmt = $mysqli->prepare("INSERT INTO ventas (monto, fecha, notas) VALUES (?, ?, ?)");
    if ($stmt) {
        $testMonto = 1000.00;
        $testFecha = date('Y-m-d');
        $testNotas = 'Prueba de conexión';
        $stmt->bind_param('dss', $testMonto, $testFecha, $testNotas);
        
        if ($stmt->execute()) {
            $testId = $stmt->insert_id;
            echo "✅ Registro insertado correctamente (ID: $testId)\n";
            
            // Eliminar el registro de prueba
            $mysqli->query("DELETE FROM ventas WHERE id = $testId");
            echo "✅ Registro de prueba eliminado\n";
        } else {
            echo "❌ Error al insertar: " . $stmt->error . "\n";
        }
        $stmt->close();
    } else {
        echo "❌ Error al preparar consulta: " . $mysqli->error . "\n";
    }
}

echo "\n✅ <strong>PRUEBA COMPLETA</strong>\n";
echo "</pre>";

$mysqli->close();
?>

