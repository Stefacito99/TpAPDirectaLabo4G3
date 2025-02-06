import 'package:flutter/material.dart';
import 'package:flutter_app/screens/series/series_detail_screen.dart';

class SeriesSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> series = [
    {
      'title': 'Stranger Things',
      'description':
          'En un pequeño pueblo en los años 80, un grupo de amigos descubre secretos sobrenaturales cuando un niño desaparece, una niña con poderes aparece, y enfrentan criaturas de otra dimensión conocida como "el Upside Down".',
      'imagePath': 'assets/images/series_images/series1.jpg',
    },
    {
      'title': 'The Big Bang Theory',
      'description':
          'Un grupo de científicos brillantes pero socialmente torpes lidian con relaciones, amistades y situaciones hilarantes, mientras navegan su vida diaria con referencias a la cultura pop y la ciencia.',
      'imagePath': 'assets/images/series_images/series2.jpg',
    },
    {
      'title': 'Friends',
      'description':
          'Seis amigos inseparables en Nueva York comparten su día a día lleno de amor, risas, problemas laborales y momentos inolvidables, mientras crecen juntos y viven situaciones icónicas en Central Park.',
      'imagePath': 'assets/images/series_images/series3.jpg',
    },
    {
      'title': 'Breaking Bad',
      'description':
          'Walter White, un profesor de química con cáncer terminal, se asocia con un exalumno para fabricar metanfetaminas, entrando en un oscuro mundo criminal mientras lucha por proteger a su familia.',
      'imagePath': 'assets/images/series_images/series4.jpg',
    },
    {
      'title': 'One Piece',
      'description':
          'Luffy, un joven con poderes de goma, lidera a su tripulación en una épica aventura para encontrar el legendario tesoro "One Piece" y convertirse en el Rey de los Piratas, enfrentándose a enemigos poderosos y desafiando el orden mundial.',
      'imagePath': 'assets/images/series_images/series5.jpg',
    },
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpia la búsqueda
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Cierra la búsqueda
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredSeries = series.where((serie) {
      return serie['title']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredSeries.isEmpty) {
      return Center(
        child: Text('No se encontraron resultados para "$query".'),
      );
    }

    return ListView.builder(
      itemCount: filteredSeries.length,
      itemBuilder: (context, index) {
        final serie = filteredSeries[index];
        return ListTile(
          leading: Image.asset(serie['imagePath']!, fit: BoxFit.cover),
          title: Text(serie['title']!),
          subtitle: Text(serie['description']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeriesDetailScreen(
                  imagePath: serie['imagePath']!,
                  title: serie['title']!,
                  description: serie['description']!,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = series.where((serie) {
      return serie['title']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion['title']!),
          onTap: () {
            query = suggestion['title']!;
            showResults(context); // Muestra los resultados al seleccionar
          },
        );
      },
    );
  }
}
