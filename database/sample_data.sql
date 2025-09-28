-- =====================================================
-- CONTATIENDA - DATOS DE EJEMPLO
-- Datos de prueba para el sistema contable
-- =====================================================

USE contatienda;

-- =====================================================
-- USUARIOS DE PRUEBA
-- =====================================================
INSERT INTO usuarios (nombres, apellidos, cedula, fecha_nacimiento, email, username, password_hash, telefono, direccion, rol, estado) VALUES
('Administrador', 'Sistema', '12345678', '1985-01-15', 'admin@contatienda.com', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '3001234567', 'Calle 123 #45-67', 'admin', 'activo'),
('María', 'González', '87654321', '1990-05-20', 'maria.gonzalez@email.com', 'maria.gonzalez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '3007654321', 'Carrera 45 #78-90', 'contador', 'activo'),
('Carlos', 'Rodríguez', '11223344', '1988-12-10', 'carlos.rodriguez@email.com', 'carlos.rodriguez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '3009876543', 'Avenida 80 #12-34', 'usuario', 'activo'),
('Ana', 'Martínez', '55667788', '1992-08-03', 'ana.martinez@email.com', 'ana.martinez', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '3004567890', 'Calle 100 #56-78', 'usuario', 'activo');

-- =====================================================
-- EMPRESAS DE PRUEBA
-- =====================================================
INSERT INTO empresas (nombre, nit, direccion, telefono, email, representante_legal, cedula_representante, regimen, actividad_economica, fecha_constitucion, estado) VALUES
('Tienda El Éxito S.A.S', '900123456-7', 'Carrera 7 #32-16, Bogotá', '6012345678', 'contacto@tienelaxito.com', 'María González', '87654321', 'simplificado', 'Comercio al por menor de productos diversos', '2020-01-15', 'activa'),
('Distribuidora ABC Ltda', '800987654-3', 'Calle 80 #45-23, Medellín', '6045678901', 'info@distribuidoraabc.com', 'Carlos Rodríguez', '11223344', 'comun', 'Distribución de productos alimenticios', '2019-06-10', 'activa'),
('Servicios Contables Pro', '700555666-1', 'Avenida 68 #12-45, Cali', '6023456789', 'servicios@contablespro.com', 'Ana Martínez', '55667788', 'simplificado', 'Servicios de contabilidad y asesoría', '2021-03-20', 'activa');

-- =====================================================
-- ASIGNACIÓN USUARIOS-EMPRESAS
-- =====================================================
INSERT INTO usuario_empresas (usuario_id, empresa_id, rol) VALUES
(1, 1, 'propietario'),  -- Admin es propietario de Tienda El Éxito
(2, 1, 'contador'),     -- María es contadora de Tienda El Éxito
(2, 2, 'contador'),     -- María también es contadora de Distribuidora ABC
(3, 2, 'propietario'),  -- Carlos es propietario de Distribuidora ABC
(4, 3, 'propietario'),  -- Ana es propietaria de Servicios Contables Pro
(1, 3, 'empleado');     -- Admin también tiene acceso a Servicios Contables Pro

-- =====================================================
-- PLAN DE CUENTAS PARA TIENDA EL ÉXITO
-- =====================================================
INSERT INTO plan_cuentas (empresa_id, codigo, nombre, tipo, naturaleza, nivel, es_cuenta_movimiento, estado) VALUES
-- ACTIVOS
(1, '1', 'ACTIVOS', 'activo', 'deudor', 1, FALSE, 'activa'),
(1, '11', 'ACTIVO CORRIENTE', 'activo', 'deudor', 2, FALSE, 'activa'),
(1, '1105', 'CAJA', 'activo', 'deudor', 3, TRUE, 'activa'),
(1, '1110', 'BANCOS', 'activo', 'deudor', 3, TRUE, 'activa'),
(1, '1305', 'CLIENTES', 'activo', 'deudor', 3, TRUE, 'activa'),
(1, '1435', 'INVENTARIOS', 'activo', 'deudor', 3, TRUE, 'activa'),
(1, '15', 'ACTIVO NO CORRIENTE', 'activo', 'deudor', 2, FALSE, 'activa'),
(1, '1516', 'MAQUINARIA Y EQUIPO', 'activo', 'deudor', 3, TRUE, 'activa'),
(1, '1524', 'EQUIPO DE COMPUTACIÓN', 'activo', 'deudor', 3, TRUE, 'activa'),

-- PASIVOS
(1, '2', 'PASIVOS', 'pasivo', 'acreedor', 1, FALSE, 'activa'),
(1, '21', 'PASIVO CORRIENTE', 'pasivo', 'acreedor', 2, FALSE, 'activa'),
(1, '2205', 'PROVEEDORES NACIONALES', 'pasivo', 'acreedor', 3, TRUE, 'activa'),
(1, '2335', 'IVA PAGADO EN COMPRAS', 'pasivo', 'acreedor', 3, TRUE, 'activa'),
(1, '25', 'PASIVO NO CORRIENTE', 'pasivo', 'acreedor', 2, FALSE, 'activa'),

-- PATRIMONIO
(1, '3', 'PATRIMONIO', 'patrimonio', 'acreedor', 1, FALSE, 'activa'),
(1, '31', 'CAPITAL', 'patrimonio', 'acreedor', 2, FALSE, 'activa'),
(1, '3115', 'CAPITAL SOCIAL', 'patrimonio', 'acreedor', 3, TRUE, 'activa'),
(1, '33', 'RESERVAS', 'patrimonio', 'acreedor', 2, FALSE, 'activa'),
(1, '36', 'SUPERÁVIT', 'patrimonio', 'acreedor', 2, FALSE, 'activa'),
(1, '3605', 'UTILIDADES DEL EJERCICIO', 'patrimonio', 'acreedor', 3, TRUE, 'activa'),

-- INGRESOS
(1, '4', 'INGRESOS', 'ingreso', 'acreedor', 1, FALSE, 'activa'),
(1, '41', 'INGRESOS OPERACIONALES', 'ingreso', 'acreedor', 2, FALSE, 'activa'),
(1, '4135', 'VENTAS', 'ingreso', 'acreedor', 3, TRUE, 'activa'),
(1, '4175', 'DEVOLUCIONES EN VENTAS', 'ingreso', 'acreedor', 3, TRUE, 'activa'),
(1, '4210', 'FINANCIEROS', 'ingreso', 'acreedor', 2, FALSE, 'activa'),
(1, '421005', 'INTERESES', 'ingreso', 'acreedor', 3, TRUE, 'activa'),

-- GASTOS
(1, '5', 'GASTOS', 'gasto', 'deudor', 1, FALSE, 'activa'),
(1, '51', 'GASTOS OPERACIONALES', 'gasto', 'deudor', 2, FALSE, 'activa'),
(1, '5105', 'GASTOS DE PERSONAL', 'gasto', 'deudor', 3, TRUE, 'activa'),
(1, '5205', 'GASTOS GENERALES', 'gasto', 'deudor', 3, TRUE, 'activa'),
(1, '5305', 'GASTOS DE VENTAS', 'gasto', 'deudor', 3, TRUE, 'activa'),
(1, '5405', 'GASTOS FINANCIEROS', 'gasto', 'deudor', 3, TRUE, 'activa'),

-- COSTOS
(1, '6', 'COSTOS', 'costo', 'deudor', 1, FALSE, 'activa'),
(1, '61', 'COSTOS DE VENTAS', 'costo', 'deudor', 2, FALSE, 'activa'),
(1, '6105', 'COSTO DE VENTAS', 'costo', 'deudor', 3, TRUE, 'activa');

-- =====================================================
-- CLIENTES DE PRUEBA
-- =====================================================
INSERT INTO clientes (empresa_id, tipo_documento, numero_documento, nombres, apellidos, razon_social, direccion, telefono, email, fecha_nacimiento, estado) VALUES
(1, 'cedula', '12345678', 'Juan', 'Pérez', NULL, 'Calle 50 #25-30', '3001111111', 'juan.perez@email.com', '1985-03-15', 'activo'),
(1, 'cedula', '87654321', 'María', 'López', NULL, 'Carrera 15 #40-20', '3002222222', 'maria.lopez@email.com', '1990-07-22', 'activo'),
(1, 'nit', '900111222-3', NULL, NULL, 'Empresa ABC S.A.S', 'Avenida 68 #12-45', '6012345678', 'contacto@empresaabc.com', NULL, 'activo'),
(1, 'cedula', '11223344', 'Carlos', 'García', NULL, 'Calle 100 #15-40', '3003333333', 'carlos.garcia@email.com', '1988-11-10', 'activo'),
(1, 'nit', '800444555-6', NULL, NULL, 'Distribuidora XYZ Ltda', 'Carrera 7 #25-10', '6019876543', 'ventas@distribuidoraxyz.com', NULL, 'activo');

-- =====================================================
-- PROVEEDORES DE PRUEBA
-- =====================================================
INSERT INTO proveedores (empresa_id, tipo_documento, numero_documento, nombres, apellidos, razon_social, direccion, telefono, email, estado) VALUES
(1, 'nit', '900777888-9', NULL, NULL, 'Proveedor Mayorista S.A.S', 'Carrera 30 #45-67', '6015556666', 'ventas@proveedormayorista.com', 'activo'),
(1, 'nit', '800999000-1', NULL, NULL, 'Distribuidora Nacional Ltda', 'Avenida 80 #23-45', '6017778888', 'contacto@distribuidoranacional.com', 'activo'),
(1, 'cedula', '99887766', 'Roberto', 'Silva', 'Roberto Silva - Comerciante', 'Calle 25 #12-34', '3004445555', 'roberto.silva@email.com', 'activo'),
(1, 'nit', '700333444-5', NULL, NULL, 'Servicios Generales S.A.S', 'Carrera 50 #78-90', '6016667777', 'servicios@serviciosgenerales.com', 'activo');

-- =====================================================
-- PRODUCTOS DE PRUEBA
-- =====================================================
INSERT INTO productos (empresa_id, codigo, nombre, descripcion, tipo, precio_venta, costo, unidad_medida, stock_minimo, stock_actual, estado) VALUES
(1, 'PROD001', 'Laptop HP Pavilion', 'Laptop HP Pavilion 15 pulgadas, 8GB RAM, 256GB SSD', 'producto', 2500000.00, 2000000.00, 'unidad', 5, 15, 'activo'),
(1, 'PROD002', 'Mouse Inalámbrico', 'Mouse inalámbrico con receptor USB', 'producto', 45000.00, 30000.00, 'unidad', 20, 50, 'activo'),
(1, 'PROD003', 'Teclado Mecánico', 'Teclado mecánico RGB con switches azules', 'producto', 180000.00, 120000.00, 'unidad', 10, 25, 'activo'),
(1, 'PROD004', 'Monitor 24 pulgadas', 'Monitor LED 24 pulgadas Full HD', 'producto', 800000.00, 600000.00, 'unidad', 8, 12, 'activo'),
(1, 'PROD005', 'Servicio Técnico', 'Servicio de reparación y mantenimiento de equipos', 'servicio', 50000.00, 0.00, 'hora', 0, 0, 'activo'),
(1, 'PROD006', 'Instalación de Software', 'Instalación y configuración de software', 'servicio', 80000.00, 0.00, 'servicio', 0, 0, 'activo');

-- =====================================================
-- COMPROBANTES DE PRUEBA
-- =====================================================
INSERT INTO comprobantes (empresa_id, numero_comprobante, tipo_comprobante, fecha_comprobante, concepto, total_debe, total_haber, estado, usuario_creacion, fecha_aprobacion, usuario_aprobacion) VALUES
(1, 'COMP-001', 'apertura', '2024-01-01', 'Apertura del ejercicio contable 2024', 50000000.00, 50000000.00, 'contabilizado', 1, '2024-01-01 10:00:00', 1),
(1, 'COMP-002', 'diario', '2024-01-15', 'Compra de mercancía para la venta', 12000000.00, 12000000.00, 'contabilizado', 2, '2024-01-15 14:30:00', 2),
(1, 'COMP-003', 'ingreso', '2024-01-20', 'Venta de productos varios', 3500000.00, 3500000.00, 'contabilizado', 2, '2024-01-20 16:45:00', 2),
(1, 'COMP-004', 'egreso', '2024-01-25', 'Pago de servicios públicos', 450000.00, 450000.00, 'contabilizado', 2, '2024-01-25 11:20:00', 2);

-- =====================================================
-- MOVIMIENTOS CONTABLES DE PRUEBA
-- =====================================================
-- Comprobante de Apertura
INSERT INTO movimientos_contables (comprobante_id, cuenta_id, concepto, debe, haber, orden) VALUES
(1, 3, 'Apertura - Caja', 10000000.00, 0.00, 1),
(1, 4, 'Apertura - Bancos', 40000000.00, 0.00, 2),
(1, 15, 'Apertura - Capital Social', 0.00, 50000000.00, 3);

-- Comprobante de Compra
INSERT INTO movimientos_contables (comprobante_id, cuenta_id, concepto, debe, haber, orden) VALUES
(2, 6, 'Compra de inventarios', 10000000.00, 0.00, 1),
(2, 11, 'IVA pagado en compras', 2000000.00, 0.00, 2),
(2, 10, 'Proveedores nacionales', 0.00, 12000000.00, 3);

-- Comprobante de Venta
INSERT INTO movimientos_contables (comprobante_id, cuenta_id, concepto, debe, haber, orden) VALUES
(3, 5, 'Clientes', 3500000.00, 0.00, 1),
(3, 13, 'Ventas', 0.00, 3000000.00, 2),
(3, 11, 'IVA por pagar', 0.00, 500000.00, 3);

-- Comprobante de Egreso
INSERT INTO movimientos_contables (comprobante_id, cuenta_id, concepto, debe, haber, orden) VALUES
(4, 18, 'Gastos generales', 450000.00, 0.00, 1),
(4, 3, 'Caja', 0.00, 450000.00, 2);

-- =====================================================
-- FACTURAS DE PRUEBA
-- =====================================================
INSERT INTO facturas (empresa_id, numero_factura, cliente_id, fecha_factura, fecha_vencimiento, subtotal, descuento, iva, total, estado, forma_pago, observaciones, usuario_creacion) VALUES
(1, 'FACT-001', 1, '2024-01-20', '2024-01-27', 3000000.00, 0.00, 500000.00, 3500000.00, 'emitida', 'credito', 'Venta de equipos de cómputo', 2),
(1, 'FACT-002', 2, '2024-01-22', '2024-01-22', 1500000.00, 100000.00, 200000.00, 1600000.00, 'pagada', 'contado', 'Venta con descuento especial', 2),
(1, 'FACT-003', 3, '2024-01-25', '2024-02-01', 2000000.00, 0.00, 300000.00, 2300000.00, 'emitida', 'credito', 'Venta a empresa', 2);

-- =====================================================
-- DETALLES DE FACTURAS
-- =====================================================
INSERT INTO factura_detalles (factura_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
-- Factura 001
(1, 1, 1, 2500000.00, 0.00, 2500000.00),
(1, 2, 2, 45000.00, 0.00, 90000.00),
(1, 3, 1, 180000.00, 0.00, 180000.00),
(1, 4, 1, 800000.00, 0.00, 800000.00),

-- Factura 002
(2, 2, 5, 45000.00, 0.00, 225000.00),
(2, 3, 2, 180000.00, 0.00, 360000.00),
(2, 4, 1, 800000.00, 100000.00, 700000.00),

-- Factura 003
(3, 1, 1, 2500000.00, 0.00, 2500000.00);

-- =====================================================
-- PAGOS DE PRUEBA
-- =====================================================
INSERT INTO pagos (empresa_id, factura_id, cliente_id, tipo_pago, forma_pago, monto, fecha_pago, numero_documento, banco, cuenta_bancaria, observaciones, usuario_creacion) VALUES
(1, 2, 2, 'ingreso', 'efectivo', 1600000.00, '2024-01-22', 'PAGO-001', NULL, NULL, 'Pago en efectivo', 2),
(1, NULL, 1, 'ingreso', 'transferencia', 1000000.00, '2024-01-23', 'TRF-001', 'Bancolombia', '1234567890', 'Abono a cuenta', 2),
(1, NULL, NULL, 'egreso', 'cheque', 500000.00, '2024-01-24', 'CHQ-001', 'BBVA', '0987654321', 'Pago a proveedor', 2);

-- =====================================================
-- CONFIGURACIÓN DEL SISTEMA
-- =====================================================
INSERT INTO configuracion_sistema (empresa_id, clave, valor, descripcion, tipo) VALUES
(1, 'nombre_empresa', 'Tienda El Éxito S.A.S', 'Nombre comercial de la empresa', 'texto'),
(1, 'nit_empresa', '900123456-7', 'NIT de la empresa', 'texto'),
(1, 'direccion_empresa', 'Carrera 7 #32-16, Bogotá', 'Dirección principal de la empresa', 'texto'),
(1, 'telefono_empresa', '6012345678', 'Teléfono principal de la empresa', 'texto'),
(1, 'email_empresa', 'contacto@tienelaxito.com', 'Email principal de la empresa', 'texto'),
(1, 'iva_porcentaje', '19', 'Porcentaje de IVA aplicable', 'numero'),
(1, 'moneda_principal', 'COP', 'Moneda principal del sistema', 'texto'),
(1, 'formato_factura', 'FACT-{numero}', 'Formato de numeración de facturas', 'texto'),
(1, 'formato_comprobante', 'COMP-{numero}', 'Formato de numeración de comprobantes', 'texto'),
(1, 'dias_vencimiento_factura', '7', 'Días por defecto para vencimiento de facturas', 'numero'),
(1, 'backup_automatico', 'true', 'Habilitar backup automático', 'booleano'),
(1, 'notificaciones_email', 'true', 'Habilitar notificaciones por email', 'booleano');

-- =====================================================
-- ACTUALIZAR FECHAS DE ÚLTIMO ACCESO
-- =====================================================
UPDATE usuarios SET ultimo_acceso = '2024-01-25 16:30:00' WHERE id = 1;
UPDATE usuarios SET ultimo_acceso = '2024-01-25 15:45:00' WHERE id = 2;
UPDATE usuarios SET ultimo_acceso = '2024-01-24 14:20:00' WHERE id = 3;
UPDATE usuarios SET ultimo_acceso = '2024-01-23 11:15:00' WHERE id = 4;
