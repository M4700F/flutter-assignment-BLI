enum MessageRole {
  user,
  assistant,
  system,
}

class Message {
  final String id;
  final String sessionId;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isError;

  Message({
    required this.id,
    required this.sessionId,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isError = false,
  });

  Message copyWith({
    String? id,
    String? sessionId,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    bool? isError,
  }) {
    return Message(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
    );
  }
}