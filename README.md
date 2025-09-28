# ContaTienda - Prototipos de Interfaz de Usuario

## 📋 Descripción del Proyecto

ContaTienda es un software contable web que incluye prototipos funcionales de las pantallas principales del sistema. Los prototipos están implementados con HTML, CSS y JavaScript para proporcionar una experiencia de usuario completa y realista.

## 🎨 Paleta de Colores

### Colores Principales

| Color | Código | Uso |
|-------|--------|-----|
| **Azul Oscuro** | `#1e3a8a` | Encabezados, botones principales, elementos de navegación |
| **Azul Claro** | `#3b82f6` | Acentos, hover states, gradientes |
| **Blanco** | `#ffffff` | Fondos principales, texto sobre colores oscuros |
| **Gris Claro** | `#f3f4f6` | Fondos de formularios, elementos secundarios |
| **Gris Medio** | `#6b7280` | Texto secundario, botones secundarios |
| **Gris Borde** | `#d1d5db` | Bordes, separadores |

### Justificación de la Paleta

La paleta de colores seleccionada está diseñada para un software contable profesional:

- **Azul Oscuro (#1e3a8a)**: Transmite confianza, profesionalismo y estabilidad, elementos clave en software financiero
- **Blanco (#ffffff)**: Proporciona limpieza visual y facilita la lectura de datos contables
- **Gris (#6b7280)**: Crea jerarquía visual sin distraer del contenido principal

## 🖥️ Pantallas Implementadas

### 1. Pantalla de Autenticación (Login)

**Componentes principales:**
- Logo y título "ContaTienda"
- Campo de usuario
- Campo de contraseña
- Botón "Ingresar"
- Enlace a registro
- Mensaje de error (oculto por defecto)

**Funcionalidades:**
- Validación de credenciales (usuario: `admin`, contraseña: `123456`)
- Mensajes de error dinámicos
- Navegación a pantalla de registro

### 2. Pantalla de Registro de Usuario

**Componentes principales:**
- Encabezado con título y descripción
- Formulario con campos:
  - Nombres
  - Apellidos
  - Cédula
  - Fecha de nacimiento
- Botones "Cancelar" y "Registrar"
- Mensaje de error (oculto por defecto)

**Funcionalidades:**
- Validación en tiempo real de campos
- Validación de edad (mínimo 18 años)
- Validación de formato de cédula
- Navegación de vuelta al login

### 3. Pantalla de Notificación de Errores

**Componentes principales:**
- Icono de advertencia
- Título "Error del Sistema"
- Mensaje de error personalizable
- Detalles del error:
  - Código de error
  - Hora del error
- Botones "Volver al Inicio" y "Reintentar"

**Funcionalidades:**
- Mensajes de error dinámicos
- Códigos de error personalizables
- Timestamp automático
- Simulación de reintento de operación

## 🚀 Cómo Usar los Prototipos

### Instalación
1. Descarga todos los archivos en una carpeta
2. Abre `index.html` en tu navegador web
3. Usa la navegación en la esquina superior derecha para cambiar entre pantallas

### Navegación
- **Login**: Pantalla de autenticación principal
- **Registro**: Formulario de registro de nuevos usuarios
- **Error**: Pantalla de notificación de errores (con mensaje de ejemplo)

### Credenciales de Prueba
- **Usuario**: `admin`
- **Contraseña**: `123456`

## 📱 Características Responsive

Los prototipos están optimizados para diferentes tamaños de pantalla:

- **Desktop**: Layout completo con formularios en dos columnas
- **Tablet**: Adaptación de espaciado y tamaños
- **Mobile**: Formularios en una columna, navegación simplificada

## 🎯 Funcionalidades Implementadas

### Validaciones
- Validación de credenciales de login
- Validación de formato de cédula (solo números, 7-10 dígitos)
- Validación de nombres (solo letras y espacios)
- Validación de edad mínima (18 años)
- Validación de campos requeridos

### Interacciones
- Efectos hover en botones
- Transiciones suaves entre pantallas
- Notificaciones de éxito temporales
- Mensajes de error contextuales
- Navegación con teclado (ESC para volver al login)

### Animaciones
- Fade in al cambiar pantallas
- Efectos de hover con elevación
- Notificaciones con slide down/up
- Estados de carga en botones

## 🔧 Estructura de Archivos

```
contatienda/
├── index.html          # Estructura HTML principal
├── styles.css          # Estilos CSS y paleta de colores
├── script.js           # Funcionalidad JavaScript
└── README.md           # Documentación del proyecto
```

## 🎨 Wireframes Conceptuales

### Pantalla de Login
```
┌─────────────────────────────────┐
│           ContaTienda           │
│      Sistema de Gestión        │
│                                 │
│  Usuario: [________________]   │
│  Contraseña: [______________]  │
│                                 │
│        [   Ingresar   ]         │
│                                 │
│    ¿No tienes cuenta?           │
│       Regístrate                │
└─────────────────────────────────┘
```

### Pantalla de Registro
```
┌─────────────────────────────────┐
│      Registro de Usuario        │
│   Completa tus datos para       │
│      crear una cuenta           │
│                                 │
│  Nombres: [_____________]       │
│  Apellidos: [___________]       │
│  Cédula: [_____________]        │
│  Fecha: [_____________]         │
│                                 │
│    [Cancelar]  [Registrar]      │
└─────────────────────────────────┘
```

### Pantalla de Error
```
┌─────────────────────────────────┐
│              ⚠️                 │
│         Error del Sistema       │
│   Ha ocurrido un error...       │
│                                 │
│  Detalles del Error:            │
│  Código: ERR-001               │
│  Hora: 2024-01-15 10:30:00     │
│                                 │
│  [Volver]  [Reintentar]         │
└─────────────────────────────────┘
```

## 🎯 Próximos Pasos

Para convertir estos prototipos en una aplicación funcional, se recomienda:

1. **Backend**: Implementar API REST para autenticación y registro
2. **Base de Datos**: Diseñar esquema para usuarios y datos contables
3. **Seguridad**: Implementar autenticación JWT y validaciones del servidor
4. **Dashboard**: Crear pantalla principal del sistema contable
5. **Módulos**: Desarrollar funcionalidades contables específicas

## 📞 Soporte

Para consultas sobre los prototipos o implementación, contacta al equipo de desarrollo.

---

**ContaTienda** - Software Contable Web  
Versión de Prototipos 1.0