import 'package:flutter/material.dart';
import '../../widgets/actors_widgets/custom_list_tile.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/actor_model.dart';
import '../../services/actor_service.dart';

class ActorsListScreen extends StatefulWidget {
  const ActorsListScreen({super.key});

  @override
  State<ActorsListScreen> createState() => _ActorsListScreenState();
}

class _ActorsListScreenState extends State<ActorsListScreen> {
  List<Actor> actors = [];
  List<Actor> filteredActors = [];
  int currentPage = 1;
  final int pageSize = 10;
  final TextEditingController _searchController = TextEditingController();
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
        filteredActors = List.from(actors);
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

  void _filterActors(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredActors = List.from(actors);
      } else {
        filteredActors = actors.where((actor) {
          return actor.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _searchActors(String query) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final searchResults = await _actorService.searchActors(query);
      
      if (!mounted) return;
      
      setState(() {
        actors = searchResults;
        filteredActors = List.from(actors);
        hasMoreActors = false;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la búsqueda: $e')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Actores Populares',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar actor por nombre",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterActors('');
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterActors,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchActors(value);
                }
              },
            ),
          ),
          Expanded(
            child: filteredActors.isEmpty
              ? Center(
                  child: isLoading 
                    ? const CircularProgressIndicator() 
                    : const Text('No se encontraron actores')
                )
              : NotificationListener<ScrollNotification>(
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
                    itemCount: filteredActors.length + (hasMoreActors ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredActors.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return Column(
                        children: [
                          CustomListTile(
                            actor: filteredActors[index].toJson(),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'actor_details',
                                arguments: filteredActors[index],
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