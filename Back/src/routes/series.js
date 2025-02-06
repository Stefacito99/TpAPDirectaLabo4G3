// Rutas para series - Stefano
const { Router } = require('express')
const { getSeries, getSeriePorId, getSeriesPorGenero } = require('../controllers/series')
const rutas = Router()

// Listado general de series (máximo 50 por página)
rutas.get('/', getSeries)

// Filtrar series por género
rutas.get('/genero', getSeriesPorGenero)

// Obtener una serie por ID
rutas.get('/:id', getSeriePorId)

module.exports = rutas
