const axios = require('axios')
const { request, response } = require('express')
const BASE_URL = process.env.TVMAZE_BASE_URL || 'https://api.tvmaze.com'

// Obtener una lista general de series, con un límite de 50 registros
const getSeries = async (req = request, res = response) => {
  try {
    const { page = 1 } = req.query

    // Llamada al endpoint de TVMaze para obtener todas las series
    const response = await axios.get(`${BASE_URL}/shows?page=${page - 1}`) // TVMaze utiliza un índice basado en 0 para las páginas
    const showsData = response.data

    // Si no hay resultados, devolvemos un mensaje adecuado
    if (showsData.length === 0) {
      return res.status(404).json({
        status: 'error',
        msg: 'No se encontraron series en esta página.'
      })
    }

    // Limitar a 50 series por página
    const startIndex = (page - 1) * 50
    const limitedShows = showsData.slice(startIndex, startIndex + 50)

    const series = limitedShows.map((show) => ({
      id: show.id,
      name: show.name,
      genres: show.genres,
      premiered: show.premiered,
      status: show.status,
      summary: show.summary,
      network: show.network ? show.network.name : 'Unknown'
    }))

    res.status(200).json({
      status: 'ok',
      data: series,
      total: showsData.length, // Total de series devueltas
      page // Página actual
    })
  } catch (error) {
    console.error('Error al obtener las series: ', error)
    res.status(500).json({
      status: 'error',
      msg: 'Error inesperado al obtener la lista de series. Por favor, inténtalo de nuevo más tarde.'
    })
  }
}

// Obtener una serie por su ID
const getSeriePorId = async (req = request, res = response) => {
  const { id } = req.params

  try {
    const response = await axios.get(`${BASE_URL}/shows/${id}`)
    const { id: showId, name, genres, premiered, status, summary, network } = response.data

    res.status(200).json({
      status: 'ok',
      data: {
        id: showId,
        name,
        genres,
        premiered,
        status,
        summary,
        network: network ? network.name : 'Unknown'
      }
    })
  } catch (error) {
    res.status(404).json({
      status: 'error',
      msg: 'Serie no encontrada'
    })
  }
}

// Filtrar series por género
const getSeriesPorGenero = async (req = request, res = response) => {
  const { genre = '', page = 1 } = req.query

  if (!genre) {
    return res.status(400).json({
      status: 'error',
      msg: 'Debes proporcionar un género para filtrar las series'
    })
  }

  try {
    // Hacemos la búsqueda en la API de TVMaze
    const response = await axios.get(`${BASE_URL}/shows`) // Obtiene todas las series
    const showsData = response.data

    // Filtramos por género (asegurando que la comparación sea insensible a mayúsculas/minúsculas)
    const filteredSeries = showsData.filter((show) =>
      show.genres.map(g => g.toLowerCase()).includes(genre.toLowerCase())
    )

    // Limitar a 50 resultados por página
    const startIndex = (page - 1) * 50
    const series = filteredSeries.slice(startIndex, startIndex + 50).map((show) => ({
      id: show.id,
      name: show.name,
      genres: show.genres,
      premiered: show.premiered,
      status: show.status,
      summary: show.summary,
      network: show.network ? show.network.name : 'Unknown'
    }))

    // Si no hay series encontradas
    if (series.length === 0) {
      return res.status(404).json({
        status: 'error',
        msg: `No se encontraron series para el género "${genre}"`
      })
    }

    // Envío de las series filtradas
    res.status(200).json({
      status: 'ok',
      data: series
    })
  } catch (error) {
    console.error(error) // Log para depuración
    res.status(500).json({
      status: 'error',
      msg: 'Error inesperado al obtener las series por género'
    })
  }
}

module.exports = {
  getSeries,
  getSeriePorId,
  getSeriesPorGenero
}
