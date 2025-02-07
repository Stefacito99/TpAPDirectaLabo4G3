import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie_model.dart';

class MovieService {
  final baseUrl = dotenv.env['RENDER_URL'] ?? 'apigrupo3.onrender.com/api/v1/peliculas';

  Future<List<Movie>> getPopularMovies() async {
    try {
      final uri = Uri.parse('http://$baseUrl');
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

  Future<List<String>> getGenres() async {
    try {
      final uri = Uri.parse('http://$baseUrl/generos');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return List<String>.from(jsonResponse['data']);
      }
      throw Exception('Error al obtener géneros');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final uri = Uri.parse('http://$baseUrl/buscar?query=$query');
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
}