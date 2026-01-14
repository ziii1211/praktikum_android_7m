import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class QuestionApiService {
  static const String baseUrl =
      'https://api-post.banjarmasinkota.xyz/api/questions/random';
  static const String apiKey = 'API_IvTWJLWVHByuZxzAbyTn9frB1HtPPvOX';

  Future<List<QuizQuestion>> fetchQuestions() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> questionsJson = data['data'];

          return questionsJson.map((questionJson) {
            final List<dynamic> optionsJson = questionJson['options'] as List;

            optionsJson.sort((a, b) {
              if (a['is_correct'] == true) return -1;
              if (b['is_correct'] == true) return 1;
              return 0;
            });
            
            final List<String> options = optionsJson
                .map((option) => option['option_text'] as String)
                .toList();

            // PERBAIKAN DISINI:
            // 1. Ambil ID dari JSON (pastikan key-nya 'id' atau sesuaikan dengan API)
            // 2. Gunakan Named Parameters (id: ..., text: ..., answers: ...)
            return QuizQuestion(
              id: questionJson['id'] ?? 0, // Fallback ke 0 jika id null
              text: questionJson['question_text'] as String,
              answers: options,
            );
          }).toList();
        } else {
          throw Exception(
              'Failed to load questions: API returned unsuccessful response');
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}