import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/series.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['RENDER_URL'] ?? 'apigrupo3.onrender.com/api/v1';

class SeriesService {
  static Future<List<Series>> obtenerSeries(int page) async {
    String url = 'https://$baseUrl/series?page=$page';

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> body = jsonResponse['data'];
        List<Series> series = body.map((dynamic item) => Series.fromJson(item)).toList();
        return series;
      } catch (e) {
        throw Exception("Error al parsear la respuesta: $e");
      }
    } else {
      throw Exception("Error al cargar series: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }

  static Future<List<Series>> buscarSeries(String query) async {
    String url = 'https://$baseUrl/series/buscar?query=$query';

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> body = jsonResponse['data'];
        List<Series> series = body.map((dynamic item) => Series.fromJson(item)).toList();
        return series;
      } catch (e) {
        throw Exception("Error al parsear la respuesta: $e");
      }
    } else {
      throw Exception("Error al buscar series: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }
}