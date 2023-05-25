import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorTheMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://api.themoviedb.org/3/', queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    }),
  );

  List<Actor> _jsonToActor(Map<String, dynamic> json) {
    final castResponse = CreditsResponse.fromJson(json);

    final List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('movie/$movieId/credits');

    return _jsonToActor(response.data);
  }
}
