// ===== NAVEGACIÓN ENTRE PANTALLAS =====
function showScreen(screenId) {
    // Ocultar todas las pantallas
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => {
        screen.classList.remove('active');
    });
    
    // Mostrar la pantalla seleccionada
    const targetScreen = document.getElementById(screenId);
    if (targetScreen) {
        targetScreen.classList.add('active');
    }
}

// ===== FUNCIONALIDAD DE LOGIN =====
document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const cedula = document.getElementById('cedula').value;
    const password = document.getElementById('password').value;
    const errorMessage = document.getElementById('login-error');
    
    // Validar que los campos no estén vacíos
    if (!cedula || !password) {
        showErrorMessage('login-error', 'Por favor, completa todos los campos.');
        return;
    }
    
    // Simular validación (en un sistema real, esto sería una llamada al servidor)
    if (cedula === '12345678' && password === 'password') {
        // Login exitoso
        showSuccessMessage('¡Bienvenido a ContaTienda!');
        // Aquí redirigirías al dashboard principal
    } else {
        // Mostrar error
        showErrorMessage('login-error', 'Cédula o contraseña incorrectos. Por favor, verifica tus datos.');
    }
});

// ===== FUNCIONALIDAD DE REGISTRO =====
document.getElementById('registerForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const cedula = document.getElementById('regCedula').value;
    const password = document.getElementById('regPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    // Validaciones básicas
    if (!validateRegistration(cedula, password, confirmPassword)) {
        return;
    }
    
    // Simular registro exitoso
    showSuccessMessage('¡Usuario registrado exitosamente!');
    
    // Limpiar formulario
    document.getElementById('registerForm').reset();
    
    // Redirigir al login después de 2 segundos
    setTimeout(() => {
        showScreen('login-screen');
    }, 2000);
});

// ===== VALIDACIÓN DE REGISTRO =====
function validateRegistration(cedula, password, confirmPassword) {
    const errorElement = document.getElementById('register-error');
    let isValid = true;
    let errorMessage = '';
    
    // Validar cédula (formato básico)
    if (!/^\d{7,10}$/.test(cedula)) {
        errorMessage += 'La cédula debe contener entre 7 y 10 dígitos. ';
        isValid = false;
    }
    
    // Validar contraseña
    if (password.length < 6) {
        errorMessage += 'La contraseña debe tener al menos 6 caracteres. ';
        isValid = false;
    }
    
    // Validar confirmación de contraseña
    if (password !== confirmPassword) {
        errorMessage += 'Las contraseñas no coinciden. ';
        isValid = false;
    }
    
    // Validar que la cédula no esté vacía
    if (!cedula.trim()) {
        errorMessage += 'La cédula es obligatoria. ';
        isValid = false;
    }
    
    // Validar que la contraseña no esté vacía
    if (!password.trim()) {
        errorMessage += 'La contraseña es obligatoria. ';
        isValid = false;
    }
    
    if (!isValid) {
        showErrorMessage('register-error', errorMessage);
    }
    
    return isValid;
}

// ===== FUNCIONALIDAD DE PANTALLA DE ERROR =====
function showErrorScreen(message, errorCode = 'ERR-001') {
    showScreen('error-screen');
    
    // Actualizar contenido del error
    document.getElementById('error-message').textContent = message;
    document.getElementById('error-code').textContent = errorCode;
    document.getElementById('error-time').textContent = new Date().toLocaleString();
}

function retryOperation() {
    // Simular reintento de operación
    showSuccessMessage('Reintentando operación...');
    
    // Simular que la operación falla de nuevo
    setTimeout(() => {
        showErrorScreen('La operación falló nuevamente. Por favor, contacta al soporte técnico.', 'ERR-002');
    }, 2000);
}

// ===== FUNCIONES DE UTILIDAD =====
function showErrorMessage(elementId, message) {
    const errorElement = document.getElementById(elementId);
    errorElement.textContent = message;
    errorElement.classList.remove('hidden');
    
    // Ocultar mensaje después de 5 segundos
    setTimeout(() => {
        errorElement.classList.add('hidden');
    }, 5000);
}

function showSuccessMessage(message) {
    // Crear notificación temporal de éxito
    const notification = document.createElement('div');
    notification.className = 'success-notification';
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: var(--success-color);
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        z-index: 1000;
        animation: slideDown 0.3s ease-out;
    `;
    
    document.body.appendChild(notification);
    
    // Remover notificación después de 3 segundos
    setTimeout(() => {
        notification.style.animation = 'slideUp 0.3s ease-out';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// ===== VALIDACIÓN EN TIEMPO REAL =====
document.addEventListener('DOMContentLoaded', function() {
    // Validación de cédula en tiempo real (login)
    const cedulaInput = document.getElementById('cedula');
    if (cedulaInput) {
        cedulaInput.addEventListener('input', function() {
            const value = this.value;
            if (value && !/^\d*$/.test(value)) {
                this.value = value.replace(/\D/g, '');
            }
        });
    }
    
    // Validación de cédula en tiempo real (registro)
    const regCedulaInput = document.getElementById('regCedula');
    if (regCedulaInput) {
        regCedulaInput.addEventListener('input', function() {
            const value = this.value;
            if (value && !/^\d*$/.test(value)) {
                this.value = value.replace(/\D/g, '');
            }
        });
    }
    
    // Validación de confirmación de contraseña en tiempo real
    const passwordInput = document.getElementById('regPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    
    if (passwordInput && confirmPasswordInput) {
        function validatePasswordMatch() {
            if (confirmPasswordInput.value && passwordInput.value !== confirmPasswordInput.value) {
                confirmPasswordInput.style.borderColor = 'var(--error-color)';
            } else {
                confirmPasswordInput.style.borderColor = 'var(--border-color)';
            }
        }
        
        passwordInput.addEventListener('input', validatePasswordMatch);
        confirmPasswordInput.addEventListener('input', validatePasswordMatch);
    }
});

// ===== ANIMACIONES CSS ADICIONALES =====
const style = document.createElement('style');
style.textContent = `
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateX(-50%) translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }
    }
    
    @keyframes slideUp {
        from {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }
        to {
            opacity: 0;
            transform: translateX(-50%) translateY(-20px);
        }
    }
`;
document.head.appendChild(style);

// ===== SIMULACIÓN DE ERRORES PARA DEMOSTRACIÓN =====
function simulateError() {
    const errorMessages = [
        'Error de conexión con la base de datos',
        'Servicio temporalmente no disponible',
        'Error de validación de datos',
        'Tiempo de sesión agotado',
        'Error interno del servidor'
    ];
    
    const randomMessage = errorMessages[Math.floor(Math.random() * errorMessages.length)];
    const errorCode = 'ERR-' + String(Math.floor(Math.random() * 900) + 100);
    
    showErrorScreen(randomMessage, errorCode);
}

// ===== INICIALIZACIÓN =====
document.addEventListener('DOMContentLoaded', function() {
    // Mostrar pantalla de login por defecto
    showScreen('login-screen');
    
    // Agregar funcionalidad de teclado
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            // Presionar ESC para volver al login
            showScreen('login-screen');
        }
    });
});
