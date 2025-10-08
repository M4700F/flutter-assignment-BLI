import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import 'top_stories_screen.dart';
import 'best_stories_screen.dart';
import 'new_stories_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    final screens = [
      const TopStoriesScreen(),
      const BestStoriesScreen(),
      const NewStoriesScreen(),
    ];

    final titles = [
      'Top Stories',
      'Best Stories',
      'New Stories',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Top',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'Best',
          ),
          NavigationDestination(
            icon: Icon(Icons.fiber_new_outlined),
            selectedIcon: Icon(Icons.fiber_new),
            label: 'New',
          ),
        ],
      ),
    );
  }
}