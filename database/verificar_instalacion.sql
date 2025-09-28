-- =====================================================
-- CONTATIENDA - VERIFICACION DE INSTALACION
-- Ejecutar este archivo para verificar que todo esté correcto
-- =====================================================

USE contatienda;

-- Verificar que todas las tablas existen
SELECT 'TABLAS CREADAS:' as verificacion;
SHOW TABLES;

-- Verificar usuarios
SELECT 'USUARIOS CREADOS:' as verificacion;
SELECT id, nombres, apellidos, username, rol, estado FROM usuarios;

-- Verificar empresas
SELECT 'EMPRESAS CREADAS:' as verificacion;
SELECT id, nombre, nit, regimen, estado FROM empresas;

-- Verificar plan de cuentas
SELECT 'PLAN DE CUENTAS:' as verificacion;
SELECT COUNT(*) as total_cuentas FROM plan_cuentas;

-- Verificar clientes
SELECT 'CLIENTES CREADOS:' as verificacion;
SELECT COUNT(*) as total_clientes FROM clientes;

-- Verificar productos
SELECT 'PRODUCTOS CREADOS:' as verificacion;
SELECT COUNT(*) as total_productos FROM productos;

-- Verificar facturas
SELECT 'FACTURAS CREADAS:' as verificacion;
SELECT COUNT(*) as total_facturas FROM facturas;

-- Verificar comprobantes
SELECT 'COMPROBANTES CREADOS:' as verificacion;
SELECT COUNT(*) as total_comprobantes FROM comprobantes;

-- Verificar movimientos contables
SELECT 'MOVIMIENTOS CONTABLES:' as verificacion;
SELECT COUNT(*) as total_movimientos FROM movimientos_contables;

-- Verificar configuración
SELECT 'CONFIGURACION DEL SISTEMA:' as verificacion;
SELECT COUNT(*) as total_configuraciones FROM configuracion_sistema;

-- Resumen de la instalación
SELECT 'RESUMEN DE INSTALACION:' as verificacion;
SELECT 
    (SELECT COUNT(*) FROM usuarios) as usuarios,
    (SELECT COUNT(*) FROM empresas) as empresas,
    (SELECT COUNT(*) FROM plan_cuentas) as cuentas_contables,
    (SELECT COUNT(*) FROM clientes) as clientes,
    (SELECT COUNT(*) FROM proveedores) as proveedores,
    (SELECT COUNT(*) FROM productos) as productos,
    (SELECT COUNT(*) FROM facturas) as facturas,
    (SELECT COUNT(*) FROM comprobantes) as comprobantes,
    (SELECT COUNT(*) FROM movimientos_contables) as movimientos;

-- Verificar integridad de datos
SELECT 'VERIFICACION DE INTEGRIDAD:' as verificacion;

-- Verificar que los totales de comprobantes coinciden
SELECT 
    c.numero_comprobante,
    c.total_debe,
    c.total_haber,
    COALESCE(SUM(mc.debe), 0) as debe_calculado,
    COALESCE(SUM(mc.haber), 0) as haber_calculado,
    CASE 
        WHEN c.total_debe = COALESCE(SUM(mc.debe), 0) 
         AND c.total_haber = COALESCE(SUM(mc.haber), 0) 
        THEN 'OK' 
        ELSE 'ERROR' 
    END as estado
FROM comprobantes c
LEFT JOIN movimientos_contables mc ON c.id = mc.comprobante_id
GROUP BY c.id, c.numero_comprobante, c.total_debe, c.total_haber;

-- Verificar que las facturas tienen detalles
SELECT 
    f.numero_factura,
    f.total,
    COALESCE(SUM(fd.subtotal), 0) as subtotal_calculado,
    CASE 
        WHEN f.subtotal = COALESCE(SUM(fd.subtotal), 0) 
        THEN 'OK' 
        ELSE 'ERROR' 
    END as estado
FROM facturas f
LEFT JOIN factura_detalles fd ON f.id = fd.factura_id
GROUP BY f.id, f.numero_factura, f.total, f.subtotal;

SELECT 'VERIFICACION COMPLETADA' as resultado;
