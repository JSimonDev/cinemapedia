import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';



final actorsByMovieProvider = StateNotifierProvider< ActorByMovieNotifier, Map<String, List<Actor>> > ( (ref) {
    final actorsRepository = ref.watch(actorRepositoryProvider).getActorsByMovie;

    return ActorByMovieNotifier(getActors: actorsRepository);

});

typedef GetActorsCallBack = Future<List<Actor>>Function(String movieId);

class ActorByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallBack getActors;

  ActorByMovieNotifier({ required this.getActors }):super({});

  Future<void> loadActors(String movieId) async {
    if( state[movieId] != null ) return;
    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }

}
