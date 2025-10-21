class AppConstants {
  static const String appName = 'Qwen AI Chat';
  static const String appVersion = '1.0.0';
  static const String aiModelName = 'Qwen2-0.5B-Instruct';

  // API Configuration
  static const String baseUrl = 'http://10.0.2.2:1234';
  static const String chatEndpoint = '/v1/chat/completions';

  // Database
  static const String dbName = 'qwen_chat.db';
  static const String chatSessionStore = 'chat_sessions';
  static const String messageStore = 'messages';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const double spacing = 16.0;
}