import 'package:flutter/material.dart';
import '../../models/actor_model.dart';

class ActorDetailsScreen extends StatefulWidget {
  const ActorDetailsScreen({super.key});

  @override
  State<ActorDetailsScreen> createState() => _ActorDetailsScreenState();
}

class _ActorDetailsScreenState extends State<ActorDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  late TextEditingController _commentController;
  late Actor actor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    actor = ModalRoute.of(context)!.settings.arguments as Actor;
  }

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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          actor.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isSmallScreen
            ? _buildSmallScreenLayout(context)
            : _buildWideScreenLayout(context),
      ),
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActorHeader(context),
        const SizedBox(height: 16),
        _buildActorInfo(context),
        const SizedBox(height: 24),
        _buildReviewForm(),
      ],
    );
  }

  Widget _buildWideScreenLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _buildActorHeader(context),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 6,
              child: _buildActorInfo(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildReviewForm(),
      ],
    );
  }

  Widget _buildActorHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Hero(
      tag: 'actor-${actor.id}',
      child: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenWidth * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: scaffoldBackgroundColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/actors_assets/loading.gif',
              image: actor.profileImage ?? '',
              fit: BoxFit.cover,
              fadeInDuration: const Duration(seconds: 2),
              fadeOutDuration: const Duration(milliseconds: 500),
              imageErrorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, size: 100, color: Colors.white54);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActorInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          actor.name,
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
              'Popularity: ${actor.popularity.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Biografía',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          actor.biography ?? 'Biography not available.',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        if (actor.knownFor.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conocido por:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: actor.knownFor.map<Widget>((item) {
                  return Chip(
                    label: Text(item),
                  );
                }).toList(),
              ),
            ],
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
            '¿Qué opinas de este actor?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Escribe tu opinión sobre este actor...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              hintText: 'Por ejemplo "Me emocionó su interpretación de X personaje!"',
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debes escribir algo para guardar tu valoración';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Agregar a favoritos'),
            subtitle: Text(_isFavorite
                ? 'Ya es uno de tus actores favoritos'
                : 'Añadir este actor a mis favoritos'),
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
                      content: const Text('Se ha guardado tu valoración'),
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
              label: const Text('Guardar valoración'),
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