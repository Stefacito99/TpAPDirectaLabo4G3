import 'package:flutter/material.dart';

class FeaturedSeriesImage extends StatelessWidget {
  const FeaturedSeriesImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/series_images/series5.jpg'), // Ruta de la imagen destacada
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
