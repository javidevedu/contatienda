/**
 * ContaTienda - Aplicación de gestión contable para tiendas de barrio
 * Desarrollado con JavaScript puro, sin dependencias externas
 */

// Datos de usuarios predefinidos
const usuarios = [
    { username: 'admin1', password: 'password1' },
    { username: 'admin2', password: 'password2' }
];

// Datos en memoria (se perderán al recargar la página)
let ventas = [];
let egresos = [];
let deudas = [];
let usuarioActual = null;

// Elementos DOM
document.addEventListener('DOMContentLoaded', () => {
    // Inicializar la aplicación
    inicializarEventos();
    establecerFechaActual();
});

/**
 * Inicializa todos los eventos de la aplicación
 */
function inicializarEventos() {
    // Eventos de autenticación
    document.getElementById('login-btn').addEventListener('click', autenticarUsuario);
    document.getElementById('logout-btn').addEventListener('click', cerrarSesion);
    
    // Eventos de navegación
    const menuLinks = document.querySelectorAll('.menu a');
    menuLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            cambiarVista(link.getAttribute('data-view'));
        });
    });
    
    // Eventos de formularios
    document.getElementById('registrar-venta-btn').addEventListener('click', registrarVenta);
    document.getElementById('registrar-egreso-btn').addEventListener('click', registrarEgreso);
    document.getElementById('registrar-deuda-btn').addEventListener('click', registrarDeuda);
}

/**
 * Establece la fecha actual en los campos de fecha
 */
function establecerFechaActual() {
    const fechaActual = new Date().toISOString().split('T')[0];
    document.getElementById('venta-fecha').value = fechaActual;
    document.getElementById('egreso-fecha').value = fechaActual;
    document.getElementById('deuda-fecha').value = fechaActual;
}

/**
 * Autenticación de usuario
 */
function autenticarUsuario() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const errorElement = document.getElementById('login-error');
    
    // Validar campos obligatorios
    if (!username || !password) {
        errorElement.textContent = 'Por favor, complete todos los campos';
        return;
    }
    
    // Verificar credenciales
    const usuarioValido = usuarios.find(u => 
        u.username === username && u.password === password
    );
    
    if (usuarioValido) {
        // Autenticación exitosa
        usuarioActual = username;
        document.getElementById('login-screen').classList.remove('active');
        document.getElementById('main-screen').classList.add('active');
        cambiarVista('dashboard');
        actualizarDashboard();
    } else {
        // Autenticación fallida
        errorElement.textContent = 'Credenciales inválidas';
    }
}

/**
 * Cierra la sesión del usuario
 */
function cerrarSesion() {
    usuarioActual = null;
    document.getElementById('main-screen').classList.remove('active');
    document.getElementById('login-screen').classList.add('active');
    document.getElementById('username').value = '';
    document.getElementById('password').value = '';
    document.getElementById('login-error').textContent = '';
}

/**
 * Cambia entre las diferentes vistas de la aplicación
 */
function cambiarVista(vista) {
    // Ocultar todas las vistas
    document.querySelectorAll('.view').forEach(v => {
        v.classList.remove('active');
    });
    
    // Mostrar la vista seleccionada
    document.getElementById(`${vista}-view`).classList.add('active');
    
    // Actualizar menú
    document.querySelectorAll('.menu a').forEach(link => {
        link.classList.remove('active');
    });
    document.querySelector(`.menu a[data-view="${vista}"]`).classList.add('active');
    
    // Actualizar datos según la vista
    if (vista === 'dashboard') {
        actualizarDashboard();
    } else if (vista === 'ventas') {
        actualizarTablaVentas();
    } else if (vista === 'egresos') {
        actualizarTablaEgresos();
    } else if (vista === 'deudas') {
        actualizarTablaDeudas();
    }
}

/**
 * Actualiza el dashboard con los datos actuales
 */
