import 'package:flutter/material.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureSeries = SeriesService.buscarSeries("The Office");
    loadSeries();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        loadSeries();
      }
    });
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeriesAppBar(
        title: 'Series',
        onSearchTap: () => _onSearchTap(context),
      ),
      body: Column(
        children: [
          // Imagen destacada
          FutureBuilder<List<Series>>(
            future: futureSeries,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No series found'));
              } else {
                Series featuredSeries = snapshot.data!.firstWhere((series) => series.name == "The Office", orElse: () => snapshot.data![0]);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeriesDetailScreen(
                          imagePath: featuredSeries.imageUrl,
                          title: featuredSeries.name,
                          description: featuredSeries.summary,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      featuredSeries.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: seriesList.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == seriesList.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return GestureDetector(
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
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(seriesList[index].imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}