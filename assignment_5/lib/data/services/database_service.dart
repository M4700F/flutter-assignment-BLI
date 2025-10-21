import 'package:sembast/sembast.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/database_helper.dart';
import '../models/chat_session_model.dart';
import '../models/message_model.dart';

class DatabaseService {
  final _sessionStore = stringMapStoreFactory.store(AppConstants.chatSessionStore);
  final _messageStore = stringMapStoreFactory.store(AppConstants.messageStore);

  Future<Database> get _db async => await DatabaseHelper.database;

  // Chat Sessions
  Future<void> saveSession(ChatSessionModel session) async {
    final db = await _db;
    await _sessionStore.record(session.id).put(db, session.toJson());
  }

  Future<List<ChatSessionModel>> getAllSessions() async {
    final db = await _db;
    final finder = Finder(sortOrders: [SortOrder('lastMessageAt', false)]);
    final records = await _sessionStore.find(db, finder: finder);
    return records.map((record) => ChatSessionModel.fromJson(record.value)).toList();
  }

  Future<ChatSessionModel?> getSession(String id) async {
    final db = await _db;
    final record = await _sessionStore.record(id).get(db);
    return record != null ? ChatSessionModel.fromJson(record) : null;
  }

  Future<void> updateSessionTitle(String id, String title) async {
    final db = await _db;
    await _sessionStore.record(id).update(db, {'title': title});
  }

  Future<void> deleteSession(String id) async {
    final db = await _db;
    await _sessionStore.record(id).delete(db);
    await deleteMessagesBySession(id);
  }

  // Messages
  Future<void> saveMessage(MessageModel message) async {
    final db = await _db;
    await _messageStore.record(message.id).put(db, message.toJson());
  }

  Future<List<MessageModel>> getMessagesBySession(String sessionId) async {
    final db = await _db;
    final finder = Finder(
      filter: Filter.equals('sessionId', sessionId),
      sortOrders: [SortOrder('timestamp', true)],
    );
    final records = await _messageStore.find(db, finder: finder);
    return records.map((record) => MessageModel.fromJson(record.value)).toList();
  }

  Future<void> deleteMessagesBySession(String sessionId) async {
    final db = await _db;
    final finder = Finder(filter: Filter.equals('sessionId', sessionId));
    await _messageStore.delete(db, finder: finder);
  }
}