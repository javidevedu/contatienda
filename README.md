# ContaTienda - Gestión Contable para Tiendas de Barrio

ContaTienda es una aplicación web simple para la gestión contable de tiendas de barrio. Permite registrar ventas, egresos y deudas, además de proporcionar un dashboard con resúmenes de la información contable.

## Características

- Autenticación de usuarios con credenciales predefinidas
- Registro de ventas con monto, fecha y notas
- Registro de egresos con monto, fecha y descripción
- Gestión de deudas con comprador, monto, fecha y estado (pagado/pendiente)
- Dashboard con resumen de totales y últimas transacciones

## Requisitos

- Navegador web moderno (Chrome 90+ o Safari 14+)
- No requiere instalación de software adicional

## Instrucciones de uso

1. Abrir el archivo `index.html` con Live Server o directamente en el navegador
2. Iniciar sesión con alguna de las siguientes credenciales:
   - Usuario: `admin1` / Contraseña: `password1`
   - Usuario: `admin2` / Contraseña: `password2`
3. Navegar por los diferentes módulos usando el menú lateral

## Notas importantes

- La aplicación almacena todos los datos en memoria, por lo que se perderán al recargar la página
- No se requiere conexión a internet ni servidor para su funcionamiento
- Desarrollada con HTML, CSS y JavaScript puro, sin dependencias externas

## Estructura de archivos

- `index.html`: Estructura de la aplicación y formularios
- `styles.css`: Estilos de la interfaz de usuario
- `app.js`: Lógica de la aplicación y gestión de datos en memoria