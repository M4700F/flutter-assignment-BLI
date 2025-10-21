import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.sessionId,
    required super.content,
    required super.role,
    required super.timestamp,
    super.isError,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      content: json['content'] as String,
      role: MessageRole.values.firstWhere(
            (e) => e.toString() == 'MessageRole.${json['role']}',
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isError: json['isError'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'content': content,
      'role': role.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isError': isError,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      sessionId: message.sessionId,
      content: message.content,
      role: message.role,
      timestamp: message.timestamp,
      isError: message.isError,
    );
  }
}