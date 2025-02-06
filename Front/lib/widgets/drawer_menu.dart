import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {'route': 'home', 'title': 'Home', 'subtitle': 'Home page'},
    {'route': 'actors', 'title': 'Actores Populares', 'subtitle': 'Carla Racciatti'},
    {'route': 'series', 'title': 'Series', 'subtitle': 'Stefano Mattei'},
    {'route': 'movies', 'title': 'Películas', 'subtitle': 'Nicolás Clemente S.'},
    {'route': 'profile','title': 'Perfil de Usuario','subtitle': 'Perfil de usuario-Cambio de tema light/dark '},
  ];

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeaderAlternative(),
          ...ListTile.divideTiles(
              context: context,
              tiles: _menuItems
                  .map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        dense: true,
                        minLeadingWidth: 25,
                        iconColor: Colors.blueGrey,
                        title: Text(item['title']!,
                            style: const TextStyle(fontFamily: 'FuzzyBubbles')),
                        subtitle: Text(item['subtitle'] ?? '',
                            style: const TextStyle(
                                fontFamily: 'RobotoMono', fontSize: 11)),
                        leading: const Icon(Icons.arrow_right),
                        /* trailing: const Icon(Icons.arrow_right), */
                        onTap: () {
                          Navigator.pop(context);
                          //Navigator.pushReplacementNamed(context, item['route']!);
                          Navigator.pushNamed(context, item['route']!);
                        },
                      ))
                  .toList())
        ],
      ),
    );
  }
}


class _DrawerHeaderAlternative extends StatelessWidget {
  const _DrawerHeaderAlternative();

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/menu.jpg', 
              fit: BoxFit.cover, 
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              '  Menu  ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,  
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}