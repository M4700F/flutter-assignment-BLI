import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/story_model.dart';

class StoryDetailScreen extends StatelessWidget {
  final StoryModel story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to home page with bottom navigation
            context.go('/');
          },
          tooltip: 'Back to home',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              story.title ?? 'No Title',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Metadata
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildMetaChip(
                  context,
                  Icons.arrow_upward,
                  '${story.score ?? 0} points',
                ),
                _buildMetaChip(
                  context,
                  Icons.person_outline,
                  story.by ?? 'Unknown',
                ),
                _buildMetaChip(
                  context,
                  Icons.access_time,
                  story.getFormattedTime(),
                ),
                if (story.descendants != null)
                  InkWell(
                    onTap: () => _navigateToComments(context),
                    child: _buildMetaChip(
                      context,
                      Icons.comment_outlined,
                      '${story.descendants} comments',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // URL
            if (story.url != null) ...[
              _buildSectionTitle(context, 'Link'),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchUrl(story.url!),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          story.getDomain() ?? story.url!,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Text content
            if (story.text != null) ...[
              _buildSectionTitle(context, 'Content'),
              const SizedBox(height: 8),
              Text(
                _stripHtmlTags(story.text!),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: story.url != null
          ? FloatingActionButton.extended(
              onPressed: () => _launchUrl(story.url!),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in Browser'),
            )
          : null,
    );
  }

  Widget _buildMetaChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: theme.colorScheme.surfaceVariant,
      labelStyle: theme.textTheme.bodySmall,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  String _stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString
        .replaceAll(exp, '')
        .replaceAll('&#x27;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&#x2F;', '/')
        .replaceAll('<p>', '\n\n')
        .trim();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToComments(BuildContext context) {
    if (story.kids != null && story.kids!.isNotEmpty) {
      context.go('/comments/${story.id}', extra: story);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No comments available for this story')),
      );
    }
  }
}