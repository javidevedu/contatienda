-- =====================================================
-- CONTATIENDA - ESQUEMA DE BASE DE DATOS SQLITE
-- Sistema Contable Web - Base de Datos Local
-- =====================================================

-- Crear base de datos SQLite (se crea automáticamente al conectar)

-- =====================================================
-- TABLA DE USUARIOS (SIMPLIFICADA)
-- =====================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cedula TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso DATETIME,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo'))
);

-- =====================================================
-- TABLA DE EMPRESAS
-- =====================================================
CREATE TABLE IF NOT EXISTS empresas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    nit TEXT UNIQUE NOT NULL,
    direccion TEXT,
    telefono TEXT,
    email TEXT,
    representante_legal TEXT,
    cedula_representante TEXT,
    regimen TEXT DEFAULT 'simplificado' CHECK (regimen IN ('simplificado', 'comun', 'gran_contribuyente')),
    actividad_economica TEXT,
    fecha_constitucion DATE,
    estado TEXT DEFAULT 'activa' CHECK (estado IN ('activa', 'inactiva')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLA DE USUARIOS-EMPRESAS (Relación muchos a muchos)
-- =====================================================
CREATE TABLE IF NOT EXISTS usuario_empresas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    empresa_id INTEGER NOT NULL,
    rol TEXT DEFAULT 'empleado' CHECK (rol IN ('propietario', 'contador', 'empleado')),
    fecha_asignacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE(usuario_id, empresa_id)
);

-- =====================================================
-- TABLA DE PLAN DE CUENTAS
-- =====================================================
CREATE TABLE IF NOT EXISTS plan_cuentas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    codigo TEXT NOT NULL,
    nombre TEXT NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('activo', 'pasivo', 'patrimonio', 'ingreso', 'gasto', 'costo')),
    naturaleza TEXT NOT NULL CHECK (naturaleza IN ('deudor', 'acreedor')),
    nivel INTEGER DEFAULT 1,
    cuenta_padre_id INTEGER,
    es_cuenta_movimiento BOOLEAN DEFAULT 1,
    estado TEXT DEFAULT 'activa' CHECK (estado IN ('activa', 'inactiva')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_padre_id) REFERENCES plan_cuentas(id) ON DELETE SET NULL,
    UNIQUE(empresa_id, codigo)
);

-- =====================================================
-- TABLA DE COMPROBANTES
-- =====================================================
CREATE TABLE IF NOT EXISTS comprobantes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    numero_comprobante TEXT NOT NULL,
    tipo_comprobante TEXT NOT NULL CHECK (tipo_comprobante IN ('ingreso', 'egreso', 'diario', 'apertura', 'cierre')),
    fecha_comprobante DATE NOT NULL,
    concepto TEXT,
    total_debe DECIMAL(15,2) DEFAULT 0.00,
    total_haber DECIMAL(15,2) DEFAULT 0.00,
    estado TEXT DEFAULT 'borrador' CHECK (estado IN ('borrador', 'contabilizado', 'anulado')),
    usuario_creacion INTEGER NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_aprobacion INTEGER,
    fecha_aprobacion DATETIME,
    observaciones TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_creacion) REFERENCES usuarios(id),
    FOREIGN KEY (usuario_aprobacion) REFERENCES usuarios(id),
    UNIQUE(empresa_id, numero_comprobante)
);

-- =====================================================
-- TABLA DE MOVIMIENTOS CONTABLES
-- =====================================================
CREATE TABLE IF NOT EXISTS movimientos_contables (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    comprobante_id INTEGER NOT NULL,
    cuenta_id INTEGER NOT NULL,
    concepto TEXT NOT NULL,
    debe DECIMAL(15,2) DEFAULT 0.00,
    haber DECIMAL(15,2) DEFAULT 0.00,
    orden INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comprobante_id) REFERENCES comprobantes(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_id) REFERENCES plan_cuentas(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLA DE CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    tipo_documento TEXT DEFAULT 'cedula' CHECK (tipo_documento IN ('cedula', 'nit', 'pasaporte', 'extranjeria')),
    numero_documento TEXT NOT NULL,
    nombres TEXT,
    apellidos TEXT,
    razon_social TEXT,
    direccion TEXT,
    telefono TEXT,
    email TEXT,
    fecha_nacimiento DATE,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE(empresa_id, tipo_documento, numero_documento)
);

-- =====================================================
-- TABLA DE PROVEEDORES
-- =====================================================
CREATE TABLE IF NOT EXISTS proveedores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    tipo_documento TEXT DEFAULT 'nit' CHECK (tipo_documento IN ('cedula', 'nit', 'pasaporte', 'extranjeria')),
    numero_documento TEXT NOT NULL,
    nombres TEXT,
    apellidos TEXT,
    razon_social TEXT NOT NULL,
    direccion TEXT,
    telefono TEXT,
    email TEXT,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE(empresa_id, tipo_documento, numero_documento)
);

-- =====================================================
-- TABLA DE PRODUCTOS/SERVICIOS
-- =====================================================
CREATE TABLE IF NOT EXISTS productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    codigo TEXT NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    tipo TEXT DEFAULT 'producto' CHECK (tipo IN ('producto', 'servicio')),
    precio_venta DECIMAL(15,2) NOT NULL,
    costo DECIMAL(15,2) DEFAULT 0.00,
    unidad_medida TEXT DEFAULT 'unidad',
    stock_minimo INTEGER DEFAULT 0,
    stock_actual INTEGER DEFAULT 0,
    cuenta_ingreso_id INTEGER,
    cuenta_costo_id INTEGER,
    cuenta_inventario_id INTEGER,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_ingreso_id) REFERENCES plan_cuentas(id),
    FOREIGN KEY (cuenta_costo_id) REFERENCES plan_cuentas(id),
    FOREIGN KEY (cuenta_inventario_id) REFERENCES plan_cuentas(id),
    UNIQUE(empresa_id, codigo)
);

