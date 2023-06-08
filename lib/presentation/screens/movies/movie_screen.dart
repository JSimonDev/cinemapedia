import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';

import '../../providers/providers.dart';
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
  final _pageController = PageController();
  final draggableScrollableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {});
    });

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  void dispose() {
    _pageController.removeListener(() {});
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final String selectedActorProfilePath =
        ref.watch(selectedActorProfilePhotoProvider).last;
    final double progress =
        _pageController.hasClients ? (_pageController.page ?? 0) : 0;
    final Size size = MediaQuery.of(context).size;
    final Color colors = Theme.of(context).scaffoldBackgroundColor;
    const double borderRadius = 30;

    void updateStates() {
      final ids = ref.watch(selectedActorProvider);
      final photo = ref.watch(selectedActorProfilePhotoProvider);
      if (ids.length > 1 && photo.length > 1 && progress > 0.8) {
        ids.removeLast();
        photo.removeLast();
        ref.read(selectedActorProvider.notifier).state = ids;
        ref.read(selectedActorProfilePhotoProvider.notifier).state = photo;
      }
    }

    void nextPageTransition() async {
      draggableScrollableController.animateTo(0.4,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic);
      await Future.delayed(const Duration(milliseconds: 300));
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic);
    }

    void previousPageTransition() async {
      updateStates();
      draggableScrollableController.animateTo(0.9,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
      await Future.delayed(const Duration(milliseconds: 300));
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
    }

    Future<bool> onWillPop() async {
      updateStates();
      context.pop();
      return true;
    }

    return (movie == null)
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : WillPopScope(
            onWillPop: onWillPop,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: movieScreenAppBar(context, updateStates),
              body: Stack(
                children: [
                  //* MOVIE IMAGE
                  Opacity(
                    opacity: 1 - progress,
                    child: FadeIn(
                      child: Image.network(
                        movie.posterPath,
                        width: size.width,
                        height: size.height * 0.7,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //* SELECTED ACTOR IMAGE
                  Opacity(
                    opacity: progress,
                    child: selectedActorProfilePath ==
                                Environment.noActorPosterImage ||
                            selectedActorProfilePath == ""
                        ? Image.network(
                            Environment.noActorPosterImage,
                            width: size.width,
                            height: size.height * 0.7,
                            fit: BoxFit.cover,
                          )
                        : FadeIn(
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500$selectedActorProfilePath',
                              width: size.width,
                              height: size.height * 0.7,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),

                  //* DRAGGABLE SCROLL SHEET
                  DraggableScrollableSheet(
                    controller: draggableScrollableController,
                    initialChildSize: 0.4,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: colors,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(borderRadius),
                              topLeft: Radius.circular(borderRadius),
                            )),
                        child: Stack(
                          children: [
                            PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _CustomDraggableScrollableSheetContent(
                                  movie: movie,
                                  scrollController: scrollController,
                                  pageController: _pageController,
                                  nextPageTransition: nextPageTransition,
                                ),
                                ActorDetailsWidget(
                                    scrollContoller: scrollController,
                                    previousPageTransition:
                                        previousPageTransition),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
  }

  AppBar movieScreenAppBar(BuildContext context, updateStates) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        tooltip: 'Back',
        onPressed: () {
          updateStates();
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

class _CustomDraggableScrollableSheetContent extends StatelessWidget {
  final Movie movie;
  final ScrollController scrollController;
  final PageController pageController;
  final dynamic nextPageTransition;

  const _CustomDraggableScrollableSheetContent({
    required this.movie,
    required this.scrollController,
    required this.pageController,
    required this.nextPageTransition,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyles = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* ORIGINAL TITLE
              if (movie.originalTitle != movie.title)
                Text(
                  movie.originalTitle,
                ),

              //* TITLE
              Text(
                movie.title,
                maxLines: 2,
                style: textStyles.headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              //* RATING
              RatingAndDate(movie: movie),

              const SizedBox(height: 20),

              //* OVERVIEW
              Text(
                movie.overview,
                softWrap: true,
                textAlign: TextAlign.justify,
                // style: const TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 10),

              //* GENRES
              _Genres(movie: movie),
            ],
          ),
        ),
        _ActorsByMovie(
          movieId: movie.id.toString(),
          pageController: pageController,
          nextPageTransition: nextPageTransition,
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
  final PageController pageController;
  final dynamic nextPageTransition;

  _ActorsByMovie({
    required this.movieId,
    required this.pageController,
    required this.nextPageTransition,
  });

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

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* ACTOR PHOTO
                        DecoratedBox(
                          decoration: decoration,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: actor.id.toString() !=
                                    ref.read(selectedActorProvider).last
                                ? () async {
                                    await nextPageTransition();
                                    ref
                                        .read(selectedActorProvider.notifier)
                                        .state
                                        .add('${actor.id}');
                                    ref
                                        .read(selectedActorProfilePhotoProvider
                                            .notifier)
                                        .state
                                        .add(actor.profilePath);
                                  }
                                : null,
                            child: SizedBox(
                              width: 150,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ImageFiltered(
                                  imageFilter: ColorFilter.mode(
                                    actor.id.toString() ==
                                            ref.read(selectedActorProvider).last
                                        ? Colors.black
                                        : Colors.transparent,
                                    BlendMode.color,
                                  ),
                                  child: Image.network(actor.profilePath,
                                      height: 180,
                                      width: 135,
                                      fit: BoxFit.cover, loadingBuilder:
                                          (context, child, loadingProgress) {
                                    if (loadingProgress != null) {
                                      return Container(
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
                                      );
                                    }
                                    return child;
                                  }),
                                ),
                              ),
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
