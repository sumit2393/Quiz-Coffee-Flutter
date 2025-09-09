class QuizResponse {
  final int responseCode;
  final List<QuestionModel> results;

  QuizResponse({required this.responseCode, required this.results});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      responseCode: json['response_code'] as int,
      results: (json['results'] as List)
          .map((q) => QuestionModel.fromMap(q))
          .toList(),
    );
  }
}

class QuestionModel {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final List<String> options;
  final int answerIndex;

  QuestionModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    final correctAnswer = map['correct_answer'] as String;
    final incorrectAnswers = List<String>.from(map['incorrect_answers']);
    final options = List<String>.from(incorrectAnswers)..add(correctAnswer);
    options.shuffle();
    final answerIndex = options.indexOf(correctAnswer);

    return QuestionModel(
      type: map['type'] as String,
      difficulty: map['difficulty'] as String,
      category: map['category'] as String,
      question: map['question'] as String,
      options: options,
      answerIndex: answerIndex,
    );
  }
}
