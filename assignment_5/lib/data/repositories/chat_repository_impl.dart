import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_session_model.dart';
import '../models/message_model.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final DatabaseService _databaseService;
  final AIService _aiService;
  final _uuid = const Uuid();

  ChatRepositoryImpl({
    required DatabaseService databaseService,
    required AIService aiService,
  })  : _databaseService = databaseService,
        _aiService = aiService;

  @override
  Future<ChatSession> createSession(String title) async {
    final session = ChatSessionModel(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );
    await _databaseService.saveSession(session);
    return session;
  }

  @override
  Future<List<ChatSession>> getAllSessions() async {
    return await _databaseService.getAllSessions();
  }

  @override
  Future<ChatSession?> getSession(String id) async {
    return await _databaseService.getSession(id);
  }

  @override
  Future<void> updateSessionTitle(String id, String title) async {
    final session = await getSession(id);
    if (session != null) {
      final updatedSession = ChatSessionModel.fromEntity(
        session.copyWith(title: title),
      );
      await _databaseService.saveSession(updatedSession);
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    await _databaseService.deleteSession(id);
  }

  @override
  Future<Message> sendMessage(String sessionId, String content) async {
    // Save user message
    final userMessage = MessageModel(
      id: _uuid.v4(),
      sessionId: sessionId,
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    await _databaseService.saveMessage(userMessage);

    try {
      // Get conversation history
      final messages = await getMessages(sessionId);
      final conversationHistory = messages.map((m) => {
        'role': m.role == MessageRole.user ? 'user' : 'assistant',
        'content': m.content,
      }).toList();

      // Get AI response
      final aiResponse = await _aiService.sendMessage(conversationHistory);

      // Save AI message
      final aiMessage = MessageModel(
        id: _uuid.v4(),
        sessionId: sessionId,
        content: aiResponse,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      await _databaseService.saveMessage(aiMessage);

      // Update session
      final session = await getSession(sessionId);
      if (session != null) {
        final updatedSession = ChatSessionModel.fromEntity(
          session.copyWith(lastMessageAt: DateTime.now()),
        );
        await _databaseService.saveSession(updatedSession);
      }

      return aiMessage;
    } catch (e) {
      // Save error message
      final errorMessage = MessageModel(
        id: _uuid.v4(),
        sessionId: sessionId,
        content: 'Sorry, I encountered an error: ${e.toString()}',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        isError: true,
      );
      await _databaseService.saveMessage(errorMessage);
      return errorMessage;
    }
  }

  @override
  Future<List<Message>> getMessages(String sessionId) async {
    return await _databaseService.getMessagesBySession(sessionId);
  }

  @override
  Future<void> saveMessage(Message message) async {
    await _databaseService.saveMessage(MessageModel.fromEntity(message));
  }
}