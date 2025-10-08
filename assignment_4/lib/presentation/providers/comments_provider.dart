import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/comment_model.dart';
import '../../data/repositories/hacker_news_repository.dart';
import 'story_provider.dart';

// Comment State
class CommentState {
  final List<CommentModel> comments;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final int currentPage;
  final int totalComments;
  final int pageSize;

  CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 0,
    this.totalComments = 0,
    this.pageSize = 20,
  });

  CommentState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    int? currentPage,
    int? totalComments,
    int? pageSize,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalComments: totalComments ?? this.totalComments,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

// Comment Notifier
class CommentNotifier extends StateNotifier<CommentState> {
  final HackerNewsRepository repository;
  List<int> _allCommentIds = [];

  CommentNotifier(this.repository) : super(CommentState());

  Future<void> loadComments(List<int> commentIds) async {
    if (state.isLoading) return;

    _allCommentIds = commentIds;
    state = state.copyWith(
      isLoading: true, 
      error: null,
      totalComments: commentIds.length,
      currentPage: 0,
      hasMore: false, // Start with false, will be updated based on actual results
    );

    try {
      final comments = await _loadCommentsPage(0);
      state = state.copyWith(
        comments: comments,
        isLoading: false,
        currentPage: 0,
        hasMore: comments.length >= state.pageSize && (state.currentPage + 1) * state.pageSize < _allCommentIds.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMoreComments() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final newComments = await _loadCommentsPage(nextPage);
      
      if (newComments.isEmpty) {
        // No more comments to load
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: false,
        );
        return;
      }
      
      final allComments = [...state.comments, ...newComments];
      final hasMore = newComments.length >= state.pageSize && (nextPage + 1) * state.pageSize < _allCommentIds.length;

      state = state.copyWith(
        comments: allComments,
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<List<CommentModel>> _loadCommentsPage(int page) async {
    final startIndex = page * state.pageSize;
    final endIndex = (startIndex + state.pageSize).clamp(0, _allCommentIds.length);
    
    if (startIndex >= _allCommentIds.length) {
      return [];
    }

    final pageIds = _allCommentIds.sublist(startIndex, endIndex);
    return await repository.getComments(pageIds);
  }

  Future<List<CommentModel>> loadNestedComments(List<int> commentIds) async {
    try {
      return await repository.getNestedComments(commentIds);
    } catch (e) {
      rethrow;
    }
  }

  void reset() {
    _allCommentIds = [];
    state = CommentState();
  }
}

// Comments Provider
final commentsProvider = StateNotifierProvider<CommentNotifier, CommentState>((ref) {
  final repository = ref.watch(hackerNewsRepositoryProvider);
  return CommentNotifier(repository);
});
