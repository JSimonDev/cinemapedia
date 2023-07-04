import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import '../widgets.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    this.subtitle,
    this.loadNextPage,
    required this.movies,
    required this.title,
  });

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> _buttonVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Column(
        children: [
          TitleWithAnimatedButton(
            title: widget.title,
            subtitle: widget.subtitle,
            buttonVisible: _buttonVisible,
            scrollController: scrollController,
          ),
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
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return FadeInRight(
                    child: _Slide(
                      movie: widget.movies[index],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyles = Theme.of(context).textTheme;
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 5, offset: Offset(0, 5))
        ]);
    const double buttonSize = 18;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* IMAGE
          SizedBox(
            width: 150,
            height: 225,
            child: DecoratedBox(
              decoration: decoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  width: 150,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return FadeIn(
                        child: Container(
                          color: Colors.black12,
                          child: const SizedBox(
                            width: 150,
                            height: 225,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                        onTap: () => context.push('/home/0/movie/${movie.id}'),
                        child: FadeIn(
                          child: child,
                        ));
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),

          //* TITLE
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyles.titleSmall,
            ),
          ),

          //* RATING
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.star_half_outlined,
                  color: Colors.yellow.shade800,
                  size: buttonSize,
                ),
                const SizedBox(width: 3),
                Text(HumanFormats.number(movie.voteAverage, decimals: 1),
                    style: TextStyle(color: Colors.yellow.shade800)),
                const SizedBox(width: 10),
                // const Spacer(),
                Icon(Icons.trending_up_outlined,
                    color: Colors.deepPurple.shade800, size: buttonSize),
                const SizedBox(width: 3),
                Text(HumanFormats.number(movie.popularity),
                    style: TextStyle(color: Colors.deepPurple.shade800)),
                // const SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