function actualizarDashboard() {
    // Calcular totales
    const totalVentas = ventas.reduce((sum, v) => sum + v.monto, 0);
    const totalEgresos = egresos.reduce((sum, e) => sum + e.monto, 0);
    const totalDeudas = deudas
        .filter(d => d.estado === 'pendiente')
        .reduce((sum, d) => sum + d.monto, 0);
    
    // Actualizar totales en el dashboard
    document.getElementById('total-ventas').textContent = `$${totalVentas}`;
    document.getElementById('total-egresos').textContent = `$${totalEgresos}`;
    document.getElementById('total-deudas').textContent = `$${totalDeudas}`;
    
    // Actualizar tablas de últimas ventas
    const tbodyVentas = document.querySelector('#ultimas-ventas tbody');
    tbodyVentas.innerHTML = '';
    
    // Mostrar las últimas 5 ventas
    ventas.slice(-5).reverse().forEach(venta => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${formatearFecha(venta.fecha)}</td>
            <td>$${venta.monto}</td>
            <td>${venta.notas || '-'}</td>
        `;
        tbodyVentas.appendChild(tr);
    });
    
    // Actualizar tablas de últimos egresos
    const tbodyEgresos = document.querySelector('#ultimos-egresos tbody');
    tbodyEgresos.innerHTML = '';
    
    // Mostrar los últimos 5 egresos
    egresos.slice(-5).reverse().forEach(egreso => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${formatearFecha(egreso.fecha)}</td>
            <td>$${egreso.monto}</td>
            <td>${egreso.descripcion || '-'}</td>
        `;
        tbodyEgresos.appendChild(tr);
    });
}

/**
 * Registra una nueva venta
 */
function registrarVenta() {
    const monto = parseFloat(document.getElementById('venta-monto').value);
    const fecha = document.getElementById('venta-fecha').value;
    const notas = document.getElementById('venta-notas').value;
    const errorElement = document.getElementById('venta-error');
    
    // Validar campos obligatorios
    if (!monto || !fecha) {
        errorElement.textContent = 'Por favor, complete los campos obligatorios (monto y fecha)';
        return;
    }
    
    if (monto <= 0) {
        errorElement.textContent = 'El monto debe ser mayor que cero';
        return;
    }
    
    // Crear nueva venta
    const nuevaVenta = {
        id: Date.now(), // ID único basado en timestamp
        monto,
        fecha,
        notas
    };
    
    // Agregar a la lista de ventas
    ventas.push(nuevaVenta);
    
    // Limpiar formulario
    document.getElementById('venta-monto').value = '';
    document.getElementById('venta-notas').value = '';
    errorElement.textContent = '';
    
    // Actualizar tabla de ventas
    actualizarTablaVentas();
}

/**
 * Actualiza la tabla de ventas
 */
function actualizarTablaVentas() {
    const tbody = document.querySelector('#tabla-ventas tbody');
    tbody.innerHTML = '';
    
    ventas.forEach(venta => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${formatearFecha(venta.fecha)}</td>
            <td>$${venta.monto}</td>
            <td>${venta.notas || '-'}</td>
            <td>
                <button class="action-btn delete-btn" data-id="${venta.id}">Eliminar</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
    
    // Agregar eventos a los botones de eliminar
    document.querySelectorAll('#tabla-ventas .delete-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = parseInt(btn.getAttribute('data-id'));
            eliminarVenta(id);
        });
    });
}

/**
 * Elimina una venta por su ID
 */
function eliminarVenta(id) {
    ventas = ventas.filter(v => v.id !== id);
    actualizarTablaVentas();
    actualizarDashboard();
}

/**
 * Registra un nuevo egreso
 */
function registrarEgreso() {
    const monto = parseFloat(document.getElementById('egreso-monto').value);
    const fecha = document.getElementById('egreso-fecha').value;
    const descripcion = document.getElementById('egreso-descripcion').value;
    const errorElement = document.getElementById('egreso-error');
    
    // Validar campos obligatorios
    if (!monto || !fecha || !descripcion) {
        errorElement.textContent = 'Por favor, complete todos los campos';
        return;
    }
    
    if (monto <= 0) {
        errorElement.textContent = 'El monto debe ser mayor que cero';
        return;
    }
    
    // Crear nuevo egreso
    const nuevoEgreso = {
        id: Date.now(), // ID único basado en timestamp
        monto,
        fecha,
        descripcion
    };
    
    // Agregar a la lista de egresos
    egresos.push(nuevoEgreso);
    
    // Limpiar formulario
    document.getElementById('egreso-monto').value = '';
    document.getElementById('egreso-descripcion').value = '';
    errorElement.textContent = '';
    
    // Actualizar tabla de egresos
    actualizarTablaEgresos();
}

