import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/story_model.dart';
import '../../data/models/comment_model.dart';
import '../providers/comments_provider.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final StoryModel story;

  const CommentsScreen({super.key, required this.story});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Fetch comments when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.story.kids != null && widget.story.kids!.isNotEmpty) {
        ref.read(commentsProvider.notifier).loadComments(widget.story.kids!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(commentsProvider.notifier).loadMoreComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(commentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Clear comments state and navigate back to home
            ref.read(commentsProvider.notifier).reset();
            context.go('/');
          },
          tooltip: 'Back to home',
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Story Header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.story.title ?? 'No Title',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.story.score ?? 0} points',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.story.by ?? 'Unknown',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.story.getFormattedTime(),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Comments Section
          if (commentsState.isLoading && commentsState.comments.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (commentsState.error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load comments',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      commentsState.error!,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.story.kids != null) {
                          ref.read(commentsProvider.notifier).loadComments(widget.story.kids!);
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (commentsState.comments.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No comments yet',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to comment on this story!',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < commentsState.comments.length) {
                    return CommentTile(
                      comment: commentsState.comments[index],
                      depth: 0,
                    );
                  } else if (commentsState.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Loading more comments...'),
                          ],
                        ),
                      ),
                    );
                  } else if (commentsState.hasMore) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(commentsProvider.notifier).loadMoreComments();
                          },
                          child: const Text('Load More Comments'),
                        ),
                      ),
                    );
                  }
                  return null;
                },
                childCount: commentsState.comments.length + 
                    (commentsState.isLoadingMore || commentsState.hasMore ? 1 : 0),
              ),
            ),
        ],
      ),
      floatingActionButton: widget.story.url != null
          ? FloatingActionButton.extended(
              onPressed: () => _launchUrl(widget.story.url!),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Story'),
              tooltip: 'Open original story in browser',
            )
          : null,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class CommentTile extends ConsumerStatefulWidget {
  final CommentModel comment;
  final int depth;

  const CommentTile({
    super.key,
    required this.comment,
    required this.depth,
  });

  @override
  ConsumerState<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
  bool isExpanded = true;
  bool isLoadingReplies = false;
  List<CommentModel> replies = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasReplies = widget.comment.kids != null && widget.comment.kids!.isNotEmpty;
    final indentPadding = widget.depth * 16.0;

    return Container(
      margin: EdgeInsets.only(
        left: indentPadding,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.depth.isEven 
                  ? theme.colorScheme.surface 
                  : theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment Header
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.comment.by ?? 'Unknown',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.comment.getFormattedTime(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (hasReplies)
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Comment Text
                Text(
                  widget.comment.cleanText,
                  style: theme.textTheme.bodyMedium,
                ),
                
                // Reply button
                if (hasReplies && isExpanded) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: isLoadingReplies ? null : _loadReplies,
                    icon: isLoadingReplies 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.reply, size: 16),
                    label: Text(
                      isLoadingReplies 
                          ? 'Loading...' 
                          : '${widget.comment.kids!.length} replies',
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Replies
          if (isExpanded && replies.isNotEmpty && widget.depth < 5) // Limit nesting depth
            ...replies.map((reply) => CommentTile(
                  comment: reply,
                  depth: widget.depth + 1,
                )),
        ],
      ),
    );
  }

  Future<void> _loadReplies() async {
    if (widget.comment.kids == null || isLoadingReplies) return;

    setState(() {
      isLoadingReplies = true;
    });

    try {
      final loadedReplies = await ref
          .read(commentsProvider.notifier)
          .loadNestedComments(widget.comment.kids!);
      
      setState(() {
        replies = loadedReplies;
        isLoadingReplies = false;
      });
    } catch (e) {
      setState(() {
        isLoadingReplies = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load replies: $e')),
        );
      }
    }
  }
}
