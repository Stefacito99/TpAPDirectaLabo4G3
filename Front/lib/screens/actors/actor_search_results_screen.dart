import 'package:flutter/material.dart';
import '../../widgets/actors_widgets/custom_list_tile.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/actor_model.dart';
import '../../services/actor_service.dart';

class ActorSearchResultsScreen extends StatelessWidget {
  final String query;

  const ActorSearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ActorService _actorService = ActorService();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Resultados de búsqueda: $query',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: FutureBuilder<List<Actor>>(
        future: _actorService.searchActors(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron actores'));
          }

          var searchResults = snapshot.data!;

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CustomListTile(
                    actor: searchResults[index].toJson(),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'actor_details',
                        arguments: searchResults[index],
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
          );
        },
      ),
    );
  }
}

