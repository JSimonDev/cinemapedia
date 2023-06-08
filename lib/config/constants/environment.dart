import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDbKey =
      dotenv.env["THE_MOVIEDB_KEY"] ?? "No hay API_KEY";

  static String noActorPosterImage = dotenv.env["NO_ACTOR_POSTER_IMAGE"] ??
      "No se encontro la variable NO_ACTOR_POSTER_IMAGE, revise el documento .env";

  static String noMoviePosterImage = dotenv.env["NO_MOVIE_POSTER_IMAGE"] ??
      "No se encontro la variable NO_MOVIE_POSTER_IMAGE, revise el documento .env";
}
