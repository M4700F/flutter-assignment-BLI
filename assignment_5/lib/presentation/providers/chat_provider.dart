import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/services/ai_service.dart';
import '../../data/services/database_service.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_provider.g.dart';

@riverpod
DatabaseService databaseService(DatabaseServiceRef ref) {
  return DatabaseService();
}

@riverpod
AIService aiService(AiServiceRef ref) {
  return AIService();
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepositoryImpl(
    databaseService: ref.watch(databaseServiceProvider),
    aiService: ref.watch(aiServiceProvider),
  );
}

@riverpod
class CurrentSession extends _$CurrentSession {
  @override
  ChatSession? build() {
    return null;
  }

  void setSession(ChatSession? session) {
    state = session;
  }
}

@riverpod
class Messages extends _$Messages {
  @override
  Future<List<Message>> build(String sessionId) async {
    final repository = ref.watch(chatRepositoryProvider);
    return await repository.getMessages(sessionId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      return await repository.getMessages(sessionId);
    });
  }
}

@riverpod
class ChatSessions extends _$ChatSessions {
  @override
  Future<List<ChatSession>> build() async {
    final repository = ref.watch(chatRepositoryProvider);
    return await repository.getAllSessions();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      return await repository.getAllSessions();
    });
  }

  Future<ChatSession> createNewSession(String title) async {
    final repository = ref.read(chatRepositoryProvider);
    final session = await repository.createSession(title);
    await refresh();
    return session;
  }

  Future<void> updateSessionTitle(String id, String title) async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.updateSessionTitle(id, title);
    await refresh();
  }

  Future<void> deleteSession(String id) async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.deleteSession(id);
    await refresh();
  }
}

@riverpod
class IsTyping extends _$IsTyping {
  @override
  bool build() {
    return false;
  }

  void setTyping(bool typing) {
    state = typing;
  }
}
