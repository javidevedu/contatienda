-- =====================================================
-- CONTATIENDA - ESQUEMA DE BASE DE DATOS
-- Sistema Contable Web
-- =====================================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS contatienda 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE contatienda;

-- =====================================================
-- TABLA DE USUARIOS
-- =====================================================
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    rol ENUM('admin', 'contador', 'usuario') DEFAULT 'usuario',
    estado ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLA DE EMPRESAS
-- =====================================================
CREATE TABLE empresas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    nit VARCHAR(20) UNIQUE NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    representante_legal VARCHAR(200),
    cedula_representante VARCHAR(20),
    regimen ENUM('simplificado', 'comun', 'gran_contribuyente') DEFAULT 'simplificado',
    actividad_economica VARCHAR(300),
    fecha_constitucion DATE,
    estado ENUM('activa', 'inactiva') DEFAULT 'activa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLA DE USUARIOS-EMPRESAS (Relación muchos a muchos)
-- =====================================================
CREATE TABLE usuario_empresas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    empresa_id INT NOT NULL,
    rol ENUM('propietario', 'contador', 'empleado') DEFAULT 'empleado',
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_usuario_empresa (usuario_id, empresa_id)
);

-- =====================================================
-- TABLA DE PLAN DE CUENTAS
-- =====================================================
CREATE TABLE plan_cuentas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    tipo ENUM('activo', 'pasivo', 'patrimonio', 'ingreso', 'gasto', 'costo') NOT NULL,
    naturaleza ENUM('deudor', 'acreedor') NOT NULL,
    nivel INT DEFAULT 1,
    cuenta_padre_id INT NULL,
    es_cuenta_movimiento BOOLEAN DEFAULT TRUE,
    estado ENUM('activa', 'inactiva') DEFAULT 'activa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_padre_id) REFERENCES plan_cuentas(id) ON DELETE SET NULL,
    UNIQUE KEY unique_codigo_empresa (empresa_id, codigo)
);

-- =====================================================
-- TABLA DE COMPROBANTES
-- =====================================================
CREATE TABLE comprobantes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    numero_comprobante VARCHAR(50) NOT NULL,
    tipo_comprobante ENUM('ingreso', 'egreso', 'diario', 'apertura', 'cierre') NOT NULL,
    fecha_comprobante DATE NOT NULL,
    concepto TEXT,
    total_debe DECIMAL(15,2) DEFAULT 0.00,
    total_haber DECIMAL(15,2) DEFAULT 0.00,
    estado ENUM('borrador', 'contabilizado', 'anulado') DEFAULT 'borrador',
    usuario_creacion INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_aprobacion INT NULL,
    fecha_aprobacion TIMESTAMP NULL,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_creacion) REFERENCES usuarios(id),
    FOREIGN KEY (usuario_aprobacion) REFERENCES usuarios(id),
    UNIQUE KEY unique_numero_empresa (empresa_id, numero_comprobante)
);

-- =====================================================
-- TABLA DE MOVIMIENTOS CONTABLES
-- =====================================================
CREATE TABLE movimientos_contables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    comprobante_id INT NOT NULL,
    cuenta_id INT NOT NULL,
    concepto VARCHAR(300) NOT NULL,
    debe DECIMAL(15,2) DEFAULT 0.00,
    haber DECIMAL(15,2) DEFAULT 0.00,
    orden INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comprobante_id) REFERENCES comprobantes(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_id) REFERENCES plan_cuentas(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLA DE CLIENTES
-- =====================================================
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    tipo_documento ENUM('cedula', 'nit', 'pasaporte', 'extranjeria') DEFAULT 'cedula',
    numero_documento VARCHAR(20) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100),
    razon_social VARCHAR(200),
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_nacimiento DATE,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_documento_empresa (empresa_id, tipo_documento, numero_documento)
);

-- =====================================================
-- TABLA DE PROVEEDORES
-- =====================================================
CREATE TABLE proveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    tipo_documento ENUM('cedula', 'nit', 'pasaporte', 'extranjeria') DEFAULT 'nit',
    numero_documento VARCHAR(20) NOT NULL,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    razon_social VARCHAR(200) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_documento_empresa (empresa_id, tipo_documento, numero_documento)
);

