import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Map<String, dynamic> actor;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.actor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Add null and type checks
    final name = actor['name'] ?? 'Unknown Actor';
    final knownFor = actor['knownFor'] is List 
        ? (actor['knownFor'] as List).join(', ') 
        : 'No known works';
    final profileImage = actor['profileImage'];

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      title: Text(name, style: const TextStyle(fontSize: 20)), 
      subtitle: Text(knownFor), 
      leading: profileImage != null
          ? Image.network(
              profileImage, 
              width: 50, 
              height: 50, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person);
              },
            )
          : const Icon(Icons.person),
    );
  }
}