-- =====================================================
-- TABLA DE FACTURAS
-- =====================================================
CREATE TABLE IF NOT EXISTS facturas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    numero_factura TEXT NOT NULL,
    cliente_id INTEGER NOT NULL,
    fecha_factura DATE NOT NULL,
    fecha_vencimiento DATE,
    subtotal DECIMAL(15,2) NOT NULL,
    descuento DECIMAL(15,2) DEFAULT 0.00,
    iva DECIMAL(15,2) DEFAULT 0.00,
    total DECIMAL(15,2) NOT NULL,
    estado TEXT DEFAULT 'borrador' CHECK (estado IN ('borrador', 'emitida', 'pagada', 'anulada')),
    forma_pago TEXT DEFAULT 'contado' CHECK (forma_pago IN ('contado', 'credito', 'mixto')),
    observaciones TEXT,
    usuario_creacion INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_creacion) REFERENCES usuarios(id),
    UNIQUE(empresa_id, numero_factura)
);

-- =====================================================
-- TABLA DE DETALLES DE FACTURA
-- =====================================================
CREATE TABLE IF NOT EXISTS factura_detalles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    factura_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(15,2) NOT NULL,
    descuento DECIMAL(15,2) DEFAULT 0.00,
    subtotal DECIMAL(15,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLA DE PAGOS
-- =====================================================
CREATE TABLE IF NOT EXISTS pagos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    factura_id INTEGER,
    cliente_id INTEGER,
    proveedor_id INTEGER,
    tipo_pago TEXT NOT NULL CHECK (tipo_pago IN ('ingreso', 'egreso')),
    forma_pago TEXT NOT NULL CHECK (forma_pago IN ('efectivo', 'transferencia', 'cheque', 'tarjeta')),
    monto DECIMAL(15,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    numero_documento TEXT,
    banco TEXT,
    cuenta_bancaria TEXT,
    observaciones TEXT,
    usuario_creacion INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE SET NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_creacion) REFERENCES usuarios(id)
);

-- =====================================================
-- TABLA DE CONFIGURACIÓN DEL SISTEMA
-- =====================================================
CREATE TABLE IF NOT EXISTS configuracion_sistema (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    empresa_id INTEGER NOT NULL,
    clave TEXT NOT NULL,
    valor TEXT,
    descripcion TEXT,
    tipo TEXT DEFAULT 'texto' CHECK (tipo IN ('texto', 'numero', 'fecha', 'booleano', 'json')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE(empresa_id, clave)
);

-- =====================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para búsquedas frecuentes
CREATE INDEX IF NOT EXISTS idx_usuarios_cedula ON usuarios(cedula);
CREATE INDEX IF NOT EXISTS idx_comprobantes_fecha ON comprobantes(fecha_comprobante);
CREATE INDEX IF NOT EXISTS idx_comprobantes_empresa_fecha ON comprobantes(empresa_id, fecha_comprobante);
CREATE INDEX IF NOT EXISTS idx_movimientos_cuenta ON movimientos_contables(cuenta_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_comprobante ON movimientos_contables(comprobante_id);
CREATE INDEX IF NOT EXISTS idx_facturas_cliente ON facturas(cliente_id);
CREATE INDEX IF NOT EXISTS idx_facturas_fecha ON facturas(fecha_factura);
CREATE INDEX IF NOT EXISTS idx_facturas_empresa_fecha ON facturas(empresa_id, fecha_factura);
CREATE INDEX IF NOT EXISTS idx_clientes_documento ON clientes(numero_documento);
CREATE INDEX IF NOT EXISTS idx_proveedores_documento ON proveedores(numero_documento);

-- =====================================================
-- TRIGGERS PARA AUDITORÍA (SQLite)
-- =====================================================

-- Trigger para actualizar totales de comprobantes
CREATE TRIGGER IF NOT EXISTS tr_update_comprobante_totals
AFTER INSERT ON movimientos_contables
BEGIN
    UPDATE comprobantes 
    SET total_debe = (
        SELECT COALESCE(SUM(debe), 0) 
        FROM movimientos_contables 
        WHERE comprobante_id = NEW.comprobante_id
    ),
    total_haber = (
        SELECT COALESCE(SUM(haber), 0) 
        FROM movimientos_contables 
        WHERE comprobante_id = NEW.comprobante_id
    )
    WHERE id = NEW.comprobante_id;
END;

-- Trigger para actualizar stock de productos
CREATE TRIGGER IF NOT EXISTS tr_update_producto_stock
AFTER INSERT ON factura_detalles
BEGIN
    UPDATE productos 
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id = NEW.producto_id;
END;

-- Trigger para actualizar updated_at
CREATE TRIGGER IF NOT EXISTS tr_usuarios_updated_at
AFTER UPDATE ON usuarios
BEGIN
    UPDATE usuarios SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS tr_empresas_updated_at
AFTER UPDATE ON empresas
BEGIN
    UPDATE empresas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS tr_comprobantes_updated_at
AFTER UPDATE ON comprobantes
BEGIN
    UPDATE comprobantes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
