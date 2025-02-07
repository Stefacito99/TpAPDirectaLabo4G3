// To parse this JSON data, do
//
//     final series = seriesFromJson(jsonString);

import 'dart:convert';

Series seriesFromJson(String str) => Series.fromJson(json.decode(str));

String seriesToJson(Series data) => json.encode(data.toJson());

class Series {
    String id;
    String name;
    List<String> genres;
    String premiered;
    String status;
    String summary;
    String network;

    Series({
        required this.id,
        required this.name,
        required this.genres,
        required this.premiered,
        required this.status,
        required this.summary,
        required this.network,
    });

    factory Series.fromJson(Map<String, dynamic> json) => Series(
        id: json["id"],
        name: json["name"],
        genres: List<String>.from(json["genres"].map((x) => x)),
        premiered: json["premiered"],
        status: json["status"],
        summary: json["summary"],
        network: json["network"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "premiered": premiered,
        "status": status,
        "summary": summary,
        "network": network,
    };
}
