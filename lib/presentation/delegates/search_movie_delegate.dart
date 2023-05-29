import 'package:flutter/material.dart';
import 'dart:async';

import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }) : super(
          searchFieldLabel: 'Buscar película',
        );

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChange(String query) {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if (query.isEmpty) {
      //   debouncedMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  StreamBuilder<List<Movie>> _buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  // @override
  // String get searchFieldLabel => 'Buscar película'; //* Esta es otra forma de cambiar el placeholder que sale al buscar las peliculas.

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            // duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear_rounded),
            ),
          );

        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);

    return _buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyles = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //* IMAGE
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return FadeIn(
                        child: Container(
                          color: Colors.black12,
                          child: SizedBox(
                            width: size.width * 0.3,
                            height: size.height * 0.2,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return FadeIn(
                      child: child,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),

            //* DESCRIPTION
            SizedBox(
              width: size.width * 0.7 - 30,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* MOVIE TITLE
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),

                  const SizedBox(height: 10),

                  //* RATING AND DATE
                  RatingAndDate(movie: movie, iconSize: 15, numberSize: 15),

                  const SizedBox(height: 10),

                  //* MOVIE OVERVIEW
                  (movie.overview.length > 100)
                      ? Text(
                          '${movie.overview.substring(0, 100)}...',
                          textAlign: TextAlign.justify,
                        )
                      : Text(movie.overview),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
