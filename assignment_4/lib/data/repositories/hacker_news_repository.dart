import '../models/story_model.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../local/story_local_data_source.dart';
import '../local/database_service.dart';
import '../../core/constants/api_constants.dart';

enum StoryType { top, best, newStories }

class HackerNewsRepository {
  final ApiService _apiService;
  final StoryLocalDataSource _localDataSource;

  HackerNewsRepository(this._apiService, this._localDataSource);

  // Get paginated stories with caching
  Future<List<StoryModel>> getStories(
    StoryType type, {
    int page = 0,
    int pageSize = ApiConstants.pageSize,
    bool forceRefresh = false,
  }) async {
    final storeName = _getStoreName(type);

    try {
      // If first page and not force refresh, try to get cached data
      if (page == 0 && !forceRefresh) {
        final hasCached = await _localDataSource.hasCachedData(storeName);
        
        if (hasCached) {
          final cachedStories = await _localDataSource.getStories(storeName);
          if (cachedStories.isNotEmpty) {
            // Return cached data immediately
            return cachedStories;
          }
        }
      }

      // Fetch from API
      final endpoint = _getEndpoint(type);
      final allIds = await _apiService.getStoryIds(endpoint);
      
      // Calculate pagination
      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allIds.length);
      
      if (startIndex >= allIds.length) {
        return [];
      }
      
      // Get the IDs for current page
      final pageIds = allIds.sublist(startIndex, endIndex);
      
      // Fetch stories for these IDs
      final storiesData = await _apiService.getStories(pageIds);
      
      // Convert to StoryModel
      final stories = storiesData
          .where((data) => data.isNotEmpty)
          .map((data) => StoryModel.fromJson(data))
          .toList();

      // Cache the first 20 stories (only if it's the first page)
      if (page == 0 && stories.isNotEmpty) {
        await _localDataSource.saveStories(storeName, stories);
      }

      return stories;
    } catch (e) {
      // If API fails and we have cached data, return it
      if (page == 0) {
        final hasCached = await _localDataSource.hasCachedData(storeName);
        if (hasCached) {
          final cachedStories = await _localDataSource.getStories(storeName);
          if (cachedStories.isNotEmpty) {
            return cachedStories;
          }
        }
      }
      throw Exception('Failed to fetch stories: $e');
    }
  }

  // Get single story by ID
  Future<StoryModel> getStoryById(int id) async {
    try {
      final data = await _apiService.getStory(id);
      return StoryModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch story: $e');
    }
  }

  // Force refresh - clears cache and fetches new data
  Future<List<StoryModel>> refreshStories(StoryType type) async {
    final storeName = _getStoreName(type);
    await _localDataSource.clearStore(storeName);
    return getStories(type, page: 0, forceRefresh: true);
  }

  // Get cached story count
  Future<int> getCachedStoryCount(StoryType type) async {
    final storeName = _getStoreName(type);
    return await _localDataSource.getCachedStoryCount(storeName);
  }

  // Check if has cached data
  Future<bool> hasCachedData(StoryType type) async {
    final storeName = _getStoreName(type);
    return await _localDataSource.hasCachedData(storeName);
  }

  // Get comments for a story
  Future<List<CommentModel>> getComments(List<int> commentIds) async {
    try {
      if (commentIds.isEmpty) return [];
      
      print('📊 Comments Debug Info:');
      print('📊 Fetching ${commentIds.length} comments');
      
      final commentsData = await _apiService.getComments(commentIds);
      print('📊 Successfully fetched: ${commentsData.length} comments from API');
      
      // Convert to CommentModel and filter valid comments
      final allComments = commentsData.map((data) => CommentModel.fromJson(data)).toList();
      final validComments = allComments.where((comment) => comment.isValid).toList();
      
      print('📊 Valid comments after filtering: ${validComments.length}');
      print('📊 Filtered out: ${allComments.length - validComments.length} (deleted/dead/empty)');

      return validComments;
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  // Get nested comments (replies)
  Future<List<CommentModel>> getNestedComments(List<int> commentIds) async {
    try {
      if (commentIds.isEmpty) return [];
      
      final commentsData = await _apiService.getComments(commentIds);
      final comments = commentsData
          .map((data) => CommentModel.fromJson(data))
          .where((comment) => comment.isValid)
          .toList();

      return comments;
    } catch (e) {
      throw Exception('Failed to fetch nested comments: $e');
    }
  }

  String _getEndpoint(StoryType type) {
    switch (type) {
      case StoryType.top:
        return ApiConstants.topStories;
      case StoryType.best:
        return ApiConstants.bestStories;
      case StoryType.newStories:
        return ApiConstants.newStories;
    }
  }

  String _getStoreName(StoryType type) {
    switch (type) {
      case StoryType.top:
        return DatabaseService.topStoriesStore;
      case StoryType.best:
        return DatabaseService.bestStoriesStore;
      case StoryType.newStories:
        return DatabaseService.newStoriesStore;
    }
  }
}