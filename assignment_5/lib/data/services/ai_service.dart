import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class AIService {
  final String baseUrl;

  AIService({this.baseUrl = AppConstants.baseUrl});

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      final url = Uri.parse('$baseUrl${AppConstants.chatEndpoint}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'qwen2-0.5b-instruct',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1000,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }

  Future<bool> checkConnection() async {
    try {
      final url = Uri.parse('$baseUrl/v1/models');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}