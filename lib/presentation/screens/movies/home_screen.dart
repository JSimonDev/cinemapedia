import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../views/views.dart';

class HomeScreen extends ConsumerWidget {
  static const String name = 'home_screen';
  final int pageIndex;
  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoritesView(),
  ];

  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool initialLoading = ref.watch(initialLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: initialLoading ? null : const CustomBottomNavBar(),
    );
  }
}
