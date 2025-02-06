import 'package:flutter/material.dart';
import 'package:flutter_app/screens/series/series_detail_screen.dart';

class RecommendedSeriesSwiper extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/series_images/series1.jpg',
    'assets/images/series_images/series2.jpg',
    'assets/images/series_images/series3.jpg',
    'assets/images/series_images/series4.jpg'
  ];

  final List<String> titles = [
    'Stranger Things',
    'The Big Bang Theory',
    'Friends',
    'Breaking Bad'
  ];

  final List<String> descriptions = [
    'En un pequeño pueblo en los años 80, un grupo de amigos descubre secretos sobrenaturales cuando un niño desaparece, una niña con poderes aparece, y enfrentan criaturas de otra dimensión conocida como "el Upside Down',
    'Un grupo de científicos brillantes pero socialmente torpes lidian con relaciones, amistades y situaciones hilarantes, mientras navegan su vida diaria con referencias a la cultura pop y la ciencia.',
    'Seis amigos inseparables en Nueva York comparten su día a día lleno de amor, risas, problemas laborales y momentos inolvidables, mientras crecen juntos y viven situaciones icónicas en Central Park.',
    'Walter White, un profesor de química con cáncer terminal, se asocia con un exalumno para fabricar metanfetaminas, entrando en un oscuro mundo criminal mientras lucha por proteger a su familia.'
  ];

  RecommendedSeriesSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeriesDetailScreen(
                    imagePath: imagePaths[index],
                    title: titles[index],
                    description: descriptions[index],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(imagePaths[index]),
            ),
          );
        },
      ),
    );
  }
}
