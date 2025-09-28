-- =====================================================
-- CONTATIENDA - SCRIPT DE INSTALACIÓN COMPLETA
-- Ejecutar este archivo para instalar la base de datos
-- =====================================================

-- Crear usuario específico para la aplicación (opcional)
-- CREATE USER 'contatienda_user'@'localhost' IDENTIFIED BY 'contatienda_password';
-- GRANT ALL PRIVILEGES ON contatienda.* TO 'contatienda_user'@'localhost';
-- FLUSH PRIVILEGES;

-- Ejecutar el esquema principal
SOURCE schema.sql;

-- Ejecutar los datos de ejemplo
SOURCE sample_data.sql;

-- Verificar la instalación
SELECT 'Instalación completada exitosamente' as status;
SELECT COUNT(*) as total_usuarios FROM usuarios;
SELECT COUNT(*) as total_empresas FROM empresas;
SELECT COUNT(*) as total_cuentas FROM plan_cuentas;
SELECT COUNT(*) as total_clientes FROM clientes;
SELECT COUNT(*) as total_productos FROM productos;
SELECT COUNT(*) as total_facturas FROM facturas;
