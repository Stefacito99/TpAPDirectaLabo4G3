import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/series.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
final baseUrl = dotenv.env['RENDER_URL'] ?? 'apigrupo3.onrender.com/api/v1';

class SeriesService {
  static Future<Series> obtenerPerfil() async {
    String url = '$baseUrl/series';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Series.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error al cargar series");
    }
  }
}