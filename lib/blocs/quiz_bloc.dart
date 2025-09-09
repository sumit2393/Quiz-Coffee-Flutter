import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/blocs/quiz_event.dart';
import 'package:quiz/blocs/quiz_state.dart';
import 'package:quiz/models/question_model.dart';
import 'package:quiz/repository/repository.dart';

// ignore: prefer_typing_uninitialized_variables
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  late final QuizRepository quizRepository;
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _score = 0;

  QuizBloc(this.quizRepository) : super(QuizInitial()) {
    on<FetchQuiz>((event, emit) async {
      emit(QuizLoading());
      try {
        final quizResponse = await quizRepository.fetchQuestions();
        _questions = quizResponse.results;
        _currentIndex = 0;
        _score = 0;
        emit(QuizLoaded(_questions, _currentIndex, _score));
      } catch (e) {
        emit(QuizError(e.toString()));
      }
    });

    on<AnswerQuestion>((event, emit) {
      if (state is QuizLoaded) {
        final question = _questions[_currentIndex];
        if (event.selectedIndex == question.answerIndex) {
          _score++;
        }
        _currentIndex++;
        if (_currentIndex < _questions.length) {
          emit(QuizLoaded(_questions, _currentIndex, _score));
        } else {
          emit(QuizCompleted(_score, _questions.length));
        }
      }
    });
  }
}
