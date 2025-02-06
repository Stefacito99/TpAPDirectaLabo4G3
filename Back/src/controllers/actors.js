const axios = require('axios');
const { request, response } = require('express');
const baseUrl = process.env.TMDB_BASE_URL || 'https://api.themoviedb.org/3';
const apiKey = process.env.TMDB_ACCESS_TOKEN;

// Obtener una lista general de actores populares con paginación. Punto 1 de la consigna
const getActores = async (req = request, res = response) => {
  const { page = 1, limit = 50 } = req.query; // Paginación y límite de resultados por página

  try {
    const apiResponse = await axios.get(`${baseUrl}/person/popular`, {
      headers: { Authorization: `Bearer ${apiKey}` },
      params: { page }
    });
    
    
    const { results, total_pages, total_results } = apiResponse.data;

    const actores = await Promise.all(
        // Desestructuro para obtener únicamente los valores relevantes
      results.slice(0, limit).map(async ({ id, name, known_for, popularity, profile_path }) => {
        // Hago una llamada adicional para obtener biografía, porque no se encuentra disponible en la respuesta de actores populares
        const detailsResponse = await axios.get(`${baseUrl}/person/${id}`, {
          headers: { Authorization: `Bearer ${apiKey}` },
        });
        const biography = detailsResponse.data.biography || 'Biografía no disponible';

        return {
          id,
          name,
          knownFor: known_for.map(item => item.title || item.name || 'Desconocido'),
          popularity,
          profileImage: profile_path ? `https://image.tmdb.org/t/p/w500${profile_path}` : 'URL_DEFAULT_IMAGE',
          biography, 
        };
      })
    );
    
    
    
    /*
    const { results, total_pages, total_results } = apiResponse.data;

    const actores = results.slice(0, limit).map(({ id, name, known_for, popularity, profile_path }) => ({
      id,
      name,
      knownFor: known_for.map(item => item.title || item.name || 'Desconocido'),
      popularity,
      profileImage: profile_path ? `https://image.tmdb.org/t/p/w500${profile_path}` : 'URL_DEFAULT_IMAGE'
    }));
    */

    res.status(200).json({
      msg: 'Ok',
      page: Number(page),
      totalPages: total_pages,
      totalResults: total_results,
      data: actores
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      msg: 'Error',
      error: 'Error inesperado al obtener la lista general de actores'
    });
  }
};

// Buscar actor por nombre. Punto 3 de la consigna (filtro por nombre)
const getActorPorNombre = async (req = request, res = response) => {
  const { nombre = '' } = req.query;

  if (!nombre) {
    return res.status(400).json({
      msg: 'Error',
      error: 'Debes proporcionar un nombre para buscar actores'
    });
  }

  try {
    const apiResponse = await axios.get(`${baseUrl}/search/person`, {
      headers: { Authorization: `Bearer ${apiKey}` },
      params: { query: nombre }
    });
    /*
    const { results } = apiResponse.data;

    if (!results || results.length === 0) {
      return res.status(404).json({
        msg: 'Error',
        error: 'No se encontraron actores con ese nombre'
      });
    }

    const actores = results.map(({ id, name, known_for, popularity, profile_path }) => ({
      id,
      name,
      knownFor: known_for.map(item => item.title || item.name || 'Desconocido'),
      popularity,
      profileImage: profile_path ? `https://image.tmdb.org/t/p/w500${profile_path}` : 'URL_DEFAULT_IMAGE'
    }));*/

    const { results } = apiResponse.data;

    if (!results || results.length === 0) {
      return res.status(404).json({
        msg: 'Error',
        error: 'No se encontraron actores con ese nombre',
      });
    }

    const actores = await Promise.all(
      results.map(async ({ id, name, known_for, popularity, profile_path }) => {
        const detailsResponse = await axios.get(`${baseUrl}/person/${id}`, {
          headers: { Authorization: `Bearer ${apiKey}` },
        });
        const biography = detailsResponse.data.biography || 'Biografía no disponible';

        return {
          id,
          name,
          knownFor: known_for.map(item => item.title || item.name || 'Desconocido'),
          popularity,
          profileImage: profile_path ? `https://image.tmdb.org/t/p/w500${profile_path}` : 'URL_DEFAULT_IMAGE',
          biography, 
        };
      })
    );
    //

    res.status(200).json({
      msg: 'Ok',
      data: actores
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      msg: 'Error',
      error: 'Error inesperado al buscar el actor por nombre'
    });
  }
};



// Buscar actor por ID. Punto 2 de la consigna (filtro por ID )
const getActorPorId = async (req = request, res = response) => {
    const { id } = req.params;
  
    // Valida id ingresado
    if (!id) {
      return res.status(400).json({
        msg: 'Error',
        error: 'Debes proporcionar un ID de actor para obtener los detalles',
      });
    }
  
    try {
      // Llamada a la API de TMDB
      const apiResponse = await axios.get(`${baseUrl}/person/${id}`, {
        headers: { Authorization: `Bearer ${apiKey}` },
      });
  
      // Datos del actor
      const actor = apiResponse.data;
  
      // Validación 
      if (!actor) {
        return res.status(404).json({
          msg: 'Error',
          error: 'Actor no encontrado',
        });
      }
  
      // datos relevantes
      const actorDetails = {
        id: actor.id,
        name: actor.name,
        knownFor: actor.known_for ? actor.known_for.map(item => item.title || item.name) : [],
        popularity: actor.popularity,
        profileImage: actor.profile_path ? `https://image.tmdb.org/t/p/w500${actor.profile_path}` : null,
        biography: actor.biography || 'Biografía no disponible', 
      };
      /*
      const actorDetails = {
        id: actor.id,
        name: actor.name,
        knownFor: actor.known_for ? actor.known_for.map(item => item.title || item.name) : [],
        popularity: actor.popularity,
        profileImage: actor.profile_path ? `https://image.tmdb.org/t/p/w500${actor.profile_path}` : null,
      };*/
  
      res.status(200).json({
        msg: 'Ok',
        data: actorDetails,
      });
  
    } catch (error) {
      console.error('Error al obtener detalles del actor:', error.message);
  
      // Manejo de error actor no encontrado
      if (error.response && error.response.status === 404) {
        return res.status(404).json({
          msg: 'Error',
          error: 'Actor no encontrado',
        });
      }
  
      // Otros errores inesperados
      return res.status(500).json({
        msg: 'Error',
        error: `Error inesperado: ${error.message}`,
      });
    }
  };
  

// Exporta las funciones
module.exports = {
  getActores,
  getActorPorNombre,
  getActorPorId 
};


/*
// Cambios pendientes: 

 //Agregar la conversión de limit a número mediante parseInt(limit, 10) para asegurar que limit sea un número entero y evitar posibles errores.

//Agregar la verificación Array.isArray(results) para asegurar que results sea un array antes de intentar acceder a él.
// lo que evita posibles errores si la respuesta de la API cambia o no contiene resultados.*/