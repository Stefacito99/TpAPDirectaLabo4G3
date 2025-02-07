class Actor {
  final int id;
  final String name;
  final List<String> knownFor;
  final double popularity;
  final String? profileImage;
  final String? biography;

  Actor({
    required this.id,
    required this.name,
    required this.knownFor,
    required this.popularity,
    this.profileImage,
    this.biography,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
    id: json["id"],
    name: json["name"] ?? '',
    knownFor: List<String>.from(json["knownFor"] ?? []),
    popularity: json["popularity"]?.toDouble() ?? 0.0,
    profileImage: json["profileImage"],
    biography: json["biography"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "knownFor": knownFor,
    "popularity": popularity,
    "profileImage": profileImage,
    "biography": biography,
  };
}