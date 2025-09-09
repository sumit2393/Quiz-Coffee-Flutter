abstract class QuizEvent {}

class FetchQuiz extends QuizEvent {}

class AnswerQuestion extends QuizEvent {
  late final int selectedIndex;
  AnswerQuestion(this.selectedIndex);
}
