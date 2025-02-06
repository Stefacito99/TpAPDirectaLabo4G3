const { Router } = require('express')
const {
  getPopularMovies,
  getMovieById,
  getMoviesByGenre,
  getGenresList,
  searchMovies
} = require('../controllers/movies')
const router = Router()

// Get para Peliculas Populares
router.get('/', getPopularMovies)

// Get para Lista de géneros y peliculas por género
router.get('/generos', (req, res, next) => {
  if (req.query.genre) {
    getMoviesByGenre(req, res, next)
  } else {
    getGenresList(req, res, next)
  }
})

// Get Buscar Peliculas por Título
router.get('/buscar', searchMovies)

// Get para Película por ID
router.get('/:id', getMovieById)

module.exports = router
