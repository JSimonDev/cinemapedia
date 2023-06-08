import 'package:cinemapedia/domain/entities/actor_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

final actorDetailsProvider =
    StateNotifierProvider<ActorDetailsNotifier, Map<String, ActorDetails>>(
        (ref) {
  final actorsRepository = ref.watch(actorRepositoryProvider).getActorDetails;

  return ActorDetailsNotifier(getActorDetails: actorsRepository);
});

typedef GetActorsCallBack = Future<ActorDetails> Function(String actorId);

class ActorDetailsNotifier extends StateNotifier<Map<String, ActorDetails>> {
  final GetActorsCallBack getActorDetails;

  ActorDetailsNotifier({required this.getActorDetails}) : super({});

  Future<void> loadActorDetails(String actorId) async {
    if (state[actorId] != null) return;
    final ActorDetails actorDetails = await getActorDetails(actorId);

    state = {...state, actorId: actorDetails};
  }
}
