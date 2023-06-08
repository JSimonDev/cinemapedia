import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/actor_details.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/actor_details_response.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        gender: cast.gender,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : Environment.noActorPosterImage,
        character: cast.character,
        popularity: cast.popularity,
      );

  static Movie actorMoviesToEntity(DetailsCast detailsCast) => Movie(
        adult: detailsCast.adult,
        backdropPath: detailsCast.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${detailsCast.backdropPath}'
            : Environment.noMoviePosterImage,
        genreIds: detailsCast.genreIds.map((e) => e.toString()).toList(),
        id: detailsCast.id,
        originalLanguage: detailsCast.originalLanguage,
        originalTitle:
            detailsCast.originalTitle ?? detailsCast.originalName ?? '',
        overview: detailsCast.overview,
        popularity: detailsCast.popularity,
        posterPath: detailsCast.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${detailsCast.posterPath}'
            : Environment.noMoviePosterImage,
        title: detailsCast.title ?? detailsCast.name ?? 'No tiene titulo',
        video: detailsCast.video ?? false,
        voteAverage: detailsCast.voteAverage,
        voteCount: detailsCast.voteCount,
        releaseDate: detailsCast.releaseDate ?? detailsCast.firstAirDate ?? '',
      );

  static ActorDetails actorDetailsResponseToEntity(
          ActorDetailsResponse actorResponse) =>
      ActorDetails(
        id: actorResponse.id,
        gender: actorResponse.gender,
        name: actorResponse.name,
        profilePath: (actorResponse.profilePath != '')
            ? 'https://image.tmdb.org/t/p/w500${actorResponse.profilePath}'
            : Environment.noActorPosterImage,
        popularity: actorResponse.popularity,
        biography: actorResponse.biography != ''
            ? actorResponse.biography
            : 'No tiene Biografía',
        birthday:
            actorResponse.birthday != '' ? actorResponse.birthday : 'Sin fecha',
        deathday: actorResponse.deathday != ''
            ? actorResponse.deathday
            : 'No ha muerto',
        placeOfBirth: actorResponse.placeOfBirth,
        alsoKnownAs: actorResponse.alsoKnownAs,
        combinedCredits: actorResponse.combinedCredits.cast
            .map((movie) => ActorMapper.actorMoviesToEntity(movie))
            .where((element) =>
                element.posterPath != Environment.noMoviePosterImage)
            .toList(),
      );
}
