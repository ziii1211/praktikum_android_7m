import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:praktikum_android_7m/models/quiz_question.dart';
import 'package:praktikum_android_7m/models/user_answer.dart';
import 'package:praktikum_android_7m/question_summary.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.chosenAnswers, 
    required this.onRestart,
    required this.questions, 
  });

  // final List<String> chosenAnswers;
  final List<UserAnswer> chosenAnswers;
  final void Function() onRestart;
  final List<QuizQuestion> questions;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      final UserAnswer = chosenAnswers[i];

      final question = questions.firstWhere(
        (q) => q.id == UserAnswer.questionId,
        orElse: () => questions[i],
      );

      summary.add(
        {
          'question_index': i,
          // 'question': questions[i].text,
          // 'correct_answer': questions[i].answers[0], 
          // 'user_answer': chosenAnswers[i]
          'question': question.text,
          'correct_answer': question.answers[0],
          'user_answer': UserAnswer.answer,
        },
      );
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You Answered $numCorrectQuestions out of $numTotalQuestions correctly !',
                style: const TextStyle(color: Colors.white,fontSize: 22,),
              ),
              const SizedBox(
                height: 30,
              ),
              QuestionsSummary(getSummaryData()),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: onRestart,
                child: const Text(
                  'Restart Quiz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}