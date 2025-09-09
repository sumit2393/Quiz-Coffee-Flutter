import 'package:quiz/models/question_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  late final List<QuestionModel> questions;
  late final int currentQuestionIndex;
  late final int score;
  QuizLoaded(this.questions, this.currentQuestionIndex, this.score);
}

class QuizCompleted extends QuizState {
  late final int score;
  late final int total;
  QuizCompleted(this.score, this.total);
}

class QuizNextQuestion extends QuizState {
  late final int NextQuestionIndex;
  QuizNextQuestion(this.NextQuestionIndex);
}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}
