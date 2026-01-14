import 'package:flutter/material.dart';
import 'package:praktikum_android_7m/models/quiz_question.dart';
import 'package:praktikum_android_7m/models/user_answer.dart'; // Import model UserAnswer
import 'package:praktikum_android_7m/question_summary.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
    required this.questions,
  });

  // UBAH TIPE DATA DI SINI (Sesuai Gambar baris 15)
  // Dari List<String> menjadi List<UserAnswer>
  final List<UserAnswer> chosenAnswers;
  
  final void Function() onRestart;
  final List<QuizQuestion> questions;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      // Ambil objek UserAnswer
      final userAnswer = chosenAnswers[i];

      // Cari pertanyaan yang ID-nya cocok dengan jawaban user (Sesuai Gambar baris 25-28)
      final question = questions.firstWhere(
        (q) => q.id == userAnswer.questionId,
        orElse: () => questions[i], // Fallback jika tidak ketemu
      );

      summary.add(
        {
          'question_index': i,
          'question': question.text,
          // Jawaban benar diambil dari indeks ke-0 array answers
          'correct_answer': question.answers[0], 
          // Jawaban user diambil dari properti .answer pada objek UserAnswer
          'user_answer': userAnswer.answer,
        },
      );
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = questions.length;
    
    // Hitung jawaban benar
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You Answered $numCorrectQuestions out of $numTotalQuestions correctly!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionsSummary(summaryData),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}