const axios = require('axios')
const { request, response } = require('express')

// Configuración de variables de entorno
const BASE_URL = process.env.TMDB_BASE_URL
const ACCESS_TOKEN = process.env.TMDB_ACCESS_TOKEN
const DEFAULT_LANGUAGE = 'es-ES'
const MOVIES_LIMIT = 70 // limite de lista de peliculas

// Creación de una instancia de axios con configuración predeterminada
const axiosInstance = axios.create({
  baseURL: BASE_URL,
  headers: {
    Authorization: `Bearer ${ACCESS_TOKEN}`,
    accept: 'application/json'
  }
})

// Función para manejar errores de manera uniforme
const handleError = (res, error, customMessage) => {
  console.error(error)
  const status = error.response?.status || 500
  const message = status === 404 ? 'No encontrado' : customMessage || 'Error inesperado'
  res.status(status).json({ msg: 'Error', error: message })
}

// Función para mapear los resultados de películas a un formato estandarizado
const mapMovieResults = (results) => results.map(({ id, title, release_date, overview, vote_average }) => ({
  key: `/movies/${id}`,
  title,
  releaseDate: release_date,
  overview,
  voteAverage: vote_average
}))


// Función para realizar peticiones a la API de TMDB con límite
const getFromAPI = async (endpoint, params = {}) => {
  let allResults = []
  let page = 1

  while (allResults.length < MOVIES_LIMIT) {
    const response = await axiosInstance.get(endpoint, {
      params: { ...params, language: DEFAULT_LANGUAGE, page }
    })
    allResults = allResults.concat(response.data.results)
    if (response.data.total_pages === page || allResults.length >= MOVIES_LIMIT) break
    page++
  }

  return {
    results: allResults.slice(0, MOVIES_LIMIT),
    total_results: Math.min(allResults.length, MOVIES_LIMIT)
  }
}

// Controlador para obtener películas populares
const getPopularMovies = async (req = request, res = response) => {
  try {
    const data = await getFromAPI('/movie/popular')
    res.status(200).json({
      msg: 'Ok',
      data: mapMovieResults(data.results),
      total_results: data.total_results
    })
  } catch (error) {
    handleError(res, error, 'Error al obtener la lista de películas populares')
  }
}

// Controlador para obtener una película por ID
const getMovieById = async (req = request, res = response) => {
  try {
    const { id } = req.params
    const data = await axiosInstance.get(`/movie/${id}`, {
      params: { language: DEFAULT_LANGUAGE }
    })

    if (!data || !data.data) {
      return res.status(404).json({
        msg: 'Error',
        error: 'Película no encontrada'
      })
    }

    const { title, release_date, overview, vote_average, genres } = data.data
    res.status(200).json({
      msg: 'Ok',
      data: {
        key: `/movies/${id}`,
        title,
        releaseDate: release_date,
        overview,
        voteAverage: vote_average,
        genres: genres ? genres.map(genre => genre.name) : []
      }
    })
  } catch (error) {
    handleError(res, error, 'Error al obtener la información de la película')
  }
}

// Controlador para buscar películas
const searchMovies = async (req = request, res = response) => {
  try {
    const { query } = req.query
    if (!query) {
      return res.status(400).json({ msg: 'Error', error: 'Debes proporcionar un término de búsqueda' })
    }
    const data = await getFromAPI('/search/movie', { query, page: 1 })
    res.status(200).json({ msg: 'Ok', data: mapMovieResults(data.results) })
  } catch (error) {
    handleError(res, error, 'Error al buscar películas')
  }
}

// Controlador para obtener películas por género
const getMoviesByGenre = async (req = request, res = response) => {
  try {
    const { genre = '' } = req.query
    if (!genre) {
      return res.status(400).json({ msg: 'Error', error: 'Debes proporcionar un género para filtrar las películas' })
    }

    // Función para normalizar texto, incluyendo manejo de espacios
    const normalizeText = (text) => {
      return text.toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/\s+/g, ' ')
        .trim()
    }

    const genresResponse = await axiosInstance.get('/genre/movie/list', {
      params: { language: DEFAULT_LANGUAGE }
    })

    if (!genresResponse.data || !genresResponse.data.genres) {
      return res.status(500).json({ msg: 'Error', error: 'No se pudo obtener la lista de géneros' })
    }

    const normalizedSearchGenre = normalizeText(genre)

    const genreFound = genresResponse.data.genres.find(g =>
      normalizeText(g.name) === normalizedSearchGenre
    )

    if (!genreFound) {
      return res.status(404).json({ msg: 'Error', error: 'Género no encontrado' })
    }

    const moviesData = await getFromAPI('/discover/movie', { with_genres: genreFound.id, page: 1 })
    res.status(200).json({ msg: 'Ok', data: mapMovieResults(moviesData.results) })
  } catch (error) {
    handleError(res, error, 'Error al obtener las películas por género')
  }
}

// Controlador para obtener la lista de géneros
const getGenresList = async (req = request, res = response) => {
  try {
    const response = await axiosInstance.get('/genre/movie/list', {
      params: { language: DEFAULT_LANGUAGE }
    })

    if (!response.data || !response.data.genres) {
      return res.status(500).json({ msg: 'Error', error: 'No se pudo obtener la lista de géneros' })
    }

    res.status(200).json({ msg: 'Ok', data: response.data.genres })
  } catch (error) {
    console.error('Error en getGenresList:', error)
    handleError(res, error, 'Error al obtener la lista de géneros')
  }
}

module.exports = {
  getPopularMovies,
  getMovieById,
  searchMovies,
  getGenresList,
  getMoviesByGenre
}
