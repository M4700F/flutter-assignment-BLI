import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';

class ChatInput extends ConsumerStatefulWidget {
  final VoidCallback? onMessageSent;

  const ChatInput({super.key, this.onMessageSent});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitted() async {
    final messageContent = _controller.text.trim();
    if (messageContent.isEmpty) return;

    _controller.clear();
    setState(() {
      _isComposing = false;
    });

    ref.read(isTypingProvider.notifier).setTyping(true);

    try {
      var currentSession = ref.read(currentSessionProvider);

      // Create a new session if one doesn't exist
      if (currentSession == null) {
        final sessionsNotifier = ref.read(chatSessionsProvider.notifier);
        currentSession = await sessionsNotifier.createNewSession('New Chat');
        ref.read(currentSessionProvider.notifier).setSession(currentSession);
      }

      final repository = ref.read(chatRepositoryProvider);
      await repository.sendMessage(currentSession.id, messageContent);

      // Check if this is the first message and update the title
      final messages = await ref.read(messagesProvider(currentSession.id).future);
      if (messages.length == 1) {
        String newTitle = messageContent.length > 40
            ? '${messageContent.substring(0, 40)}...'
            : messageContent;
        await ref.read(chatSessionsProvider.notifier).updateSessionTitle(currentSession.id, newTitle);
        // Refresh the current session to reflect the new title
        final updatedSession = await repository.getSession(currentSession.id);
        ref.read(currentSessionProvider.notifier).setSession(updatedSession);
      }

      ref.invalidate(messagesProvider(currentSession.id));

      widget.onMessageSent?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      ref.read(isTypingProvider.notifier).setTyping(false);
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      // This checks if either the left or right Shift key is currently pressed.
      final isShiftPressed = HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.shiftLeft) ||
                             HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.shiftRight);

      // If Enter is pressed WITHOUT Shift, and there's text, handle the submission.
      if (!isShiftPressed && _isComposing) {
        _handleSubmitted();
        // We've handled the event, so stop it from propagating to the TextField.
        return KeyEventResult.handled;
      }
    }
    // In all other cases (including Shift+Enter), let the TextField handle the event.
    return KeyEventResult.ignored;
  }


  @override
  Widget build(BuildContext context) {
    final isTyping = ref.watch(isTypingProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: KeyboardListener(
                  focusNode: _focusNode,
                  onKeyEvent: _handleKeyEvent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      enabled: !isTyping,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) {
                        setState(() {
                          _isComposing = text.trim().isNotEmpty;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isTyping ? Icons.hourglass_empty : Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: _isComposing && !isTyping ? _handleSubmitted : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
