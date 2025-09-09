import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/blocs/quiz_bloc.dart';
import 'package:quiz/blocs/quiz_event.dart';
import 'package:quiz/blocs/quiz_state.dart';
import 'package:quiz/screens/result.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            final question = state.questions[state.currentQuestionIndex];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.category,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo.shade400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Q${state.currentQuestionIndex + 1}: ${question.question}',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.black
                              : Colors.indigo.shade300,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          //   context.read<QuizBloc>().add(AnswerQuestion(index));
                        },
                        child: Text(
                          question.options[index],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  // Text(
                  //   'Score :${state.score}',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Colors.indigo.shade400,
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: selectedIndex != null
                          ? () {
                              context.read<QuizBloc>().add(
                                AnswerQuestion(selectedIndex!),
                              );
                              setState(() {
                                selectedIndex = null;
                              });

                              if (state.currentQuestionIndex + 1 <
                                  state.questions.length) {
                                setState(() {
                                  selectedIndex = null;
                                });
                              }
                            }
                          : null,
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is QuizCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ResultScreen(score: state.score, total: state.total),
                ),
              );
            });
            return const SizedBox();
          } else if (state is QuizError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          // Default widget if no condition matches
          return Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
