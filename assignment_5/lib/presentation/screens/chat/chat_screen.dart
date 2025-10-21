import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/chat_session.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/typing_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSession = ref.watch(currentSessionProvider);
    final isTyping = ref.watch(isTypingProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Qwen AI Chat'),
            if (currentSession != null)
              Text(
                currentSession.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HSLColor.fromColor(Theme.of(context).colorScheme.onSurface).withLightness(0.6).toColor(),
                    ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(currentSessionProvider.notifier).setSession(null);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: currentSession == null
                ? _buildEmptyChat(context)
                : _buildMessages(context, currentSession, isTyping),
          ),
          ChatInput(onMessageSent: _scrollToBottom),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: HSLColor.fromColor(Theme.of(context).colorScheme.primary).withLightness(0.8).toColor(),
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: HSLColor.fromColor(Theme.of(context).colorScheme.onSurface).withLightness(0.6).toColor(),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: HSLColor.fromColor(Theme.of(context).colorScheme.onSurface).withLightness(0.7).toColor(),
                ),
          ),
        ],
      ).animate().fade().scale(),
    );
  }

  Widget _buildMessages(BuildContext context, ChatSession currentSession, bool isTyping) {
    final messagesAsync = ref.watch(messagesProvider(currentSession.id));
    return messagesAsync.when(
      data: (messages) {
        if (messages.isEmpty) {
          return _buildEmptyChat(context);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length + (isTyping ? 1 : 0),
          itemBuilder: (context, index) {
            if (isTyping && index == messages.length) {
              return const TypingIndicator().animate().fadeIn().slideY(begin: 0.2);
            }

            final message = messages[index];
            return MessageBubble(message: message)
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 300))
                .slideY(
                  begin: 0.1,
                  duration: const Duration(milliseconds: 300),
                );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
          ],
        ),
      ),
    );
  }
}
