# ContaTienda

Aplicación web simple para la gestión contable de una tienda de barrio.

## Cómo ejecutar

- Abre esta carpeta en tu editor y usa Live Server, o simplemente abre `index.html` en tu navegador.
- No requiere instalaciones ni dependencias externas.

## Credenciales de prueba (en memoria)

- Usuario: `u123` / Contraseña: `123`
- Usuario: `u1234` / Contraseña: `1234`
- Usuario: `admin` / Contraseña: `admin`

## Módulos

- Registro de Ventas (monto, fecha, notas) con eliminación
- Registro de Egresos (monto, fecha, descripción) con eliminación
- Gestión de Deudas (comprador, monto, fecha, estado) con eliminación
- Dashboard con totales y gráfico mensual (sin librerías externas)

Los datos se guardan en tiempo real en `localStorage` del navegador para esta versión sin backend.

## Backend opcional (PHP + MySQL)

Incluimos archivos PHP y una migración SQL para usar en un hosting con MySQL. Esta app funciona sin backend, pero si quieres persistir en servidor:

1) Crea la base con `Migrations/001_create_tables.sql`.
2) Sube la carpeta `Php/` al hosting (ajusta rutas si es necesario).
3) Asegura que `Php/db.php` contiene tus credenciales de MySQL.

Conexión de ejemplo (InfinityFree):

- host: `sql206.infinityfree.com`
- db: `if0_40216426_contatienda`
- user: `if0_40216426`
- pass: `qepqyiXERz`

> Nota: El frontend no llama al backend por defecto para evitar restricciones al abrir `index.html` directamente. Si vas a integrar, realiza `fetch` hacia los endpoints en `Php/` y maneja CORS y rutas HTTPS.

## Compatibilidad

- Chrome 90+, Safari 14+

## Licencia

MIT


