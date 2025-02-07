import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/actor_model.dart';

class ActorService {
  final baseUrl = dotenv.env['RENDER_URL'];

  Future<List<Actor>> getPopularActors({int page = 1, int limit = 50}) async {
    try {
      final uri = Uri.parse('https://$baseUrl/actores?page=$page&limit=$limit');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return (jsonResponse['data'] as List)
            .map((actorJson) => Actor.fromJson(actorJson))
            .toList();
      }
      throw Exception('Error al cargar actores');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Actor>> searchActors(String query) async {
    try {
      // Codificar la consulta para manejar espacios y caracteres especiales
      final encodedQuery = Uri.encodeComponent(query);
      final uri = Uri.parse('https://$baseUrl/actores?nombre=$encodedQuery');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Verificar si hay datos
        if (jsonResponse['data'] == null || (jsonResponse['data'] as List).isEmpty) {
          return [];
        }

        return (jsonResponse['data'] as List)
            .map((actorJson) => Actor.fromJson(actorJson))
            .toList();
      } else if (response.statusCode == 404) {
        // Manejar específicamente el caso de no encontrado
        return [];
      }
      throw Exception('Error en la búsqueda');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Actor> getActorDetails(int id) async {
    try {
      final uri = Uri.parse('https://$baseUrl/actores/$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Actor.fromJson(jsonResponse['data']);
      }
      throw Exception('Error al cargar detalles del actor');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}