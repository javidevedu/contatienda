# ContaTienda - Base de Datos SQLite Local

## 📊 Descripción

ContaTienda ahora usa **SQLite** como base de datos local, lo que significa que:
- ✅ **No requiere servidor** de base de datos
- ✅ **Portable** - funciona en cualquier computadora
- ✅ **Archivo único** - toda la data en `contatienda.db`
- ✅ **Perfecto para ejecutables** - ideal para crear aplicaciones distribuidas

## 🚀 Instalación Rápida

### **Opción 1: Script Automático (Recomendado)**
```bash
cd database
init_sqlite.bat
```

### **Opción 2: Python Manual**
```bash
cd database
python init_sqlite.py
```

### **Opción 3: SQLite Manual**
```bash
cd database
sqlite3 contatienda.db < schema_sqlite.sql
sqlite3 contatienda.db < sample_data_sqlite.sql
```

## 📁 Archivos de Base de Datos

| Archivo | Descripción |
|---------|-------------|
| `contatienda.db` | **Base de datos principal** (se crea automáticamente) |
| `schema_sqlite.sql` | Esquema de tablas para SQLite |
| `sample_data_sqlite.sql` | Datos de ejemplo |
| `init_sqlite.py` | Inicializador en Python |
| `init_sqlite.bat` | Script de Windows |

## 🔐 Credenciales de Prueba

| Campo | Valor |
|-------|-------|
| **Cédula** | `12345678` |
| **Contraseña** | `password` |

## 🗄️ Estructura Simplificada

### **Tabla de Usuarios (Simplificada)**
```sql
usuarios:
- id (INTEGER PRIMARY KEY)
- cedula (TEXT UNIQUE) ← Solo cédula
- password_hash (TEXT) ← Solo contraseña
- fecha_registro (DATETIME)
- ultimo_acceso (DATETIME)
- estado (TEXT)
```

### **Otras Tablas**
- **empresas** - Información de empresas
- **plan_cuentas** - Plan contable
- **comprobantes** - Comprobantes contables
- **movimientos_contables** - Movimientos detallados
- **clientes** - Base de clientes
- **proveedores** - Base de proveedores
- **productos** - Catálogo de productos
- **facturas** - Sistema de facturación
- **pagos** - Registro de pagos

## 💻 Uso en Aplicaciones

### **Conexión desde Python**
```python
import sqlite3

# Conectar a la base de datos
conn = sqlite3.connect('database/contatienda.db')
cursor = conn.cursor()

# Ejemplo: Verificar login
def verificar_login(cedula, password):
    cursor.execute("""
        SELECT id, cedula FROM usuarios 
        WHERE cedula = ? AND password_hash = ?
    """, (cedula, password))
    return cursor.fetchone()

# Ejemplo: Registrar usuario
def registrar_usuario(cedula, password_hash):
    cursor.execute("""
        INSERT INTO usuarios (cedula, password_hash) 
        VALUES (?, ?)
    """, (cedula, password_hash))
    conn.commit()
```

### **Conexión desde JavaScript (Node.js)**
```javascript
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./database/contatienda.db');

// Ejemplo: Verificar login
function verificarLogin(cedula, password, callback) {
    db.get(
        "SELECT id, cedula FROM usuarios WHERE cedula = ? AND password_hash = ?",
        [cedula, password],
        callback
    );
}
```

### **Conexión desde C# (.NET)**
```csharp
using System.Data.SQLite;

string connectionString = "Data Source=database/contatienda.db;Version=3;";
using (var connection = new SQLiteConnection(connectionString))
{
    connection.Open();
    
    // Ejemplo: Verificar login
    string query = "SELECT id, cedula FROM usuarios WHERE cedula = @cedula AND password_hash = @password";
    using (var command = new SQLiteCommand(query, connection))
    {
        command.Parameters.AddWithValue("@cedula", cedula);
        command.Parameters.AddWithValue("@password", password);
        // Ejecutar consulta...
    }
}
```

## 🔧 Ventajas de SQLite

### **Para Desarrollo**
- ✅ **Sin configuración** - funciona inmediatamente
- ✅ **Sin servidor** - no necesita MySQL/PostgreSQL
- ✅ **Archivo único** - fácil de respaldar y mover
- ✅ **Transacciones ACID** - datos seguros

### **Para Distribución**
- ✅ **Portable** - funciona en cualquier Windows/Linux/Mac
- ✅ **Sin dependencias** - solo el archivo .db
- ✅ **Tamaño pequeño** - base de datos ligera
- ✅ **Perfecto para ejecutables** - ideal para aplicaciones distribuidas

## 📊 Consultas Útiles

### **Verificar Usuarios**
```sql
SELECT cedula, fecha_registro, estado FROM usuarios;
```

### **Verificar Empresas**
```sql
SELECT nombre, nit, regimen FROM empresas;
```

### **Balance de Prueba**
```sql
SELECT 
    pc.codigo, 
    pc.nombre, 
    pc.tipo,
    COALESCE(SUM(mc.debe), 0) as total_debe,
    COALESCE(SUM(mc.haber), 0) as total_haber
FROM plan_cuentas pc
LEFT JOIN movimientos_contables mc ON pc.id = mc.cuenta_id
LEFT JOIN comprobantes c ON mc.comprobante_id = c.id AND c.estado = 'contabilizado'
GROUP BY pc.id, pc.codigo, pc.nombre, pc.tipo
ORDER BY pc.codigo;
```

### **Ventas por Período**
```sql
SELECT 
    DATE(f.fecha_factura) as fecha,
    COUNT(*) as cantidad_facturas,
    SUM(f.total) as total_ventas
FROM facturas f
WHERE f.estado IN ('emitida', 'pagada')
GROUP BY DATE(f.fecha_factura)
ORDER BY fecha;
```

## 🔄 Respaldo y Restauración

### **Crear Respaldo**
```bash
# Copiar el archivo de base de datos
copy contatienda.db contatienda_backup_20240125.db

# O usar SQLite
sqlite3 contatienda.db ".backup contatienda_backup.db"
```

### **Restaurar Respaldo**
```bash
# Simplemente reemplazar el archivo
copy contatienda_backup.db contatienda.db
```

## 🚀 Próximos Pasos

1. **Conectar frontend** con la base de datos SQLite
2. **Crear API local** para manejar las operaciones
3. **Empaquetar como ejecutable** con la base de datos incluida
4. **Agregar más funcionalidades** contables

## 📞 Soporte

La base de datos SQLite es perfecta para:
- ✅ **Aplicaciones de escritorio**
- ✅ **Sistemas portátiles**
- ✅ **Prototipos rápidos**
- ✅ **Distribución fácil**

---

**ContaTienda SQLite** - Base de Datos Local  
Versión 1.0 - Sistema Contable Web
