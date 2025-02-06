import 'package:flutter/material.dart';
import '../../widgets/series_widgets/featured_series_image.dart';
import '../../widgets/series_widgets/recommended_series_swiper.dart';
import '../../widgets/series_widgets/series_app_bar.dart';
import '../../widgets/series_widgets/series_search_delegate.dart';
import 'package:flutter_app/screens/series/series_detail_screen.dart';

class SeriesScreen extends StatelessWidget {
  final String featuredImagePath = 'assets/images/series_images/series5.jpg';
  final String featuredTitle = 'One Piece';
  final String featuredDescription = 'Luffy, un joven con poderes de goma, lidera a su tripulación en una épica aventura para encontrar el legendario tesoro "One Piece" y convertirse en el Rey de los Piratas, enfrentándose a enemigos poderosos y desafiando el orden mundial.';

  const SeriesScreen({super.key});

  void _onSearchTap(BuildContext context) {
    showSearch(
      context: context,
      delegate: SeriesSearchDelegate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeriesAppBar(
        title: 'Series',
        onSearchTap: () => _onSearchTap(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeriesDetailScreen(
                    imagePath: featuredImagePath,
                    title: featuredTitle,
                    description: featuredDescription,
                  ),
                ),
              );
            },
            child: const FeaturedSeriesImage(), // Imagen principal clickeable
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Series Recomendadas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          RecommendedSeriesSwiper(),
        ],
      ),
    );
  }
}