/**
 * Actualiza la tabla de egresos
 */
function actualizarTablaEgresos() {
    const tbody = document.querySelector('#tabla-egresos tbody');
    tbody.innerHTML = '';
    
    egresos.forEach(egreso => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${formatearFecha(egreso.fecha)}</td>
            <td>$${egreso.monto}</td>
            <td>${egreso.descripcion}</td>
            <td>
                <button class="action-btn delete-btn" data-id="${egreso.id}">Eliminar</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
    
    // Agregar eventos a los botones de eliminar
    document.querySelectorAll('#tabla-egresos .delete-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = parseInt(btn.getAttribute('data-id'));
            eliminarEgreso(id);
        });
    });
}

/**
 * Elimina un egreso por su ID
 */
function eliminarEgreso(id) {
    egresos = egresos.filter(e => e.id !== id);
    actualizarTablaEgresos();
    actualizarDashboard();
}

/**
 * Registra una nueva deuda
 */
function registrarDeuda() {
    const comprador = document.getElementById('deuda-comprador').value;
    const monto = parseFloat(document.getElementById('deuda-monto').value);
    const fecha = document.getElementById('deuda-fecha').value;
    const errorElement = document.getElementById('deuda-error');
    
    // Validar campos obligatorios
    if (!comprador || !monto || !fecha) {
        errorElement.textContent = 'Por favor, complete todos los campos';
        return;
    }
    
    if (monto <= 0) {
        errorElement.textContent = 'El monto debe ser mayor que cero';
        return;
    }
    
    // Crear nueva deuda
    const nuevaDeuda = {
        id: Date.now(), // ID único basado en timestamp
        comprador,
        monto,
        fecha,
        estado: 'pendiente'
    };
    
    // Agregar a la lista de deudas
    deudas.push(nuevaDeuda);
    
    // Limpiar formulario
    document.getElementById('deuda-comprador').value = '';
    document.getElementById('deuda-monto').value = '';
    errorElement.textContent = '';
    
    // Actualizar tabla de deudas
    actualizarTablaDeudas();
}

/**
 * Actualiza la tabla de deudas
 */
function actualizarTablaDeudas() {
    const tbody = document.querySelector('#tabla-deudas tbody');
    tbody.innerHTML = '';
    
    deudas.forEach(deuda => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${deuda.comprador}</td>
            <td>${formatearFecha(deuda.fecha)}</td>
            <td>$${deuda.monto}</td>
            <td>${deuda.estado === 'pendiente' ? 'Pendiente' : 'Pagado'}</td>
            <td>
                ${deuda.estado === 'pendiente' ? 
                    `<button class="action-btn pay-btn" data-id="${deuda.id}">Marcar Pagado</button>` : ''}
                <button class="action-btn delete-btn" data-id="${deuda.id}">Eliminar</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
    
    // Agregar eventos a los botones
    document.querySelectorAll('#tabla-deudas .pay-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = parseInt(btn.getAttribute('data-id'));
            marcarDeudaPagada(id);
        });
    });
    
    document.querySelectorAll('#tabla-deudas .delete-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = parseInt(btn.getAttribute('data-id'));
            eliminarDeuda(id);
        });
    });
}

/**
 * Marca una deuda como pagada
 */
function marcarDeudaPagada(id) {
    const deuda = deudas.find(d => d.id === id);
    if (deuda) {
        deuda.estado = 'pagado';
        actualizarTablaDeudas();
        actualizarDashboard();
    }
}

/**
 * Elimina una deuda por su ID
 */
function eliminarDeuda(id) {
    deudas = deudas.filter(d => d.id !== id);
    actualizarTablaDeudas();
    actualizarDashboard();
}

/**
 * Formatea una fecha en formato YYYY-MM-DD a DD/MM/YYYY
 */
function formatearFecha(fechaStr) {
    if (!fechaStr) return '-';
    
    const partes = fechaStr.split('-');
    if (partes.length !== 3) return fechaStr;
    
    return `${partes[2]}/${partes[1]}/${partes[0]}`;
}