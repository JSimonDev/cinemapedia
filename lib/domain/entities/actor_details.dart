import 'actor.dart';
import 'movie.dart';

class ActorDetails extends Actor {
  final String biography;
  final String birthday;
  final String deathday;
  final String placeOfBirth;
  final List<String> alsoKnownAs;
  final List<Movie> combinedCredits;

  ActorDetails({
    super.character,
    required super.id,
    required super.gender,
    required super.name,
    required super.profilePath,
    required super.popularity,
    required this.biography,
    required this.birthday,
    required this.deathday,
    required this.placeOfBirth,
    required this.alsoKnownAs,
    required this.combinedCredits,
  });
}
