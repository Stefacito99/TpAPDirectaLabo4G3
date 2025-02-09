import 'package:flutter/material.dart';
import '../../models/series.dart';
import '../../services/series_service.dart';
import '../../screens/series/series_detail_screen.dart';

class SeriesSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Series>>(
      future: SeriesService.buscarSeries(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No series found'));
        } else {
          List<Series> series = snapshot.data!;
          return ListView.builder(
            itemCount: series.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(series[index].imageUrl),
                title: Text(series[index].name),
                subtitle: Text(series[index].summary),
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
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}