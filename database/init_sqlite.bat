@echo off
echo =====================================================
echo CONTATIENDA - INICIALIZADOR DE BASE DE DATOS SQLITE
echo =====================================================
echo.

REM Verificar si Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python no está instalado o no está en el PATH
    echo.
    echo Por favor instala Python desde: https://www.python.org/downloads/
    echo Asegúrate de marcar "Add Python to PATH" durante la instalación
    echo.
    pause
    exit /b 1
)

echo Python encontrado. Iniciando inicializacion...
echo.

REM Ejecutar el script de inicialización
python init_sqlite.py

if %errorlevel% neq 0 (
    echo.
    echo ERROR: No se pudo inicializar la base de datos
    pause
    exit /b 1
)

echo.
echo =====================================================
echo INICIALIZACION COMPLETADA
echo =====================================================
echo.
echo La base de datos 'contatienda.db' ha sido creada
echo Puedes usar esta base de datos con tu aplicación ContaTienda
echo.
pause
