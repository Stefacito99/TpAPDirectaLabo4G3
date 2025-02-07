import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie_model.dart';

class MovieService {
  final baseUrl = dotenv.env['RENDER_URL'] ?? 'apigrupo3.onrender.com/api/v1/peliculas';

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
      final uri = Uri.parse('https://$baseUrl');
      final response = await http.get(uri, headers: {
        'Access-Control-Allow-Origin': '*',
      });

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
      final uri = Uri.parse('https://$baseUrl/buscar?query=$query');
      final response = await http.get(uri, headers: {
        'Access-Control-Allow-Origin': '*',
      });

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
    try {
      final uri = Uri.parse('https://$baseUrl/generos');
      final response = await http.get(uri, headers: {
        'Access-Control-Allow-Origin': '*',
      });

      if (response.statusCode == 200) {
        return ['Todos', ...genreIds.keys];
      }
      throw Exception('Error al obtener géneros');
    } catch (e) {      
      return ['Todos', ...genreIds.keys];
    }
  }
}