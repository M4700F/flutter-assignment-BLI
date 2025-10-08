import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';
import '../widgets/story_card.dart';
import '../widgets/loading_indicator.dart';

class TopStoriesScreen extends ConsumerStatefulWidget {
  const TopStoriesScreen({super.key});

  @override
  ConsumerState<TopStoriesScreen> createState() => _TopStoriesScreenState();
}

class _TopStoriesScreenState extends ConsumerState<TopStoriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(topStoriesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topStoriesProvider);

    if (state.stories.isEmpty && state.isLoading) {
      return const LoadingIndicator();
    }

    if (state.stories.isEmpty && state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading stories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(topStoriesProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(topStoriesProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.stories.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.stories.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return StoryCard(story: state.stories[index]);
        },
      ),
    );
  }
}