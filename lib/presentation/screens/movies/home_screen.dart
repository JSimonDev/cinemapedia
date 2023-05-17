import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            // centerTitle: true,
            titlePadding: EdgeInsets.all(0.0),
            title: CustomAppbar(),
          ),
        ),
        
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  MoviesSlideshow(movies: slideShowMovies),
                  MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
                      subtitle: 'Lunes 20',
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage()),
                  MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'Proximamente',
                      subtitle: 'En este mes',
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage()),
                  MovieHorizontalListview(
                      movies: popularMovies,
                      title: 'Populares',
                      // subtitle: 'En este mes',
                      loadNextPage: () => ref
                          .read(popularMoviesProvider.notifier)
                          .loadNextPage()),
                  MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'Mejor calificadas',
                      subtitle: 'De todos los tiempos',
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage()),
                  const SizedBox(height: 10)
                ],
              );
            },
            childCount: 1,
          ),
        )
      ],
    );
  }
}
