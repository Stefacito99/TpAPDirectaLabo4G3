import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom_app_bar.dart';
import 'package:flutter_app/widgets/movies/movie_card.dart';
import 'package:flutter_app/services/movie_service.dart';
import 'package:flutter_app/models/movie_model.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final MovieService _movieService = MovieService();
  String _searchQuery = '';
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                _buildSearchBar(theme),
                const SizedBox(height: 16),
                _buildGenreFilters(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _searchQuery.isEmpty
                  ? _movieService.getPopularMovies()
                  : _movieService.searchMovies(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No se encontraron películas'));
                }

                var filteredMovies = snapshot.data!;
                if (_selectedGenre != null) {
                  filteredMovies = filteredMovies.where((movie) =>
                    movie.genres.contains(_selectedGenre)).toList();
                }

                return _buildMoviesGrid(filteredMovies);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
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
    );
  }

  Widget _buildGenreFilters() {
    return FutureBuilder<List<String>>(
      future: _movieService.getGenres(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            _buildFilterChip('Todos', null),
            ...snapshot.data!.map((genre) => _buildFilterChip(genre, genre)),
          ],
        );
      },
    );
  }

  Widget _buildMoviesGrid(List<Movie> movies) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(
              movie: movies[index].toJson(),
              onTap: () => Navigator.pushNamed(
                context,
                'movie_details',
                arguments: movies[index].toJson(),
              ),
            );
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width < 450) return 1;
    if (width < 800) return 2;
    if (width < 1100) return 3;
    return 4;
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