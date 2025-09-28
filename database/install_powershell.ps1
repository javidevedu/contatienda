# =====================================================
# CONTATIENDA - INSTALACION DE BASE DE DATOS (PowerShell)
# =====================================================

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "CONTATIENDA - INSTALACION DE BASE DE DATOS" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si MySQL está instalado
try {
    $mysqlVersion = mysql --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "MySQL no encontrado"
    }
    Write-Host "MySQL encontrado: $mysqlVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: MySQL no está instalado o no está en el PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor instala MySQL desde: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
    Write-Host "O agrega MySQL al PATH del sistema" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "Iniciando instalación..." -ForegroundColor Yellow
Write-Host ""

# Solicitar contraseña de MySQL
$mysqlPassword = Read-Host "Ingresa la contraseña de MySQL (root)" -AsSecureString
$mysqlPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($mysqlPassword))

Write-Host ""
Write-Host "Creando base de datos y tablas..." -ForegroundColor Yellow

# Ejecutar schema.sql
try {
    Get-Content "schema.sql" | mysql -u root -p$mysqlPasswordPlain
    if ($LASTEXITCODE -ne 0) {
        throw "Error al crear el esquema"
    }
    Write-Host "✓ Esquema creado exitosamente" -ForegroundColor Green
} catch {
    Write-Host "ERROR: No se pudo crear el esquema de la base de datos" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "Insertando datos de ejemplo..." -ForegroundColor Yellow

# Ejecutar sample_data.sql
try {
    Get-Content "sample_data.sql" | mysql -u root -p$mysqlPasswordPlain
    if ($LASTEXITCODE -ne 0) {
        throw "Error al insertar datos"
    }
    Write-Host "✓ Datos de ejemplo insertados exitosamente" -ForegroundColor Green
} catch {
    Write-Host "ERROR: No se pudieron insertar los datos de ejemplo" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "INSTALACION COMPLETADA EXITOSAMENTE" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "La base de datos 'contatienda' ha sido creada con:" -ForegroundColor Green
Write-Host "- Esquema completo de tablas" -ForegroundColor White
Write-Host "- Datos de ejemplo para pruebas" -ForegroundColor White
Write-Host "- Usuarios de prueba" -ForegroundColor White
Write-Host "- Empresas de ejemplo" -ForegroundColor White
Write-Host ""
Write-Host "Credenciales de prueba:" -ForegroundColor Yellow
Write-Host "Usuario: admin" -ForegroundColor White
Write-Host "Contraseña: password" -ForegroundColor White
Write-Host ""
Write-Host "Para verificar la instalación, ejecuta:" -ForegroundColor Cyan
Write-Host "mysql -u root -p -e 'USE contatienda; SHOW TABLES;'" -ForegroundColor White
Write-Host ""
Read-Host "Presiona Enter para continuar"
