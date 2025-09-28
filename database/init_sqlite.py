#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ContaTienda - Inicializador de Base de Datos SQLite
Sistema Contable Web - Base de Datos Local
"""

import sqlite3
import os
import sys
from datetime import datetime

def init_database():
    """Inicializa la base de datos SQLite de ContaTienda"""
    
    # Ruta de la base de datos
    db_path = os.path.join(os.path.dirname(__file__), 'contatienda.db')
    
    print("=" * 60)
    print("CONTATIENDA - INICIALIZADOR DE BASE DE DATOS")
    print("=" * 60)
    print(f"Creando base de datos en: {db_path}")
    print()
    
    try:
        # Conectar a la base de datos (se crea si no existe)
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("✓ Conexión a SQLite establecida")
        
        # Leer y ejecutar el esquema
        schema_file = os.path.join(os.path.dirname(__file__), 'schema_sqlite.sql')
        if os.path.exists(schema_file):
            with open(schema_file, 'r', encoding='utf-8') as f:
                schema_sql = f.read()
            
            # Ejecutar el esquema
            cursor.executescript(schema_sql)
            print("✓ Esquema de base de datos creado")
        else:
            print("❌ Error: No se encontró el archivo schema_sqlite.sql")
            return False
        
        # Leer y ejecutar los datos de ejemplo
        sample_file = os.path.join(os.path.dirname(__file__), 'sample_data_sqlite.sql')
        if os.path.exists(sample_file):
            with open(sample_file, 'r', encoding='utf-8') as f:
                sample_sql = f.read()
            
            # Ejecutar los datos de ejemplo
            cursor.executescript(sample_sql)
            print("✓ Datos de ejemplo insertados")
        else:
            print("❌ Error: No se encontró el archivo sample_data_sqlite.sql")
            return False
        
        # Verificar la instalación
        print("\n" + "=" * 40)
        print("VERIFICACIÓN DE INSTALACIÓN")
        print("=" * 40)
        
        # Contar registros en cada tabla
        tables = [
            'usuarios', 'empresas', 'usuario_empresas', 'plan_cuentas',
            'comprobantes', 'movimientos_contables', 'clientes', 'proveedores',
            'productos', 'facturas', 'factura_detalles', 'pagos', 'configuracion_sistema'
        ]
        
        for table in tables:
            try:
                cursor.execute(f"SELECT COUNT(*) FROM {table}")
                count = cursor.fetchone()[0]
                print(f"✓ {table}: {count} registros")
            except sqlite3.Error as e:
                print(f"❌ {table}: Error - {e}")
        
        # Mostrar usuarios creados
        print("\n" + "-" * 40)
        print("USUARIOS DE PRUEBA CREADOS:")
        print("-" * 40)
        cursor.execute("SELECT cedula, fecha_registro, estado FROM usuarios")
        users = cursor.fetchall()
        
        for user in users:
            print(f"• Cédula: {user[0]} | Registro: {user[1]} | Estado: {user[2]}")
        
        # Mostrar empresas creadas
        print("\n" + "-" * 40)
        print("EMPRESAS CREADAS:")
        print("-" * 40)
        cursor.execute("SELECT nombre, nit, regimen FROM empresas")
        companies = cursor.fetchall()
        
        for company in companies:
            print(f"• {company[0]} | NIT: {company[1]} | Régimen: {company[2]}")
        
        # Confirmar cambios
        conn.commit()
        print("\n" + "=" * 60)
        print("¡INSTALACIÓN COMPLETADA EXITOSAMENTE!")
        print("=" * 60)
        print()
        print("CREDENCIALES DE PRUEBA:")
        print("• Cédula: 12345678")
        print("• Contraseña: password")
        print()
        print("UBICACIÓN DE LA BASE DE DATOS:")
        print(f"• Archivo: {db_path}")
        print(f"• Tamaño: {os.path.getsize(db_path)} bytes")
        print()
        print("Para usar la base de datos en tu aplicación:")
        print("• Conecta a: contatienda.db")
        print("• Usa SQLite3 o cualquier cliente SQLite")
        print()
        
        return True
        
    except sqlite3.Error as e:
        print(f"❌ Error de SQLite: {e}")
        return False
    except Exception as e:
        print(f"❌ Error general: {e}")
        return False
    finally:
        if 'conn' in locals():
            conn.close()
            print("✓ Conexión cerrada")

def check_dependencies():
    """Verifica que las dependencias estén disponibles"""
    try:
        import sqlite3
        print("✓ SQLite3 disponible")
        return True
    except ImportError:
        print("❌ SQLite3 no está disponible")
        return False

def main():
    """Función principal"""
    print("Iniciando ContaTienda Database Initializer...")
    print()
    
    # Verificar dependencias
    if not check_dependencies():
        print("Por favor instala Python con soporte SQLite3")
        sys.exit(1)
    
    # Inicializar base de datos
    if init_database():
        print("¡Base de datos inicializada correctamente!")
        sys.exit(0)
    else:
        print("Error al inicializar la base de datos")
        sys.exit(1)

if __name__ == "__main__":
    main()
