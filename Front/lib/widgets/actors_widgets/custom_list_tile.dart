//Widget list_tile personalizado para la lista de actores. Carla 
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Map<String, dynamic> actor; // mapa como parámetro
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.actor,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      title: Text(actor['name'], style: const TextStyle(fontSize: 20), ), 
      subtitle: Text(actor['knownfor'].join(', ')), 
      leading: actor['profileImage'] != null
          ? Image.network(actor['profileImage']) // Muestra la imagen del actor si existe
          : const Icon(Icons.person), // Si no hay imagen, muestra un ícono de "persona" por defecto
    );
  }
}