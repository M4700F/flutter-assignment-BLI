import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/story_model.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;

  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final domain = story.getDomain();

    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () => context.go('/story/${story.id}', extra: story),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    story.title ?? 'No Title',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Domain
                  if (domain != null)
                    Text(
                      domain,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Footer with metadata
                  Row(
                    children: [
                      // Score
                      Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${story.score ?? 0}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),

                      // Author
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          story.by ?? 'Unknown',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Time
                      Text(
                        story.getFormattedTime(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Comments button
                if (story.descendants != null && story.descendants! > 0)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.go('/comments/${story.id}', extra: story),
                      icon: const Icon(Icons.comment_outlined, size: 16),
                      label: Text('${story.descendants} comments'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.comment_outlined, size: 16),
                      label: const Text('No comments'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ),

                // Divider
                Container(
                  height: 20,
                  width: 1,
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),

                // Open URL button
                if (story.url != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _launchUrl(story.url),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Open'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('No URL'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}