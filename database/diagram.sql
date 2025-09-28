-- =====================================================
-- CONTATIENDA - DIAGRAMA DE RELACIONES
-- Este archivo muestra las relaciones entre tablas
-- =====================================================

-- Diagrama de relaciones principales:

/*
USUARIOS (1) -----> (N) USUARIO_EMPRESAS (N) <----- (1) EMPRESAS
    |                                                      |
    |                                                      |
    |                                                      |
    v                                                      v
COMPROBANTES (1) -----> (N) MOVIMIENTOS_CONTABLES (N) <----- (1) PLAN_CUENTAS
    |                                                              |
    |                                                              |
    |                                                              |
    v                                                              v
FACTURAS (1) -----> (N) FACTURA_DETALLES (N) <----- (1) PRODUCTOS
    |                                                      |
    |                                                      |
    |                                                      |
    v                                                      v
PAGOS (N) <----- (1) CLIENTES                    PROVEEDORES
    |                                                      |
    |                                                      |
    |                                                      |
    v                                                      v
CONFIGURACION_SISTEMA (1) <----- (1) EMPRESAS -----> (1) CONFIGURACION_SISTEMA
*/

-- Consultas para visualizar las relaciones:

-- 1. Usuarios y sus empresas
SELECT 
    u.nombres + ' ' + u.apellidos as usuario,
    e.nombre as empresa,
    ue.rol
FROM usuarios u
JOIN usuario_empresas ue ON u.id = ue.usuario_id
JOIN empresas e ON ue.empresa_id = e.id;

-- 2. Estructura del plan de cuentas
SELECT 
    pc.codigo,
    pc.nombre,
    pc.tipo,
    pc.naturaleza,
    pc.nivel,
    CASE 
        WHEN pc.cuenta_padre_id IS NULL THEN 'Cuenta Principal'
        ELSE 'Subcuenta'
    END as tipo_cuenta
FROM plan_cuentas pc
ORDER BY pc.codigo;

-- 3. Comprobantes y sus movimientos
SELECT 
    c.numero_comprobante,
    c.fecha_comprobante,
    c.concepto,
    pc.codigo as cuenta_codigo,
    pc.nombre as cuenta_nombre,
    mc.debe,
    mc.haber
FROM comprobantes c
JOIN movimientos_contables mc ON c.id = mc.comprobante_id
JOIN plan_cuentas pc ON mc.cuenta_id = pc.id
ORDER BY c.numero_comprobante, mc.orden;

-- 4. Facturas y sus detalles
SELECT 
    f.numero_factura,
    f.fecha_factura,
    c.nombres + ' ' + c.apellidos as cliente,
    p.nombre as producto,
    fd.cantidad,
    fd.precio_unitario,
    fd.subtotal
FROM facturas f
JOIN clientes c ON f.cliente_id = c.id
JOIN factura_detalles fd ON f.id = fd.factura_id
JOIN productos p ON fd.producto_id = p.id
ORDER BY f.numero_factura;

-- 5. Resumen de ventas por empresa
SELECT 
    e.nombre as empresa,
    COUNT(f.id) as total_facturas,
    SUM(f.total) as total_ventas,
    AVG(f.total) as promedio_venta
FROM empresas e
LEFT JOIN facturas f ON e.id = f.empresa_id
GROUP BY e.id, e.nombre;

-- 6. Balance de prueba (simplificado)
SELECT 
    pc.tipo,
    pc.codigo,
    pc.nombre,
    COALESCE(SUM(mc.debe), 0) as total_debe,
    COALESCE(SUM(mc.haber), 0) as total_haber,
    COALESCE(SUM(mc.debe), 0) - COALESCE(SUM(mc.haber), 0) as saldo
FROM plan_cuentas pc
LEFT JOIN movimientos_contables mc ON pc.id = mc.cuenta_id
LEFT JOIN comprobantes c ON mc.comprobante_id = c.id AND c.estado = 'contabilizado'
GROUP BY pc.id, pc.tipo, pc.codigo, pc.nombre
HAVING COALESCE(SUM(mc.debe), 0) > 0 OR COALESCE(SUM(mc.haber), 0) > 0
ORDER BY pc.tipo, pc.codigo;
