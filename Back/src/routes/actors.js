//NUEVO rutas para actores. Carla 
const express = require('express');
const router = express.Router();

// Importa las funciones del controller
const {
  getActores,
  getActorPorId,
  getActorPorNombre,
} = require('../controllers/actors');

// Define las rutas
router.get('/', getActores); // Listar actores populares
router.get('/name', getActorPorNombre); // Buscar/filtrar actor por nombre
router.get('/:id', getActorPorId); // Obtener actor por ID


module.exports = router;
