// Rutas para libros. Carla
const { Router } = require('express')
const { getLibros, getLibrosPorSubjects, getLibroPorId } = require('../controllers/books')
const rutas = Router()

// Listado general de libros
rutas.get('/', getLibros)

// Filtrar libros por subject. Tuve que usar otro endpoint por la inconsistencia de Open Library en sus registros.
rutas.get('/subject', getLibrosPorSubjects)

// Obtener un libro por ID
rutas.get('/:id', getLibroPorId)

module.exports = rutas
