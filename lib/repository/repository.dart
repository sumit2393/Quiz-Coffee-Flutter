import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/question_model.dart';

class QuizRepository {
  Future<QuizResponse> fetchQuestions() async {
    final url = Uri.parse(
      'https://opentdb.com/api.php?amount=10&type=multiple',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return QuizResponse.fromJson(data);
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
