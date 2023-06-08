import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/actor_details.dart';


abstract class ActorsDatasource {

  Future<List<Actor>> getActorsByMovie(String movieId);

  Future<ActorDetails> getActorDetails(String actorId);
  
}
