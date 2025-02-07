class Movie {
  final String key;
  final String title;
  final String releaseDate;
  final String overview;
  final double voteAverage;
  final List<String> genres;
  final String? posterPath; 

  Movie({
    required this.key,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.voteAverage,
    this.genres = const [],
    this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    key: json["key"] ?? '',
    title: json["title"] ?? '',
    releaseDate: json["releaseDate"] ?? '',
    overview: json["overview"] ?? '',
    voteAverage: json["voteAverage"]?.toDouble() ?? 0.0,
    genres: json["genres"] != null 
        ? List<String>.from(json["genres"]) 
        : [],
    posterPath: json["posterPath"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "title": title,
    "releaseDate": releaseDate,
    "overview": overview,
    "voteAverage": voteAverage,
    "genres": genres,
    "posterPath": posterPath,
  };
}