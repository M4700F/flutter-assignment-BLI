import '../entities/chat_session.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<ChatSession> createSession(String title);
  Future<List<ChatSession>> getAllSessions();
  Future<ChatSession?> getSession(String id);
  Future<void> updateSessionTitle(String id, String title);
  Future<void> deleteSession(String id);

  Future<Message> sendMessage(String sessionId, String content);
  Future<List<Message>> getMessages(String sessionId);
  Future<void> saveMessage(Message message);
}