import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        gender: cast.gender,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
            : 'https://th.bing.com/th/id/OIP.OesLvyzDO6AvU_hYUAT4IAHaHa?w=219&h=219&c=7&r=0&o=5&pid=1.7',
        character: cast.character,
        popularity: cast.popularity,
      );
}
