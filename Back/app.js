require('dotenv').config() // Importa dotenv para las variables de entorno

const Server = require('./src/models/server') // Importa la clase Server
const servidor = new Server() // Crea una instancia del servidor

servidor.listen() // Llama al método listen() para iniciar el servidor
