import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom_app_bar.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: CustomAppBar(title: movie['title']),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSmallScreen) ...[
                _buildMovieHeader(movie),
                const SizedBox(height: 16),
                _buildMovieInfo(movie),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildMovieHeader(movie),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 6,
                      child: _buildMovieInfo(movie),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              _buildReviewForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieHeader(Map<String, dynamic> movie) {
    return Hero(
      tag: 'movie-${movie['id']}',
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Image.asset(
              movie['imageAsset'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:
                      const Icon(Icons.movie, size: 100, color: Colors.white54),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo(Map<String, dynamic> movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie['title'],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600], size: 20),
            const SizedBox(width: 4),
            Text(
              '${movie['rating']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            Text(
              'Año: ${movie['releaseDate']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (movie['genres'] as List<String>)
              .map((genre) => Chip(
                    label: Text(genre),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Sinopsis',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          movie['synopsis'],
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildReviewForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu opinión',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Escribe tu reseña',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              hintText: 'Comparte tu opinión sobre la película...',
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor escribe un comentario';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Marcar como favorita'),
            subtitle: Text(_isFavorite
                ? 'Esta película está en tus favoritos'
                : 'Agrega esta película a tus favoritos'),
            value: _isFavorite,
            onChanged: (bool value) {
              setState(() {
                _isFavorite = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('¡Reseña guardada con éxito!'),
                      backgroundColor: Theme.of(context).primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar reseña'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
