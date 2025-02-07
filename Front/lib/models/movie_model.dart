class Movie {
  final String key;
  final String title;
  final String releaseDate;
  final String overview;
  final double voteAverage;
  final String? posterPath;
  final List<String> genres;

  Movie({
    required this.key,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.voteAverage,
    this.posterPath,
    this.genres = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    key: json["key"] ?? '',
    title: json["title"] ?? '',
    releaseDate: json["releaseDate"] ?? '',
    overview: json["overview"] ?? '',
    voteAverage: json["voteAverage"]?.toDouble() ?? 0.0,
    posterPath: json["posterPath"],
    genres: List<String>.from(json["genres"] ?? []),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "title": title,
    "releaseDate": releaseDate,
    "overview": overview,
    "voteAverage": voteAverage,
    "posterPath": posterPath,
    "genres": genres,
  };
}