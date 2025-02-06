const axios = require('axios')
const { request, response } = require('express')
const baseUrl = process.env.OPEN_LIBRARY_BASE_URL || 'https://openlibrary.org'

// Obtener una lista general de libros. Punto 1 de la consigna
const getLibros = async (req = request, res = response) => {
  try {
    // Consulta a la API de Open Library para obtener una lista de libros. Decidí limitarla a 70
    const apiResponse = await axios.get(`${baseUrl}/search.json?q=books&limit=70`)
    const { docs } = apiResponse.data

    // Desestructuro para obtener únicamente los valores relevantes
    const libros = docs.map(({ key, title, author_name, first_publish_date, first_publish_year }) => ({
      key,
      title,
      authorName: author_name || ['Autor desconocido'],
      firstPublishDate: first_publish_date,
      firstPublishYear: first_publish_year
    }))

    res.status(200).json({
      msg: 'Ok',
      data: libros
    })
  } catch (error) {
    res.status(500).json({
      msg: 'Error',
      error: 'Error inesperado al obtener la lista general de libros'
    })
  }
}

// Filtro libros por el tema que tratan (subject). Punto 3 de la consigna
const getLibrosPorSubjects = async (req = request, res = response) => {
  const { subject = '' } = req.query

  if (!subject) {
    return res.status(400).json({
      msg: 'Error',
      error: 'Debes proporcionar un subject para filtrar los libros'
    })
  }

  try {
    const apiResponse = await axios.get(`${baseUrl}/subjects/${encodeURIComponent(subject)}.json?limit=70`)
    const { works = [] } = apiResponse.data

    // uso CamelCase para la variable local pero los campos que devuelve OpenLibrary
    // se mantienen en snake_case, porque así los devuelve la API
    const libros = works.map(({ key, title, authors, first_publish_date, first_publish_year }) => {
      let authorNames = []
      if (authors && authors.length > 0) {
        authorNames = authors.map(author => author.name || 'Autor desconocido')
      } else {
        authorNames = ['Autor desconocido']
      }

      return {
        key,
        title,
        authorName: authorNames,
        firstPublishDate: first_publish_date,
        firstPublishYear: first_publish_year
      }
    })

    if (libros.length === 0) {
      return res.status(404).json({
        msg: 'Error',
        error: 'No se encontraron libros para el subject especificado'
      })
    }

    res.status(200).json({
      msg: 'Ok',
      data: libros
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({
      msg: 'Error',
      error: 'Error al obtener los libros por subject'
    })
  }
}

// Buscar libro por ID: punto 1 de la consigna
const getLibroPorId = async (req = request, res = response) => {
  const { id } = req.params

  try {
    const apiResponse = await axios.get(`${baseUrl}/works/${id}.json`)
    const { key, title } = apiResponse.data

    res.status(200).json({
      msg: 'Ok',
      data: {
        key,
        title
      }
    })
  } catch (error) {
    console.error(error)
    res.status(404).json({
      msg: 'Error',
      error: 'Libro no encontrado'
    })
  }
}

module.exports = {
  getLibros,
  getLibrosPorSubjects,
  getLibroPorId
}
