# TpAPDirectaLabo4G3
# FlixFinder

FlixFinder es un prototipo de una aplicación desarrollada en Flutter, diseñada para permitir a los 
amantes del cine y la televisión descubrir información detallada sobre películas, series y actores 
populares de manera rápida y sencilla.

Este proyecto fue desarrollado por Clemente Nicolás, Mattei Stefano y Racciatti Carla como un trabajo 
práctico de aprobación directa de la materia Laboratorio IV (Profesor Sebastián Gañan -  UTN FRBB)

🔗 API Consumida
 Este proyecto consume los datos desde una API que fue desarrollada por nosotros mismos en el trabajo 
práctico 1, la cual se encuentra desplegada en render. 


## Contribuciones de los miembros del equipo: 
LOS TRES MIEMBROS DEL EQUIPO PROBAMOS LA EJECUCIÓN DEL PROTOTIPO MEDIANTE VISUALIZACIÓN EN EL NAVEGADOR 
(no utilizamos Android Studio) 

### Diseño Responsivo

- Adaptación a diferentes tamaños de pantalla
- Soporte para modo oscuro/claro
- Animaciones fluidas

### Pantallas Globales 
- Home Screen 
- Drawer menu para navegar entre pantallas
- Perfil de usuario con datos personales y switch de tema (Dark/Light)
- AppBar personalizado reutilizable
- Archivo unificador `screens/screens.dart`


### 🎭 Sección de Actores (Carla Racciatti)

#### Características Principales
- Lista de actores populares con carga incremental. Cargará más resultados a medida que el usuario constinúe haciendo scroll. 
- Búsqueda y filtrado de actores por nombre
  Para buscar se debe escribir el nombre del actor a buscar y luego presionar "enter" en el teclado o el ícono de la lupa en pantalla. 
- Obtención de detalles completos de cada actor:
  - Foto de perfil
  - Nivel de popularidad
  - Biografía detallada con widget personalizado "expandable text". 
    Presionar "leer más" para expandir el texto de la biografía y leer la totalidad. 
    Presionar "ver menos" para contraer el texto nuevamente. 
- Formulario para que el usuario complete reseñas sobre los actores
- Switch para marcar actores como favoritos
(Los datos ingresados en el formulario y el switch no quedan guardados. 
Pero fue diseñado de esta forma en caso de que incorporemos persistencia de datos en el futuro)


### 🎬 Sección de Películas (Nicolás Clemente)

#### Características Principales
- Grid view responsivo de películas
- Barra de búsqueda avanzada
- Filtros por género con Chips
- Pantalla de detalles detallada:
  - Animación Hero para imágenes
  - Información completa de películas
  - Formulario de reseñas
  - Switch de películas favoritas
(Los datos ingresados en el formulario y el switch no quedan guardados. 
Pero fue diseñado de esta forma en caso de que incorporemos persistencia de datos en el futuro)

### 📺 Sección de Series (Stefano Mattei)
#### Características Principales
- Pantalla principal con serie destacada
- ListView horizontal de recomendaciones
- Búsqueda de series personalizada
- Pantalla de detalles con información detallada


## Tecnologías principales: 
- **Flutter**: Framework principal
- **Dart**: Lenguaje de programación
- **APIs**: Integración con la API que desarrollamos anteriormente 
- **HTTP**: para llamadas de red
- **Git y GitHub**: Control de versiones

## Arquitectura del Proyecto
Estructura de Carpetas
lib/
├── models/         # Definición de modelos de datos
├── screens/        # Pantallas de la aplicación
├── services/       # Servicios para comunicación con API
├── widgets/        # Widgets reutilizables
└── providers/      # Gestión de estado


## Próximas Mejoras
- Mejoras en la interfaz de usuario
- Funcionalidades de favoritos persistentes
- Persistencia de reseñas ingresadas por los ususarios. 



## Cómo Clonar y Ejecutar el Proyecto
1. Clona el repositorio:
   ```
   git clone https://github.com/Stefacito99/TpAPDirectaLabo4G3
   ```
2. Accede al directorio:
   ```
   cd TpAPDirectaLabo4G3
   ```
3. Instala dependencias:
   ```
   flutter pub get
   ```
4. generar archivo .env en la carpeta TpAPDirectaLabo4G3 con el contenido del sample.env

5. Ejecuta la aplicación:
   ```
   flutter run
   ```

## Equipo de Desarrollo
- Nicolás Clemente S.
- Stefano Mattei
- Carla Racciatti

¡Gracias por visitar nuestro proyecto!
