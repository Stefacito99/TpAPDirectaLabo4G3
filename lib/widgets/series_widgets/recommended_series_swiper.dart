import 'package:flutter/material.dart';
import 'package:flutter_app/screens/series/series_detail_screen.dart';
import '../../models/series.dart';

class RecommendedSeriesSwiper extends StatelessWidget {
  final List<Series> series;

  const RecommendedSeriesSwiper({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: series.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeriesDetailScreen(
                    imagePath: series[index].imageUrl,
                    title: series[index].name,
                    description: series[index].summary,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(
                series[index].imageUrl,
                fit: BoxFit.cover,
                width: 150,
                height: 250,
              ),
            ),
          );
        },
      ),
    );
  }
}