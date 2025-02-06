# tp2flutter_grupo3

# FlixFinder

FlixFinder permite a los amantes del cine y la televisión descubrir información detallada de manera rápida y sencilla.

Este es un prototipo de una aplicación llamada FlixFinder, una aplicación desarrollada en Flutter, diseñada para ayudar a los usuarios a descubrir información sobre películas, series, y actores populares. 
Este proyecto fue desarrollado por Clemente Nicolás, Mattei Stefano y Racciatti Carla como un trabajo práctico grupal de la materia Laboratorio IV (Profesor Sebastián Gañan -  UTN FRBB )

## Contribuciones de los miembros del equipo: 
    LOS TRES MIEMBROS DEL EQUIPO PROBAMOS LA EJECUCIÓN DEL PROTOTIPO MEDIANTE VISUALIZACIÓN EN EL NAVEGADOR (no utilizamos Android Studio) 

- **PANTALLAS GLOBALES**
    Los 3 integrantes compartimos las siguientes pantallas globales: 
    1. Home Screen: Pantalla principal con un fondo relacionado al cine y en el appbar se observa el nombre de nuestra app "FlixFinder"
    2. Drawer menu para navegar a las pantallas. 
    2. Perfil del usuario con datos personales y un switch con opción para el cambio de Tema (Dark Light). Estos datos se guardan mediante SharedPreferences.
    4. Compartimos el widget reutilizable custom_appbar. Creamos este Appbar personalizado ya que decidimos utilizar el mismo en todas las pantallas y poder acceder al menú desde cualquier pantalla de la app. 

    Además, compartimos un archivo unificador screens/screens.dart 

- **CARLA RACCIATTI:  "🎭 Sección de Actores Populares".** 
    Para este prototipo creé el archivo "actors_mock.dart" donde creé una lista de mapas (50 registros) para tener un prototipo similar a los datos que devolverá mi API TMDb. Cada registro corresponde a un actor con datos como id, nombre, popularidad, biografía, foto de perfil y trabajos por los que es reconocido. 
    Las fotos de perfil se encuentran guardadas en la carpeta assets/actors_assets/avatars. 
    Creé el widget reutilizable "custom_list_tile.dart" que luego utilizo en el archivo "actors_list_screen" para crear una lista de actores. Al principio se cargan algunos registros y al scrollear hacia abajo se van cargando nuevos actores hasta llegar al final de la lista. 
    En esa misma pantalla también está incluida la opción de buscar/filtrar los actores por nombre y por número de ID. 
    Al hacer click en un actor, se navega a la pantalla "actor_details.dart" donde se encuentra la foto del actor, su nivel de popularidad y su biografía. 
    También incluí una sección para que el usuario escriba una reseña u opinión sobre el actor y un switch para que el usuario pueda marcar al actor como "favorito". 
    
- **NICOLÁS CLEMENTE S.: 🎬 Sección de Películas**
 Desarrollé una sección completa para explorar y descubrir películas. Para este prototipo, creé el archivo "movies_mock.dart" con una lista de películas populares que simula los datos que posteriormente se obtendrán de la API TMDb.

    **Características principales:**
    1. **Lista de Películas (movies_list_screen):**
        - Grid view responsivo que se adapta a diferentes tamaños de pantalla
        - Barra de búsqueda para filtrar películas por título
        - Filtros por género implementados con Chips
        - Vista en grid con 1-4 columnas según el ancho de la pantalla

    2. **Detalles de Película (movie_details_screen):**
        - Visualización detallada de cada película
        - Imagen destacada con animación Hero
        - Información completa: título, año, rating y sinopsis
        - Formulario para agregar reseñas con TextFormField
        - Switch para marcar películas como favoritas
        - Diseño responsivo que se adapta a diferentes dispositivos

    3. **Widget Reutilizable (movie_card):**
        - Card personalizada para mostrar películas
        - Manejo de imágenes con fallbacks
        - Diseño consistente con el tema de la aplicación
        - Parámetros requeridos y opcionales para máxima flexibilidad

    **Organización del código:**
    - Los datos mockeados están en `lib/mock/movies_mock.dart`
    - Las pantallas están en `lib/screens/movies/`
    - Los widgets reutilizables en `lib/widgets/movies/`
    - Imágenes de películas en `assets/images/movies/`

    **Aspectos técnicos:**
    - Implementación de StatefulWidget para manejo de estado
    - Uso de Provider para el tema de la aplicación
    - Diseño responsivo para diferentes tamaños de pantalla
    - Animaciones y transiciones suaves
    - Manejo de errores y estados de carga


- **STEFANO MATTEI: 📺 Sección de Series**
Para la sección de Series, desarrollé las siguientes pantallas y funcionalidades:

Pantalla Principal de Series (series_screen.dart):

Muestra una imagen destacada de una serie popular (en este caso, "One Piece").
Incluye un ListView horizontal con recomendaciones de otras series populares.
Al hacer clic en la imagen destacada o en una de las recomendaciones, se navega a la pantalla de detalles de la serie.
Cuenta con un AppBar personalizado que permite volver a la pantalla principal y acceder a la funcionalidad de búsqueda.


Pantalla de Detalles de Serie (series_detail_screen.dart):

Muestra la imagen de la serie en la parte superior.
Debajo, se presenta el título y la descripción de la serie.
Al hacer clic en la imagen, se abre un diálogo que muestra una versión ampliada de la imagen.


Funcionalidad de Búsqueda (series_search_delegate.dart):

Implementa un SearchDelegate personalizado que permite a los usuarios buscar series por título.
Muestra una lista de resultados de búsqueda, y al seleccionar una serie, se navega a la pantalla de detalles correspondiente.


Widgets Reutilizables:

FeaturedSeriesImage: Widget que muestra la imagen destacada de la serie en la pantalla principal.
RecommendedSeriesSwiper: Widget que muestra un ListView horizontal con las recomendaciones de series.
SeriesAppBar: Widget personalizado para el AppBar de la sección de Series.
SeriesCard: Widget que representa una tarjeta de serie en la lista de recomendaciones.


Organización del Código:

Los archivos relacionados con la sección de Series se encuentran en la carpeta lib/screens/series/.
Los widgets reutilizables se encuentran en lib/widgets/series_widgets/.
Las imágenes de las series se encuentran en assets/images/series_images/.


---------------------------------------------------------------------------------------------------------------------------------------
## Tecnologías utilizadas
- **Flutter**: Framework principal para el desarrollo multiplataforma.
- **Dart**: Lenguaje de programación para la implementación de la lógica.
- **APIs externas**: Próximamente se integrará con servicios como The Movie Database (TMDb) y TVMaze.
- **Git y GitHub**: Herramientas para la colaboración en equipo y control de versiones.

---

## Cómo clonar y ejecutar el proyecto
1. Clona este repositorio:
   ```bash
   git clone https://github.com/NicoClemente/tp2flutter_grupo3.git
   ```
2. Accede al directorio del proyecto:
   ```bash
   cd tp2flutter_grupo3
   ```
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
5. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

---

## Equipo de desarrollo
Nicolás Clemente S., Stefano Mattei, Carla Racciatti
¡Gracias por visitar nuestro proyecto! 

