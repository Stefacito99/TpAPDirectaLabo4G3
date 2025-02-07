import 'package:flutter/material.dart';
import '../../widgets/series_widgets/featured_series_image.dart';
import '../../widgets/series_widgets/recommended_series_swiper.dart';
import '../../widgets/series_widgets/series_app_bar.dart';
import '../../widgets/series_widgets/series_search_delegate.dart';
import 'package:flutter_app/screens/series/series_detail_screen.dart';
import '../../services/series_service.dart';
import '../../models/series.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  late Future<List<Series>> futureSeries;
  int currentPage = 1;
  List<Series> seriesList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSeries();
  }

  void loadSeries() {
    setState(() {
      isLoading = true;
    });
    SeriesService.obtenerSeries(currentPage).then((newSeries) {
      setState(() {
        seriesList.addAll(newSeries);
        isLoading = false;
        currentPage++;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    });
  }

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
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            loadSeries();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: seriesList.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == seriesList.length) {
              return Center(child: CircularProgressIndicator());
            }
            return ListTile(
              leading: Image.network(seriesList[index].imageUrl),
              title: Text(seriesList[index].name),
              subtitle: Text(seriesList[index].summary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeriesDetailScreen(
                      imagePath: seriesList[index].imageUrl,
                      title: seriesList[index].name,
                      description: seriesList[index].summary,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}