import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool initialLoading = ref.watch(initialLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: _HomeView(initialLoading: initialLoading),
      bottomNavigationBar: initialLoading ? null : const CustomBottomNavBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  final bool initialLoading;

  const _HomeView({required this.initialLoading});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return (widget.initialLoading)
        ? const FullScreenLoader()
        : CustomScrollView(
            slivers: [
              //* HOME SCREEN APP BAR
              const SliverAppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                backgroundColor: Color.fromARGB(213, 49, 54, 81),
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  // centerTitle: true,
                  titlePadding: EdgeInsets.all(0.0),
                  title: CustomAppbar(),
                ),
              ),

              //* HOME SCREEN BODY
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        MoviesSlideshow(movies: slideShowMovies),
                        MovieHorizontalListview(
                            movies: nowPlayingMovies,
                            title: 'En cines',
                            subtitle: 'Lunes 20',
                            loadNextPage: () => ref
                                .read(nowPlayingMoviesProvider.notifier)
                                .loadNextPage()),
                        MovieHorizontalListview(
                            movies: upcomingMovies,
                            title: 'Proximamente',
                            subtitle: 'En este mes',
                            loadNextPage: () => ref
                                .read(upcomingMoviesProvider.notifier)
                                .loadNextPage()),
                        MovieHorizontalListview(
                            movies: popularMovies,
                            title: 'Populares',
                            loadNextPage: () => ref
                                .read(popularMoviesProvider.notifier)
                                .loadNextPage()),
                        MovieHorizontalListview(
                            movies: topRatedMovies,
                            title: 'Mejor calificadas',
                            loadNextPage: () => ref
                                .read(topRatedMoviesProvider.notifier)
                                .loadNextPage()),
                        const SizedBox(height: 100)
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
