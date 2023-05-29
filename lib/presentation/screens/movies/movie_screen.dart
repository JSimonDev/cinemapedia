import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/movies/movie_info_provider.dart';
import '../../widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie_screen';
  final String movieId;

  const MovieScreen({
    super.key,
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final DraggableScrollableController scrollController =
        DraggableScrollableController();
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final Size size = MediaQuery.of(context).size;

    return (movie == null)
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: movieScreenAppBar(context),
            body: Stack(
              children: [
                //* MOVIE IMAGE
                Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  height: size.height * 0.7,
                ),

                //* DRAGGABLE SCROLL SHEET
                _CustomDraggableScrollSheet(
                    scrollController: scrollController, movie: movie)
              ],
            ),
          );
  }

  AppBar movieScreenAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        tooltip: 'Back',
        onPressed: () {
          context.pop();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            tooltip: 'Save',
            iconSize: 28,
            onPressed: () {},
          ),
        )
      ],
      iconTheme: const IconThemeData(shadows: [
        Shadow(color: Colors.black, blurRadius: 2),
      ], color: Colors.white),
      backgroundColor: Colors.transparent,
    );
  }
}

class _CustomDraggableScrollSheet extends StatelessWidget {
  const _CustomDraggableScrollSheet({
    required this.scrollController,
    required this.movie,
  });

  final DraggableScrollableController scrollController;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 30;
    final colors = Theme.of(context).scaffoldBackgroundColor;

    return DraggableScrollableSheet(
      controller: scrollController,
      initialChildSize: 0.40,
      minChildSize: 0.30,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: colors,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                topLeft: Radius.circular(borderRadius),
              )),
          child: _CustomDraggableScrollableSheetContent(
            movie: movie,
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}

class _CustomDraggableScrollableSheetContent extends StatelessWidget {
  const _CustomDraggableScrollableSheetContent({
    required this.movie,
    required this.scrollController,
  });

  final Movie movie;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black26),
                  height: 7,
                  width: 50,
                  // color: Colors.red,
                ),
              ),
              const SizedBox(height: 15),
              
              //* ORIGINAL TITLE
              if (movie.originalTitle != movie.title)
                Text(
                  movie.originalTitle,
                ),

              //* TITLE
              Text(
                movie.title,
                maxLines: 2,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              //* RATING
              RatingAndDate(movie: movie),

              const SizedBox(height: 20),

              //* OVERVIEW
              Text(
                movie.overview,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),

              //TODO: Poner boton de ...Ver Mas.
              // GestureDetector(
              //   onTap: (){},
              //     child: const Text(
              //   '...Ver mas',
              //   style: TextStyle(color: Colors.black45),
              // )),
              const SizedBox(height: 10),

              //* GENRES
              _Genres(movie: movie),
            ],
          ),
        ),
        _ActorsByMovie(
          movieId: movie.id.toString(),
        ),
        const SizedBox(height: 50)
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> _buttonVisible = ValueNotifier<bool>(false);

  _ActorsByMovie({required this.movieId});

  void initState() {
    scrollController.addListener(() {});
  }

  void dispose() {
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context, ref) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 5, offset: Offset(0, 5))
        ]);
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
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

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 360,
      child: Column(
        children: [
          TitleWithAnimatedButton(
              buttonVisible: _buttonVisible,
              scrollController: scrollController,
              title: 'Cast'),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels > 500) {
                  _buttonVisible.value = true;
                } else {
                  _buttonVisible.value = false;
                }
                return true;
              },
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: actors.length,
                itemBuilder: (context, index) {
                  final actor = actors[index];

                  return FadeInRight(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* ACTOR PHOTO
                          DecoratedBox(
                            decoration: decoration,
                            child: SizedBox(
                              width: 150,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(actor.profilePath,
                                    height: 180,
                                    width: 135,
                                    fit: BoxFit.cover, loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress != null) {
                                    return FadeIn(
                                      child: Container(
                                        color: Colors.black12,
                                        child: const SizedBox(
                                          width: 150,
                                          height: 200,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return FadeIn(child: child);
                                }),
                              ),
                            ),
                          ),
                          //* ACTOR NAME
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 150,
                            child: Text(
                              '${actor.name} /',
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              actor.character ?? '',
                              maxLines: 2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...movie.genreIds.take(3).map(
              (genre) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    // side:const BorderSide()
                  ),
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.deepPurple.shade800,
                  label: Text(genre),
                ),
              ),
            ),
      ],
    );
  }
}
