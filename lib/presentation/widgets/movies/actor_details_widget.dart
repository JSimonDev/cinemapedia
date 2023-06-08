import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/actors/selected_actor_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';

import '../../providers/actors/actor_details_provider.dart';

class ActorDetailsWidget extends ConsumerStatefulWidget {
  final ScrollController scrollContoller;
  final dynamic previousPageTransition;

  const ActorDetailsWidget({
    super.key,
    required this.scrollContoller,
    required this.previousPageTransition,
  });

  @override
  ActorDetailsWidgetState createState() => ActorDetailsWidgetState();
}

class ActorDetailsWidgetState extends ConsumerState<ActorDetailsWidget> {
  @override
  void initState() {
    super.initState();
    final selectedActor = ref.read(selectedActorProvider).last;
    setState(() {
      ref.read(actorDetailsProvider.notifier).loadActorDetails(selectedActor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final actorId = ref.watch(selectedActorProvider).last;
    final actorDetails = ref.watch(actorDetailsProvider);
    final TextTheme textStyles = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    if (actorDetails[actorId] == null) {
      return const SizedBox(
        height: 180,
        width: 135,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    final details = actorDetails[actorId]!;
    final int currentYear = DateTime.now().year;

    return GestureDetector(
      onDoubleTap: () async {
        await widget.previousPageTransition();
      },
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        controller: widget.scrollContoller,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* PLACE OF BIRTH
                Text(
                  details.placeOfBirth,
                  style: textStyles.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //* NAME
                      SizedBox(
                        width: size.width * 0.6,
                        child: Text(
                          details.name,
                          style: textStyles.headlineLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),

                      const Spacer(),

                      //* DIVIDER
                      const VerticalDivider(
                        indent: 5,
                        endIndent: 5,
                        thickness: 1,
                      ),

                      const SizedBox(width: 3),

                      //* BIRTHDAY AND AGE
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //* BIRTH
                          Text(
                            details.birthday,
                            style: textStyles.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          //* AGE
                          if (details.birthday != 'Sin fecha')
                            Text(
                                "${currentYear - int.parse(details.birthday.substring(0, 4))} años",
                                style: textStyles.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                )),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //* BIOGRAPHY
                Text('Biografía',
                    style: textStyles.headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold)),

                const SizedBox(height: 5),

                Text(
                  details.biography,
                  style: textStyles.bodyLarge,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          MovieHorizontalListview(
            movies: details.combinedCredits,
            title:
                'Tambien ${details.gender == 1 ? "conocida" : "conocido"} por',
          )
        ],
      ),
    );
  }
}
