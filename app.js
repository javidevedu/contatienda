(() => {
  "use strict";

  // Simple in-memory auth; no registration
  const USERS = {
    "u123": "123",
    "u1234": "1234",
    "admin": "admin"
  };

  // State + localStorage persistence
  const storageKey = {
    session: "ct_session",
    ventas: "ct_ventas",
    egresos: "ct_egresos",
    deudas: "ct_deudas"
  };

  // Backend API URL (ajusta según tu hosting)
  const API_BASE = './Php/';
  let useBackend = true; // Siempre intentar usar el backend cuando hay sesión
  let lastBackendCheck = 0;

  /** @typedef {{ id:string|number, monto:number, fecha:string, notas?:string }} Venta */
  /** @typedef {{ id:string|number, monto:number, fecha:string, descripcion:string }} Egreso */
  /** @typedef {{ id:string|number, comprador:string, monto:number, fecha:string, estado:"pagado"|"pendiente" }} Deuda */

  /** @type {Venta[]} */
  let ventas = [];
  /** @type {Egreso[]} */
  let egresos = [];
  /** @type {Deuda[]} */
  let deudas = [];

  function readArray(key){
    try {
      const raw = localStorage.getItem(key);
      return raw ? JSON.parse(raw) : [];
    } catch { return []; }
  }
  function writeArray(key, arr){
    localStorage.setItem(key, JSON.stringify(arr));
  }

  // API functions
  async function apiGet(endpoint){
    try {
      const res = await fetch(API_BASE + endpoint);
      if(!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json();
      return Array.isArray(data) ? data : [];
    } catch(err){
      console.warn(`API GET ${endpoint} failed:`, err);
      // No desactivar backend permanentemente, solo marcar como fallido temporalmente
      const key = endpoint.replace('.php','');
      const storageMap = { 'ventas': storageKey.ventas, 'egresos': storageKey.egresos, 'deudas': storageKey.deudas };
      return readArray(storageMap[key] || storageKey.ventas) || [];
    }
  }

  async function apiPost(endpoint, body, retries = 3){
    for(let i = 0; i < retries; i++){
      try {
        const res = await fetch(API_BASE + endpoint, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body)
        });
        if(!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();
        return data;
      } catch(err){
        console.warn(`API POST ${endpoint} attempt ${i+1}/${retries} failed:`, err);
        if(i < retries - 1){
          // Esperar antes de reintentar (exponential backoff)
          await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
        }
      }
    }
    return null; // Falló después de todos los reintentos
  }

  async function apiDelete(endpoint, id){
    try {
      const res = await fetch(`${API_BASE}${endpoint}?id=${id}`, { method: 'DELETE' });
      if(!res.ok) throw new Error(`HTTP ${res.status}`);
      return await res.json();
    } catch(err){
      console.warn(`API DELETE ${endpoint} failed:`, err);
      // No desactivar backend permanentemente
      return null;
    }
  }

  async function loadAllData(forceBackend = false){
    // Si hay sesión, SIEMPRE intentar backend primero (sin importar errores previos)
    const shouldUseBackend = forceBackend || isAuthenticated();
    
    if(shouldUseBackend){
      try {
        const [v, e, d] = await Promise.all([
          apiGet('ventas.php'),
          apiGet('egresos.php'),
          apiGet('deudas.php')
        ]);
        ventas = v.map(adaptVenta);
        egresos = e.map(adaptEgreso);
        deudas = d.map(adaptDeuda);
        // Sync to localStorage as backup ONLY
        writeArray(storageKey.ventas, ventas);
        writeArray(storageKey.egresos, egresos);
        writeArray(storageKey.deudas, deudas);
        useBackend = true; // Re-habilitar backend si funcionó
        lastBackendCheck = Date.now();
        return true; // Éxito
      } catch(err){
        console.warn('Failed to load from backend, using localStorage:', err);
        // Si hay sesión, no desactivar backend permanentemente - seguir intentando
        // Solo usar localStorage como fallback temporal
        const localData = {
          ventas: readArray(storageKey.ventas),
          egresos: readArray(storageKey.egresos),
          deudas: readArray(storageKey.deudas)
        };
        ventas = localData.ventas;
        egresos = localData.egresos;
        deudas = localData.deudas;
        // Si no hay sesión y falló, entonces sí desactivar backend
        if(!isAuthenticated() && Date.now() - lastBackendCheck > 30000){
          useBackend = false;
        }
        return false; // Falló
      }
    } else {
      // Solo usar localStorage si no hay sesión
      ventas = readArray(storageKey.ventas);
      egresos = readArray(storageKey.egresos);
      deudas = readArray(storageKey.deudas);
      return false;
    }
  }

  function adaptVenta(v){ return { id: String(v.id), monto: parseFloat(v.monto), fecha: v.fecha, notas: v.notas || '' }; }
  function adaptEgreso(e){ return { id: String(e.id), monto: parseFloat(e.monto), fecha: e.fecha, descripcion: e.descripcion }; }
  function adaptDeuda(d){ return { id: String(d.id), comprador: d.comprador, monto: parseFloat(d.monto), fecha: d.fecha, estado: d.estado }; }

  function setSession(user){
    localStorage.setItem(storageKey.session, JSON.stringify({ user }));
  }
  function getSession(){
    try { return JSON.parse(localStorage.getItem(storageKey.session)||"null"); } catch { return null; }
  }
  function clearSession(){ localStorage.removeItem(storageKey.session); }
  function isAuthenticated(){
    const s = getSession();
    return !!(s && s.user && USERS[s.user]);
  }
  function forceLoginView(msg){
    if (msg) { loginError.textContent = msg; }
    appLayout.classList.add("hidden");
    loginView.classList.remove("hidden");
    document.body.classList.add('no-scroll');
  }

  // Elements
  const loginView = document.getElementById("login-view");
  const appLayout = document.getElementById("app-layout");
  const loginForm = document.getElementById("login-form");
  const loginError = document.getElementById("login-error");
  const logoutBtn = document.getElementById("logout-btn");
  const reloadBtn = document.getElementById("reload-btn");

  const navButtons = Array.from(document.querySelectorAll(".nav-item"));
  const sectionTitle = document.getElementById("section-title");

  // Dashboard totals
  const totalVentasEl = document.getElementById("total-ventas");
  const totalEgresosEl = document.getElementById("total-egresos");
  const totalDeudasEl = document.getElementById("total-deudas");
  const ultVentasBody = document.querySelector("#tabla-ult-ventas tbody");
  const ultEgresosBody = document.querySelector("#tabla-ult-egresos tbody");

  // Forms
  const formVenta = document.getElementById("form-venta");
  const ventaMsg = document.getElementById("venta-msg");
  const ventasBody = document.querySelector("#tabla-ventas tbody");

  const formEgreso = document.getElementById("form-egreso");
  const egresoMsg = document.getElementById("egreso-msg");
  const egresosBody = document.querySelector("#tabla-egresos tbody");

  const formDeuda = document.getElementById("form-deuda");
  const deudaMsg = document.getElementById("deuda-msg");
  const deudasBody = document.querySelector("#tabla-deudas tbody");

  // Views
  const views = {
    dashboard: document.getElementById("dashboard-view"),
    ventas: document.getElementById("ventas-view"),
    egresos: document.getElementById("egresos-view"),
    deudas: document.getElementById("deudas-view")
  };

  // Auth
  loginForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    const username = /** @type {HTMLInputElement} */(document.getElementById("username")).value.trim();
    const password = /** @type {HTMLInputElement} */(document.getElementById("password")).value;
    const valid = USERS[username] && USERS[username] === password;
    if(!valid){
      loginError.textContent = "Credenciales inválidas";
      return;
    }
    setSession(username);
    loginError.textContent = "";
    await mountApp();
  });

  logoutBtn.addEventListener("click", () => {
    clearSession();
    forceLoginView("");
  });

  reloadBtn.addEventListener("click", async () => {
    if(!isAuthenticated()) return;
    reloadBtn.textContent = "🔄 Cargando...";
    reloadBtn.disabled = true;
    await loadAllData(true);
    refresh();
    reloadBtn.textContent = "🔄 Recargar";
    reloadBtn.disabled = false;
  });

  async function mountApp(){
    loginView.classList.add("hidden");
    appLayout.classList.remove("hidden");
    document.body.classList.remove('no-scroll');
    await loadAllData();
    switchView("dashboard");
    renderAll();
  }

  // Navigation
  navButtons.forEach(btn => btn.addEventListener("click", () => {
    const target = btn.getAttribute("data-nav");
    if(!target) return;
    navButtons.forEach(b => b.classList.remove("active"));
    btn.classList.add("active");
    switchView(target);
  }));

  function switchView(key){
    if(!isAuthenticated()){
      forceLoginView("Inicia sesión para continuar");
      return;
    }
    Object.entries(views).forEach(([k, el]) => {
      if(k === key){ el.classList.remove("hidden"); sectionTitle.textContent = labelFor(k); }
      else { el.classList.add("hidden"); }
    });
  }
  function labelFor(k){
    switch(k){
      case "dashboard": return "Dashboard";
      case "ventas": return "Registrar Ventas";
      case "egresos": return "Registrar Egresos";
      case "deudas": return "Gestionar Deudas";
      default: return k;
    }
  }

  // Helpers
  function formatMoney(n){
    return new Intl.NumberFormat('es-CO', { style:'currency', currency:'COP', maximumFractionDigits:0 }).format(n);
  }
  function uid(){ return Math.random().toString(36).slice(2,10); }

  // Forms handlers
  formVenta.addEventListener("submit", async (e) => {
    e.preventDefault();
    if(!isAuthenticated()) { forceLoginView("Inicia sesión para continuar"); return; }
    const monto = Number((document.getElementById("venta-monto")).value);
    const fecha = (document.getElementById("venta-fecha")).value;
    const notas = (document.getElementById("venta-notas")).value.trim();
    if(!(monto > 0) || !fecha){ ventaMsg.textContent = "Completa los campos"; return; }
    
    ventaMsg.textContent = "Guardando en servidor...";
    
    // Si hay sesión, SIEMPRE guardar en el servidor SQL (con reintentos automáticos)
    if(isAuthenticated()){
      const result = await apiPost('ventas.php', { monto, fecha, notas }, 3);
      if(result && result.id){
        // Recargar TODOS los datos del servidor para tener la versión más actualizada
        await loadAllData(true);
        ventaMsg.textContent = "✓ Guardado en servidor";
      } else {
        // Si el servidor falla completamente, mostrar error pero NO guardar localmente
        // Los datos deben estar en el servidor para que todos los usuarios los vean
        ventaMsg.textContent = "✗ Error: No se pudo guardar en servidor. Verifica tu conexión.";
        ventaMsg.style.color = "var(--danger)";
        setTimeout(() => {
          ventaMsg.textContent = "";
          ventaMsg.style.color = "";
        }, 5000);
        return; // No continuar si falla el servidor
      }
    } else {
      // Solo localStorage si no hay sesión (no debería llegar aquí por el check de autenticación)
      ventaMsg.textContent = "Debes iniciar sesión para guardar";
      return;
    }
    
    (e.target).reset();
    setTodayDefault("venta-fecha");
    refresh();
    setTimeout(() => ventaMsg.textContent = "", 2000);
  });

  formEgreso.addEventListener("submit", async (e) => {
    e.preventDefault();
    if(!isAuthenticated()) { forceLoginView("Inicia sesión para continuar"); return; }
    const monto = Number((document.getElementById("egreso-monto")).value);
    const fecha = (document.getElementById("egreso-fecha")).value;
    const descripcion = (document.getElementById("egreso-desc")).value.trim();
    if(!(monto > 0) || !fecha || !descripcion){ egresoMsg.textContent = "Completa los campos"; return; }
    
    egresoMsg.textContent = "Guardando en servidor...";
    
    // Si hay sesión, SIEMPRE guardar en el servidor SQL (con reintentos automáticos)
    if(isAuthenticated()){
      const result = await apiPost('egresos.php', { monto, fecha, descripcion }, 3);
      if(result && result.id){
        // Recargar TODOS los datos del servidor
        await loadAllData(true);
        egresoMsg.textContent = "✓ Guardado en servidor";
      } else {
        // Si el servidor falla completamente, mostrar error pero NO guardar localmente
        egresoMsg.textContent = "✗ Error: No se pudo guardar en servidor. Verifica tu conexión.";
        egresoMsg.style.color = "var(--danger)";
        setTimeout(() => {
          egresoMsg.textContent = "";
          egresoMsg.style.color = "";
        }, 5000);
        return; // No continuar si falla el servidor
      }
    } else {
      egresoMsg.textContent = "Debes iniciar sesión para guardar";
      return;
    }
    
    (e.target).reset();
    setTodayDefault("egreso-fecha");
    refresh();
    setTimeout(() => egresoMsg.textContent = "", 2000);
  });

  formDeuda.addEventListener("submit", async (e) => {
    e.preventDefault();
    if(!isAuthenticated()) { forceLoginView("Inicia sesión para continuar"); return; }
    const comprador = (document.getElementById("deuda-comprador")).value.trim();
    const monto = Number((document.getElementById("deuda-monto")).value);
    const fecha = (document.getElementById("deuda-fecha")).value;
    const estado = (document.getElementById("deuda-estado")).value;
    if(!comprador || !(monto > 0) || !fecha){ deudaMsg.textContent = "Completa los campos"; return; }
    
    const estadoFinal = estado === 'pagado' ? 'pagado' : 'pendiente';
    
    deudaMsg.textContent = "Guardando en servidor...";
    
    // Si hay sesión, SIEMPRE guardar en el servidor SQL (con reintentos automáticos)
    if(isAuthenticated()){
      const result = await apiPost('deudas.php', { comprador, monto, fecha, estado: estadoFinal }, 3);
      if(result && result.id){
        // Recargar TODOS los datos del servidor
        await loadAllData(true);
        deudaMsg.textContent = "✓ Guardado en servidor";
      } else {
        // Si el servidor falla completamente, mostrar error pero NO guardar localmente
        deudaMsg.textContent = "✗ Error: No se pudo guardar en servidor. Verifica tu conexión.";
        deudaMsg.style.color = "var(--danger)";
        setTimeout(() => {
          deudaMsg.textContent = "";
          deudaMsg.style.color = "";
        }, 5000);
        return; // No continuar si falla el servidor
      }
    } else {
      deudaMsg.textContent = "Debes iniciar sesión para guardar";
      return;
    }
    
    (e.target).reset();
    setTodayDefault("deuda-fecha");
    refresh();
    setTimeout(() => deudaMsg.textContent = "", 2000);
  });

  function setTodayDefault(id){
    const el = document.getElementById(id);
    if(el) el.value = new Date().toISOString().slice(0,10);
  }

  // Renderers
  function renderAll(){
    renderTotals();
    renderTables();
    renderChart();
  }
  function refresh(){
    renderTotals();
    renderTables();
    renderChart();
  }

  function renderTotals(){
    const totalVentas = ventas.reduce((a,v) => a + v.monto, 0);
    const totalEgresos = egresos.reduce((a,v) => a + v.monto, 0);
    const totalDeudasPend = deudas.filter(d => d.estado === 'pendiente').reduce((a,v) => a + v.monto, 0);
    totalVentasEl.textContent = formatMoney(totalVentas);
    totalEgresosEl.textContent = formatMoney(totalEgresos);
    totalDeudasEl.textContent = formatMoney(totalDeudasPend);
  }

  function renderTables(){
    // Últimas 5
    ultVentasBody.innerHTML = ventas.slice(0,5).map(v => `<tr><td>${v.fecha}</td><td>${formatMoney(v.monto)}</td><td>${escapeHtml(v.notas||"")}</td></tr>`).join("");
    ultEgresosBody.innerHTML = egresos.slice(0,5).map(v => `<tr><td>${v.fecha}</td><td>${formatMoney(v.monto)}</td><td>${escapeHtml(v.descripcion)}</td></tr>`).join("");

    // Full tables with delete
    ventasBody.innerHTML = ventas.map(v => rowVenta(v)).join("");
    egresosBody.innerHTML = egresos.map(v => rowEgreso(v)).join("");
    deudasBody.innerHTML = deudas.map(v => rowDeuda(v)).join("");

    // bind deletes
    document.querySelectorAll('[data-del-venta]').forEach(btn => btn.addEventListener('click', async () => {
      const id = btn.getAttribute('data-del-venta');
      // Si hay sesión, SIEMPRE intentar eliminar en el servidor SQL
      if(isAuthenticated()){
        const result = await apiDelete('ventas.php', id);
        if(result){
          // Recargar todos los datos del servidor para tener la versión más actualizada
          await loadAllData(true);
        } else {
          // Si el servidor falla, mostrar error y NO eliminar localmente
          // Los datos deben estar sincronizados en el servidor
          alert('Error: No se pudo eliminar del servidor. Verifica tu conexión.');
          return; // No continuar si falla el servidor
        }
      } else {
        alert('Debes iniciar sesión para eliminar registros.');
        return;
      }
      refresh();
    }));
    document.querySelectorAll('[data-del-egreso]').forEach(btn => btn.addEventListener('click', async () => {
      const id = btn.getAttribute('data-del-egreso');
      // Si hay sesión, SIEMPRE intentar eliminar en el servidor SQL
      if(isAuthenticated()){
        const result = await apiDelete('egresos.php', id);
        if(result){
          await loadAllData(true);
        } else {
          // Si el servidor falla, mostrar error y NO eliminar localmente
          alert('Error: No se pudo eliminar del servidor. Verifica tu conexión.');
          return;
        }
      } else {
        alert('Debes iniciar sesión para eliminar registros.');
        return;
      }
      refresh();
    }));
    document.querySelectorAll('[data-del-deuda]').forEach(btn => btn.addEventListener('click', async () => {
      const id = btn.getAttribute('data-del-deuda');
      // Si hay sesión, SIEMPRE intentar eliminar en el servidor SQL
      if(isAuthenticated()){
        const result = await apiDelete('deudas.php', id);
        if(result){
          await loadAllData(true);
        } else {
          // Si el servidor falla, mostrar error y NO eliminar localmente
          alert('Error: No se pudo eliminar del servidor. Verifica tu conexión.');
          return;
        }
      } else {
        alert('Debes iniciar sesión para eliminar registros.');
        return;
      }
      refresh();
    }));
  }

  function rowVenta(v){
    return `<tr><td>${v.fecha}</td><td>${formatMoney(v.monto)}</td><td>${escapeHtml(v.notas||"")}</td><td class="row-actions"><button class="link delete" data-del-venta="${v.id}">Eliminar</button></td></tr>`;
  }
  function rowEgreso(v){
    return `<tr><td>${v.fecha}</td><td>${formatMoney(v.monto)}</td><td>${escapeHtml(v.descripcion)}</td><td class="row-actions"><button class="link delete" data-del-egreso="${v.id}">Eliminar</button></td></tr>`;
  }
  function rowDeuda(v){
    return `<tr><td>${escapeHtml(v.comprador)}</td><td>${v.fecha}</td><td>${formatMoney(v.monto)}</td><td>${v.estado}</td><td class="row-actions"><button class="link delete" data-del-deuda="${v.id}">Eliminar</button></td></tr>`;
  }

  function escapeHtml(s){
    return String(s).replace(/[&<>"']/g, ch => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[ch]));
  }

  // Chart: simple canvas bars for month sums
  function renderChart(){
    const canvas = document.getElementById('chart');
    if(!canvas) return;
    const ctx = canvas.getContext('2d');
    const width = canvas.width, height = canvas.height;
    ctx.clearRect(0,0,width,height);
    // compute last 6 months buckets
    const months = getLastMonthsLabels(6);
    const ventasByM = months.map(m => sumByMonth(ventas, m.key));
    const egresosByM = months.map(m => sumByMonth(egresos, m.key));
    // bounds
    const maxVal = Math.max(1, ...ventasByM, ...egresosByM);
    const padding = { top:20, right:20, bottom:40, left:50 };
    const chartW = width - padding.left - padding.right;
    const chartH = height - padding.top - padding.bottom;
    // axes
    ctx.strokeStyle = '#2b3157';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(padding.left, padding.top);
    ctx.lineTo(padding.left, padding.top + chartH);
    ctx.lineTo(padding.left + chartW, padding.top + chartH);
    ctx.stroke();
    // bars
    const groupWidth = chartW / months.length;
    const barWidth = Math.min(24, (groupWidth - 20) / 2);
    months.forEach((m, i) => {
      const x0 = padding.left + i * groupWidth + 20;
      const vH = (ventasByM[i] / maxVal) * (chartH - 10);
      const eH = (egresosByM[i] / maxVal) * (chartH - 10);
      // ventas bar (blue)
      ctx.fillStyle = '#5b8cff';
      ctx.fillRect(x0, padding.top + chartH - vH, barWidth, vH);
      // egresos bar (pink)
      ctx.fillStyle = '#ff6bb3';
      ctx.fillRect(x0 + barWidth + 10, padding.top + chartH - eH, barWidth, eH);
      // labels
      ctx.fillStyle = '#9aa4c7';
      ctx.font = '12px system-ui';
      ctx.textAlign = 'center';
      ctx.fillText(m.label, x0 + barWidth/2 + 5, padding.top + chartH + 16);
    });
    // y labels
    ctx.textAlign = 'right';
    for(let t=0;t<=4;t++){
      const val = Math.round((t/4)*maxVal);
      const y = padding.top + chartH - (t/4)*(chartH - 10);
      ctx.fillStyle = '#9aa4c7';
      ctx.fillText(shortMoney(val), padding.left - 8, y);
    }
  }

  function shortMoney(n){
    if(n >= 1e6) return (n/1e6).toFixed(1)+"M";
    if(n >= 1e3) return (n/1e3).toFixed(1)+"K";
    return String(n);
  }
  function getLastMonthsLabels(count){
    const now = new Date();
    const res = [];
    for(let i=count-1;i>=0;i--){
      const d = new Date(now.getFullYear(), now.getMonth()-i, 1);
      const key = d.toISOString().slice(0,7); // YYYY-MM
      const label = d.toLocaleString('es-ES', { month:'short' });
      res.push({ key, label });
    }
    return res;
  }
  function sumByMonth(items, yyyymm){
    return items.filter(it => (it.fecha||'').slice(0,7) === yyyymm)
                .reduce((a,v) => a + v.monto, 0);
  }

  // Session bootstrap
  (async () => {
    const session = getSession();
    if(session && session.user && USERS[session.user]){
      await mountApp();
    }
    else {
      document.body.classList.add('no-scroll');
    }
  })();
})();


