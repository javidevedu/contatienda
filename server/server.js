const express = require('express');
const cors = require('cors');
require('dotenv').config();
const db = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// Rutas ventas
app.get('/api/ventas', async (req, res) => {
    const ventas = await db('ventas').select('*').orderBy('fecha', 'asc');
    res.json(ventas);
});
app.post('/api/ventas', async (req, res) => {
    const { monto, fecha, notas } = req.body;
    const [id] = await db('ventas').insert({ monto, fecha, notas });
    res.json({ id });
});
app.delete('/api/ventas/:id', async (req, res) => {
    await db('ventas').where({ id: req.params.id }).del();
    res.sendStatus(204);
});

// Rutas egresos
app.get('/api/egresos', async (req, res) => {
    const egresos = await db('egresos').select('*').orderBy('fecha', 'asc');
    res.json(egresos);
});
app.post('/api/egresos', async (req, res) => {
    const { monto, fecha, descripcion } = req.body;
    const [id] = await db('egresos').insert({ monto, fecha, descripcion });
    res.json({ id });
});
app.delete('/api/egresos/:id', async (req, res) => {
    await db('egresos').where({ id: req.params.id }).del();
    res.sendStatus(204);
});

// Rutas deudas
app.get('/api/deudas', async (req, res) => {
    const deudas = await db('deudas').select('*').orderBy('fecha', 'asc');
    res.json(deudas);
});
app.post('/api/deudas', async (req, res) => {
    const { comprador, monto, fecha } = req.body;
    const [id] = await db('deudas').insert({ comprador, monto, fecha, estado: 'pendiente' });
    res.json({ id });
});
app.put('/api/deudas/:id/pagar', async (req, res) => {
    await db('deudas').where({ id: req.params.id }).update({ estado: 'pagado' });
    res.sendStatus(200);
});
app.delete('/api/deudas/:id', async (req, res) => {
    await db('deudas').where({ id: req.params.id }).del();
    res.sendStatus(204);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API escuchando en ${PORT}`));