-- =====================================================
-- TABLA DE PRODUCTOS/SERVICIOS
-- =====================================================
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo ENUM('producto', 'servicio') DEFAULT 'producto',
    precio_venta DECIMAL(15,2) NOT NULL,
    costo DECIMAL(15,2) DEFAULT 0.00,
    unidad_medida VARCHAR(20) DEFAULT 'unidad',
    stock_minimo INT DEFAULT 0,
    stock_actual INT DEFAULT 0,
    cuenta_ingreso_id INT,
    cuenta_costo_id INT,
    cuenta_inventario_id INT,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_ingreso_id) REFERENCES plan_cuentas(id),
    FOREIGN KEY (cuenta_costo_id) REFERENCES plan_cuentas(id),
    FOREIGN KEY (cuenta_inventario_id) REFERENCES plan_cuentas(id),
    UNIQUE KEY unique_codigo_empresa (empresa_id, codigo)
);

-- =====================================================
-- TABLA DE FACTURAS
-- =====================================================
CREATE TABLE facturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    numero_factura VARCHAR(50) NOT NULL,
    cliente_id INT NOT NULL,
    fecha_factura DATE NOT NULL,
    fecha_vencimiento DATE,
    subtotal DECIMAL(15,2) NOT NULL,
    descuento DECIMAL(15,2) DEFAULT 0.00,
    iva DECIMAL(15,2) DEFAULT 0.00,
    total DECIMAL(15,2) NOT NULL,
    estado ENUM('borrador', 'emitida', 'pagada', 'anulada') DEFAULT 'borrador',
    forma_pago ENUM('contado', 'credito', 'mixto') DEFAULT 'contado',
    observaciones TEXT,
    usuario_creacion INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_creacion) REFERENCES usuarios(id),
    UNIQUE KEY unique_numero_empresa (empresa_id, numero_factura)
);

-- =====================================================
-- TABLA DE DETALLES DE FACTURA
-- =====================================================
CREATE TABLE factura_detalles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    factura_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(15,2) NOT NULL,
    descuento DECIMAL(15,2) DEFAULT 0.00,
    subtotal DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLA DE PAGOS
-- =====================================================
CREATE TABLE pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    factura_id INT,
    cliente_id INT,
    proveedor_id INT,
    tipo_pago ENUM('ingreso', 'egreso') NOT NULL,
    forma_pago ENUM('efectivo', 'transferencia', 'cheque', 'tarjeta') NOT NULL,
    monto DECIMAL(15,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    numero_documento VARCHAR(50),
    banco VARCHAR(100),
    cuenta_bancaria VARCHAR(50),
    observaciones TEXT,
    usuario_creacion INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE SET NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_creacion) REFERENCES usuarios(id)
);

-- =====================================================
-- TABLA DE CONFIGURACIÓN DEL SISTEMA
-- =====================================================
CREATE TABLE configuracion_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    clave VARCHAR(100) NOT NULL,
    valor TEXT,
    descripcion VARCHAR(300),
    tipo ENUM('texto', 'numero', 'fecha', 'booleano', 'json') DEFAULT 'texto',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_clave_empresa (empresa_id, clave)
);

-- =====================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para búsquedas frecuentes
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_usuarios_cedula ON usuarios(cedula);

CREATE INDEX idx_comprobantes_fecha ON comprobantes(fecha_comprobante);
CREATE INDEX idx_comprobantes_empresa_fecha ON comprobantes(empresa_id, fecha_comprobante);

CREATE INDEX idx_movimientos_cuenta ON movimientos_contables(cuenta_id);
CREATE INDEX idx_movimientos_comprobante ON movimientos_contables(comprobante_id);

CREATE INDEX idx_facturas_cliente ON facturas(cliente_id);
CREATE INDEX idx_facturas_fecha ON facturas(fecha_factura);
CREATE INDEX idx_facturas_empresa_fecha ON facturas(empresa_id, fecha_factura);

CREATE INDEX idx_clientes_documento ON clientes(numero_documento);
CREATE INDEX idx_proveedores_documento ON proveedores(numero_documento);

-- =====================================================
-- TRIGGERS PARA AUDITORÍA
-- =====================================================

-- Trigger para actualizar totales de comprobantes
DELIMITER //
CREATE TRIGGER tr_update_comprobante_totals
AFTER INSERT ON movimientos_contables
FOR EACH ROW
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
END//

-- Trigger para actualizar stock de productos
CREATE TRIGGER tr_update_producto_stock
AFTER INSERT ON factura_detalles
FOR EACH ROW
BEGIN
    UPDATE productos 
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id = NEW.producto_id;
END//

DELIMITER ;
