import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isError = message.isError;

    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            if (!isUser) ...[
        CircleAvatar(
        radius: 16,
        backgroundColor: HSLColor.fromColor(Theme.of(context).colorScheme.primary).withLightness(0.9).toColor(),
        child: Icon(Icons.psychology,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        ),
              const SizedBox(width: 8),
            ],
              Flexible(
                child: GestureDetector(
                  onLongPress: () {
                    _showMessageOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primary
                          : isError
                          ? HSLColor.fromColor(Colors.red).withLightness(0.9).toColor()
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                        topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                      border: isError
                          ? Border.all(color: HSLColor.fromColor(Colors.red).withLightness(0.8).toColor())
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isUser
                                ? Colors.white
                                : isError
                                ? Colors.red
                                : Theme.of(context).colorScheme.onSurface,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: isUser
                                ? HSLColor.fromColor(Colors.white).withAlpha(0.7).toColor()
                                : HSLColor.fromColor(Theme.of(context).colorScheme.onSurface).withLightness(0.5).toColor(),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
        ),
    );
  }
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}