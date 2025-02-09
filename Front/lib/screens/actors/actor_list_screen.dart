import 'package:flutter/material.dart';
import '../../widgets/actors_widgets/custom_list_tile.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/actor_model.dart';
import '../../services/actor_service.dart';
import 'actor_search_delegate.dart';

class ActorsListScreen extends StatefulWidget {
  const ActorsListScreen({super.key});

  @override
  State<ActorsListScreen> createState() => _ActorsListScreenState();
}

class _ActorsListScreenState extends State<ActorsListScreen> {
  List<Actor> actors = [];
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreActors = true;
  bool isLoading = false;
  final ActorService _actorService = ActorService();

  @override
  void initState() {
    super.initState();
    _loadMoreActors();
  }

  Future<void> _loadMoreActors() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newActors = await _actorService.getPopularActors(
        page: currentPage,
        limit: pageSize,
      );
      
      if (!mounted) return;
      
      setState(() {
        actors.addAll(newActors);
        hasMoreActors = newActors.length == pageSize;
        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar más actores: $e')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Actores Populares',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0), 
            child: TextButton.icon(
              icon: const Icon(Icons.search, color: Colors.red),
              label: const Text('Buscar', style: TextStyle(fontSize: 15, color: Colors.black)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), 
                ),
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ActorSearchDelegate(),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  if (hasMoreActors && !isLoading) {
                    _loadMoreActors();
                  }
                }
                return false;
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: actors.length + (hasMoreActors ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == actors.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Column(
                    children: [
                      CustomListTile(
                        actor: actors[index].toJson(),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'actor_details',
                            arguments: actors[index],
                          );
                        },
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 117, 114, 114),
                        thickness: 0.7,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}