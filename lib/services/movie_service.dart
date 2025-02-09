import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie_model.dart';

class MovieService {
  final baseUrl = dotenv.env['RENDER_URL'];

  static final Map<String, int> genreIds = {
    'Acción': 28,
    'Aventura': 12,
    'Ciencia Ficción': 878,
    'Crimen': 80,
    'Drama': 18,
    'Fantasía': 14,
    'Historia': 36,
    'Romance': 10749,
    'Suspenso': 53
  };

  static final Map<int, String> genreNames = {
    28: 'Acción',
    12: 'Aventura',
    878: 'Ciencia Ficción',
    80: 'Crimen',
    18: 'Drama',
    14: 'Fantasía',
    36: 'Historia',
    10749: 'Romance',
    53: 'Suspenso'
  };

  Future<List<Movie>> getPopularMovies() async {
    try {
      final uri = Uri.parse('https://$baseUrl/peliculas');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return (jsonResponse['data'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
      }
      throw Exception('Error al cargar películas');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final uri = Uri.parse('https://$baseUrl/peliculas/buscar?query=$query');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return (jsonResponse['data'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
      }
      throw Exception('Error en la búsqueda');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<String>> getGenres() async {
    return genreIds.keys.toList();
  }
}