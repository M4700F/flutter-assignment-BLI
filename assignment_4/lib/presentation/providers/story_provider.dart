import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/story_model.dart';
import '../../data/repositories/hacker_news_repository.dart';
import '../../data/services/api_service.dart';
import '../../data/local/database_service.dart';
import '../../data/local/story_local_data_source.dart';

// Database Service Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// Local Data Source Provider
final localDataSourceProvider = Provider<StoryLocalDataSource>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return StoryLocalDataSource(databaseService);
});

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Repository Provider (Updated with local data source)
final hackerNewsRepositoryProvider = Provider<HackerNewsRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return HackerNewsRepository(apiService, localDataSource);
});

// Story State
class StoryState {
  final List<StoryModel> stories;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;
  final bool isLoadingFromCache;

  StoryState({
    this.stories = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 0,
    this.isLoadingFromCache = false,
  });

  StoryState copyWith({
    List<StoryModel>? stories,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
    bool? isLoadingFromCache,
  }) {
    return StoryState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      isLoadingFromCache: isLoadingFromCache ?? this.isLoadingFromCache,
    );
  }
}

// Story Notifier (Updated with caching logic)
class StoryNotifier extends StateNotifier<StoryState> {
  final HackerNewsRepository repository;
  final StoryType storyType;

  StoryNotifier(this.repository, this.storyType) : super(StoryState()) {
    loadStories();
  }

  Future<void> loadStories({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = StoryState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final page = refresh ? 0 : state.currentPage;
      final newStories = await repository.getStories(
        storyType,
        page: page,
        forceRefresh: refresh,
      );

      if (refresh) {
        state = StoryState(
          stories: newStories,
          isLoading: false,
          hasMore: newStories.isNotEmpty,
          currentPage: 0,
        );
      } else {
        state = state.copyWith(
          stories: [...state.stories, ...newStories],
          isLoading: false,
          hasMore: newStories.isNotEmpty,
          currentPage: page + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadStories(refresh: true);
  }

  void loadMore() {
    if (state.hasMore && !state.isLoading) {
      loadStories();
    }
  }

  // Check cache status
  Future<bool> hasCachedData() async {
    return await repository.hasCachedData(storyType);
  }

  // Get cached story count
  Future<int> getCachedCount() async {
    return await repository.getCachedStoryCount(storyType);
  }
}

// Story Providers for each type
final topStoriesProvider =
    StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  final repository = ref.watch(hackerNewsRepositoryProvider);
  return StoryNotifier(repository, StoryType.top);
});

final bestStoriesProvider =
    StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  final repository = ref.watch(hackerNewsRepositoryProvider);
  return StoryNotifier(repository, StoryType.best);
});

final newStoriesProvider =
    StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  final repository = ref.watch(hackerNewsRepositoryProvider);
  return StoryNotifier(repository, StoryType.newStories);
});