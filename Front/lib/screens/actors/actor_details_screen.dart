import 'package:flutter/material.dart';


class ActorDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> actor;

  const ActorDetailsScreen({super.key, required this.actor});

  @override
  // ignore: library_private_types_in_public_api
  _ActorDetailsScreenState createState() => _ActorDetailsScreenState();
}

class _ActorDetailsScreenState extends State<ActorDetailsScreen> {
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.actor['name'],
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
    tag: 'actor-${widget.actor['id']}',
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
            image: widget.actor['profileImage'], 
            fit: BoxFit.cover,
            fadeInDuration: const Duration(seconds: 2),  
            fadeOutDuration: const Duration(milliseconds: 500),
            imageErrorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, size: 100, color: Colors.white54);  // Icono de persona en caso de que haya error con la imagen
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
          widget.actor['name'],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Popularidad del actor
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600], size: 20),
            const SizedBox(width: 4),
            Text(
              'Popularity: ${widget.actor['popularity'].toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Bio
        Text(
          'Biografía',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          widget.actor['biography'] ?? 'Biography not available.',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        
        const SizedBox(height: 24),
        
       /*
        if (widget.actor['knownfor'] != null && widget.actor['knownfor'].isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular por trabajar en: ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: screenWidth * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.actor['knownfor'].length,
                  itemBuilder: (context, index) {
                    final knownForItem = widget.actor['knownfor'][index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        width: screenWidth * 0.4,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            knownForItem,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize * 0.8,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),*/
      ],
    );
  }

//Opinion del usuario
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
            subtitle: Text(
              _isFavorite 
                ? 'Ya es uno de tus actores favoritos'
                : 'Añadir este actor a mis favoritos'
            ),
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