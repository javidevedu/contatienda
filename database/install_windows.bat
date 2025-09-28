@echo off
echo =====================================================
echo CONTATIENDA - INSTALACION DE BASE DE DATOS
echo =====================================================
echo.

REM Verificar si MySQL está instalado
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: MySQL no está instalado o no está en el PATH
    echo.
    echo Por favor instala MySQL desde: https://dev.mysql.com/downloads/mysql/
    echo O agrega MySQL al PATH del sistema
    echo.
    pause
    exit /b 1
)

echo MySQL encontrado. Iniciando instalacion...
echo.

REM Solicitar contraseña de MySQL
set /p mysql_password="Ingresa la contraseña de MySQL (root): "

echo.
echo Creando base de datos y tablas...
mysql -u root -p%mysql_password% < schema.sql
if %errorlevel% neq 0 (
    echo ERROR: No se pudo crear el esquema de la base de datos
    pause
    exit /b 1
)

echo.
echo Insertando datos de ejemplo...
mysql -u root -p%mysql_password% < sample_data.sql
if %errorlevel% neq 0 (
    echo ERROR: No se pudieron insertar los datos de ejemplo
    pause
    exit /b 1
)

echo.
echo =====================================================
echo INSTALACION COMPLETADA EXITOSAMENTE
echo =====================================================
echo.
echo La base de datos 'contatienda' ha sido creada con:
echo - Esquema completo de tablas
echo - Datos de ejemplo para pruebas
echo - Usuarios de prueba
echo - Empresas de ejemplo
echo.
echo Credenciales de prueba:
echo Usuario: admin
echo Contraseña: password
echo.
pause
