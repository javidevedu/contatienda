# Instrucciones para Configurar la Base de Datos

## Paso 1: Crear la Base de Datos en phpMyAdmin

1. Accede a phpMyAdmin desde tu panel de control de InfinityFree
2. Crea una nueva base de datos llamada: `if0_40216426_contatienda`
   - O usa el nombre que prefieras y actualiza `db.php` con ese nombre

## Paso 2: Ejecutar el Script SQL

1. Selecciona la base de datos que acabas de crear
2. Ve a la pestaña **SQL**
3. Copia y pega el contenido del archivo `Migrations/001_create_tables.sql`
4. Haz clic en **Ejecutar**

El script creará las siguientes tablas:
- `ventas` - Para almacenar las ventas
- `egresos` - Para almacenar los egresos
- `deudas` - Para almacenar las deudas

## Paso 3: Verificar la Conexión

1. Sube todos los archivos de la carpeta `Php/` a tu servidor
2. Accede desde el navegador a: `http://tu-dominio.com/Php/test_connection.php`
3. Deberías ver un mensaje de "✅ CONEXIÓN EXITOSA"

## Paso 4: Verificar Credenciales en db.php

Si cambias el nombre de la base de datos o las credenciales, actualiza el archivo `Php/db.php`:

```php
$host = 'sql206.infinityfree.com';
$db   = 'tu_nombre_base_datos';  // ← Cambia aquí
$user = 'tu_usuario';             // ← Cambia aquí
$pass = 'tu_contraseña';          // ← Cambia aquí
```

## Solución de Problemas

### Error: "DB connection failed"

**Posibles causas:**
1. La base de datos no existe
   - **Solución**: Crea la base de datos en phpMyAdmin

2. Las credenciales son incorrectas
   - **Solución**: Verifica usuario y contraseña en `db.php`

3. El usuario no tiene permisos
   - **Solución**: Asegúrate de que el usuario tenga todos los permisos en la base de datos

### Error: "Table doesn't exist"

**Solución**: Ejecuta el script SQL `001_create_tables.sql` en phpMyAdmin

### Error: "Access denied"

**Solución**: Verifica que el usuario tenga permisos para acceder a la base de datos desde el servidor

## Verificar que Todo Funciona

1. Abre la consola del navegador (F12)
2. Intenta crear una venta desde la aplicación
3. Si ves errores en la consola, revisa el mensaje de error específico
4. Si el servidor responde con un error JSON, revisa el archivo `test_connection.php` para más detalles

