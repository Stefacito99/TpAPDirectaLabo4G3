import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom_app_bar.dart';
import 'package:flutter_app/widgets/movies/movie_card.dart';
import 'package:flutter_app/mocks/movies_mock.dart';  

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  String _searchQuery = '';
  String? _selectedGenre;

  List<String> _getAllGenres() {
    Set<String> genres = {};
    for (var movie in moviesMock) {  
      genres.addAll((movie['genres'] as List<String>));
    }
    return genres.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var filteredMovies = moviesMock.where((movie) {  
      final titleMatches = movie['title'].toString().toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final genreMatches = _selectedGenre == null || 
          (movie['genres'] as List<String>).contains(_selectedGenre);
      return titleMatches && genreMatches;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(title: 'Películas'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar películas',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    _buildFilterChip('Todos', null),
                    ..._getAllGenres().map((genre) => _buildFilterChip(genre, genre)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                if (constraints.maxWidth < 450) {
                  crossAxisCount = 1;
                } else if (constraints.maxWidth < 800) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth < 1100) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 4;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => Navigator.pushNamed(
                        context,
                        'movie_details',
                        arguments: movie,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? genre) {
    final isSelected = _selectedGenre == genre;
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedGenre = genre),
        backgroundColor: theme.colorScheme.surface,
        selectedColor: theme.primaryColor,
        elevation: isSelected ? 4 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : theme.dividerColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}