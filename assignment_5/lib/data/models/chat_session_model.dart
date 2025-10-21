import '../../domain/entities/chat_session.dart';

class ChatSessionModel extends ChatSession {
  ChatSessionModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.lastMessageAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
    };
  }

  factory ChatSessionModel.fromEntity(ChatSession session) {
    return ChatSessionModel(
      id: session.id,
      title: session.title,
      createdAt: session.createdAt,
      lastMessageAt: session.lastMessageAt,
    );
  }
}