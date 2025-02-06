const express = require('express')

class Server {
  constructor () {
    this.app = express()
    this.port = process.env.PORT || 3000
    this.middleware()
    this.rutas()
  }

  middleware () {
    this.app.use(express.static('public'))
    this.app.use(express.json())// para poder recibir formato Json
  }

  rutas () {
    // rutas integrante 1: Carla.  Ruta para libros
    this.app.use('/api/v1/libros', require('../routes/books'))    
    this.app.use('/api/v1/actores', require('../routes/actors'))// NUEVO: Ruta para actores (Carla, reemplazando libros)

    // rutas integrante 2: Nicolás Clemente. Ruta para peliculas
    this.app.use('/api/v1/peliculas', require('../routes/movies'))

    // rutas integrante 3: Stefano. Ruta para series
    this.app.use('/api/v1/series', require('../routes/series'))

    // Manejo de rutas incorrectas
    this.app.use('*', (req, res) => {
      res.status(404).send('Página no encontrada')
    })
  }

  listen () {
    this.app.listen(this.port, () => {
      console.log(`Se encuentra corriendo en puerto ${this.port}`) // para saber cuando esté corriendo
    })
  }
}

module.exports = Server
