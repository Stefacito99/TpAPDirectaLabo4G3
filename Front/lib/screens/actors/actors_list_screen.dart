//Pantalla lista general de actores (50 registros). Carla
import 'package:flutter/material.dart';
import '../../widgets/actors_widgets/custom_list_tile.dart';
import '../../widgets/custom_app_bar.dart';
import '../../mocks/actors_mock.dart';
import '../actors/actor_details_screen.dart';


class ActorsListScreen extends StatefulWidget {
  const ActorsListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActorsListScreenState createState() => _ActorsListScreenState();
}

//Decidí mostrar pocos registros e ir cargando más a medida que se scrollea hacia abajo

class _ActorsListScreenState extends State<ActorsListScreen> {
  List<dynamic> actors = [];
  int currentIndex = 0;
  final int pageSize = 10;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool hasMoreActors = true;

  @override
  void initState() {
    super.initState();
    _loadMoreActors();
  }

  void _loadMoreActors() {
    setState(() {
      List<dynamic> filteredActors = actorsMocks
          .where((actor) =>
              actor['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
              actor['id'].toString().contains(searchQuery))
          .toList();

      actors = filteredActors.sublist(0, (currentIndex + pageSize) > filteredActors.length
          ? filteredActors.length
          : currentIndex + pageSize);

      // Para verificar si hay más acotres o ya se cargaron todos 
      hasMoreActors = actors.length < filteredActors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Actores Populares',
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),  
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Escribe nombre o ID del actor para buscar",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  currentIndex = 0; // Reinicia la búsqueda
                  _loadMoreActors();
                });
              },
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (actors.length < actorsMocks.length && hasMoreActors) {
                    currentIndex += 5;
                    _loadMoreActors();
                  }
                }
                return false;
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),  // Efecto de rebote al llegar al final de la lista. No pude probarlo porque en el navegador no funciona pero en android sí debería verse correctamente. 
                itemCount: actors.isEmpty
                    ? 1  
                    : actors.length + (hasMoreActors ? 0 : 1), 
                itemBuilder: (context, index) {
                  if (actors.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('No coincidences')),
                    );
                  }

                  // Si no hay más actores para cargar, decidí mostrar el mensaje que avisa que es el fin de la lista.
                  if (!hasMoreActors && index == actors.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text(' - Fin de la lista -')),
                    );
                  }

                  return Column(
                    children: [
                      CustomListTile(
                        actor: actors[index],
                        onTap: () {
                          // Para navegar a la pantalla de detalles del actor al hacerle tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActorDetailsScreen(actor: actors[index]),
                            ),
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