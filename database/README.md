# ContaTienda - Base de Datos

## 📊 Descripción del Esquema

La base de datos de ContaTienda está diseñada para manejar un sistema contable completo con múltiples empresas, usuarios, y todas las operaciones contables necesarias.

## 🗄️ Estructura de Tablas

### **Tablas Principales**

#### 1. **usuarios**
Almacena información de todos los usuarios del sistema.
- **Campos clave**: `id`, `cedula`, `email`, `username`, `password_hash`
- **Roles**: admin, contador, usuario
- **Estados**: activo, inactivo, suspendido

#### 2. **empresas**
Información de las empresas que usan el sistema.
- **Campos clave**: `id`, `nit`, `nombre`, `regimen`
- **Regímenes**: simplificado, comun, gran_contribuyente

#### 3. **usuario_empresas**
Relación muchos a muchos entre usuarios y empresas.
- **Roles**: propietario, contador, empleado

### **Módulo Contable**

#### 4. **plan_cuentas**
Plan de cuentas contables por empresa.
- **Tipos**: activo, pasivo, patrimonio, ingreso, gasto, costo
- **Naturaleza**: deudor, acreedor
- **Estructura jerárquica** con `cuenta_padre_id`

#### 5. **comprobantes**
Comprobantes contables (ingreso, egreso, diario, etc.).
- **Tipos**: ingreso, egreso, diario, apertura, cierre
- **Estados**: borrador, contabilizado, anulado
- **Totales automáticos** de debe y haber

#### 6. **movimientos_contables**
Detalle de cada movimiento contable.
- **Relación** con comprobantes y cuentas
- **Validación** de partida doble

### **Módulo Comercial**

#### 7. **clientes**
Información de clientes por empresa.
- **Tipos de documento**: cédula, nit, pasaporte, extranjería
- **Datos completos** de contacto

#### 8. **proveedores**
Información de proveedores por empresa.
- **Estructura similar** a clientes
- **Enfoque en razon social**

#### 9. **productos**
Catálogo de productos/servicios.
- **Tipos**: producto, servicio
- **Control de inventario** con stock
- **Precios** de venta y costo

#### 10. **facturas**
Facturación de ventas.
- **Estados**: borrador, emitida, pagada, anulada
- **Formas de pago**: contado, credito, mixto
- **Cálculos automáticos** de IVA

#### 11. **factura_detalles**
Detalle de productos en cada factura.
- **Cantidades, precios, descuentos**
- **Actualización automática** de stock

#### 12. **pagos**
Registro de pagos recibidos y realizados.
- **Tipos**: ingreso, egreso
- **Formas**: efectivo, transferencia, cheque, tarjeta

### **Configuración**

#### 13. **configuracion_sistema**
Configuraciones específicas por empresa.
- **Parámetros** del sistema
- **Tipos**: texto, numero, fecha, booleano, json

## 🔧 Características Técnicas

### **Índices de Optimización**
- Índices en campos de búsqueda frecuente
- Índices compuestos para consultas complejas
- Optimización para reportes por fecha

### **Triggers Automáticos**
- **Actualización de totales** en comprobantes
- **Control de stock** en productos
- **Auditoría** de cambios

### **Integridad Referencial**
- **Foreign Keys** en todas las relaciones
- **Cascadas** apropiadas para eliminación
- **Constraints** de unicidad

## 📈 Datos de Ejemplo

El archivo `sample_data.sql` incluye:

### **Usuarios de Prueba**
- **admin** (admin@contatienda.com) - Administrador del sistema
- **maria.gonzalez** - Contadora
- **carlos.rodriguez** - Usuario empresarial
- **ana.martinez** - Usuaria empresarial

### **Empresas de Ejemplo**
1. **Tienda El Éxito S.A.S** - Comercio al por menor
2. **Distribuidora ABC Ltda** - Distribución alimenticia
3. **Servicios Contables Pro** - Servicios contables

### **Plan de Cuentas Completo**
- **Estructura PUC** (Plan Único de Cuentas) colombiano
- **Cuentas de movimiento** y de agrupación
- **Clasificación** por tipo y naturaleza

### **Datos Comerciales**
- **5 clientes** con diferentes tipos de documento
- **4 proveedores** variados
- **6 productos/servicios** con precios y stock
- **3 facturas** con diferentes estados
- **3 pagos** de ejemplo

### **Comprobantes Contables**
- **Comprobante de apertura** del ejercicio
- **Comprobantes de compra** y venta
- **Movimientos contables** detallados

## 🚀 Instalación

### **Requisitos**
- MySQL 8.0+ o MariaDB 10.4+
- Usuario con permisos de CREATE DATABASE

### **Pasos de Instalación**

1. **Crear la base de datos:**
```bash
mysql -u root -p < database/schema.sql
```

2. **Insertar datos de ejemplo:**
```bash
mysql -u root -p < database/sample_data.sql
```

3. **Verificar instalación:**
```sql
USE contatienda;
SHOW TABLES;
SELECT COUNT(*) FROM usuarios;
```

## 🔐 Seguridad

### **Contraseñas**
- **Hash bcrypt** para todas las contraseñas
- **Salt** automático para mayor seguridad
- **Contraseña por defecto**: `password` (cambiar en producción)

### **Permisos**
- **Roles granulares** por empresa
- **Control de acceso** a nivel de registro
- **Auditoría** de cambios importantes

## 📊 Consultas Útiles

### **Usuarios por Empresa**
```sql
SELECT u.nombres, u.apellidos, e.nombre as empresa, ue.rol
FROM usuarios u
JOIN usuario_empresas ue ON u.id = ue.usuario_id
JOIN empresas e ON ue.empresa_id = e.id;
```

### **Balance de Prueba**
```sql
SELECT pc.codigo, pc.nombre, pc.tipo,
       COALESCE(SUM(mc.debe), 0) as total_debe,
       COALESCE(SUM(mc.haber), 0) as total_haber
FROM plan_cuentas pc
LEFT JOIN movimientos_contables mc ON pc.id = mc.cuenta_id
JOIN comprobantes c ON mc.comprobante_id = c.id
WHERE c.estado = 'contabilizado'
GROUP BY pc.id, pc.codigo, pc.nombre, pc.tipo
ORDER BY pc.codigo;
```

### **Ventas por Período**
```sql
SELECT DATE(f.fecha_factura) as fecha,
       COUNT(*) as cantidad_facturas,
       SUM(f.total) as total_ventas
FROM facturas f
WHERE f.estado IN ('emitida', 'pagada')
  AND f.fecha_factura >= '2024-01-01'
GROUP BY DATE(f.fecha_factura)
ORDER BY fecha;
```

## 🔄 Mantenimiento

### **Backup Regular**
```bash
mysqldump -u root -p contatienda > backup_contatienda_$(date +%Y%m%d).sql
```

### **Optimización de Tablas**
```sql
OPTIMIZE TABLE movimientos_contables;
OPTIMIZE TABLE factura_detalles;
```

### **Limpieza de Logs**
```sql
-- Eliminar movimientos de comprobantes anulados
DELETE mc FROM movimientos_contables mc
JOIN comprobantes c ON mc.comprobante_id = c.id
WHERE c.estado = 'anulado';
```

## 📋 Próximos Pasos

1. **Implementar API REST** para conectar con el frontend
2. **Agregar más validaciones** de negocio
3. **Implementar auditoría** completa
4. **Crear vistas** para reportes frecuentes
5. **Optimizar consultas** según uso real

---

**ContaTienda Database** - Versión 1.0  
Sistema Contable Web - Base de Datos
