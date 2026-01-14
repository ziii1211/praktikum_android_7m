import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktikum_android_7m/answer_button.dart';
import 'package:praktikum_android_7m/models/quiz_question.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectedAnswer,
    required this.questions,
  });

  // Nanti mungkin perlu diubah untuk mengirim ID juga, 
  // tapi untuk sekarang kita biarkan String dulu agar tidak error.
  final void Function(String answer) onSelectedAnswer;
  final List<QuizQuestion> questions;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswer) {
    widget.onSelectedAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 215, 196, 249),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // PERBAIKAN DISINI: 
            // Ubah 'getSuffledAnswer' menjadi 'getShuffledAnswers' (Sesuai model)
            ...currentQuestion.getShuffledAnswers().map(
              (item) {
              return Container(
                margin: const EdgeInsets.all(5),
                child: AnswerButton(
                  text: item,
                  onTap: () {
                    answerQuestion(item);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}