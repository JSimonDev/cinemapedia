class Actor {
  final int id;
  final int gender;
  final String name;
  final String profilePath;
  final String? character;
  final double popularity;

  Actor({
    required this.id,
    required this.gender,
    required this.name,
    required this.profilePath,
    required this.popularity,
    this.character,
  });
}
