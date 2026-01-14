import 'package:flutter/material.dart';
import 'package:praktikum_android_7m/home_screen.dart';
import 'package:praktikum_android_7m/profile.dart';
import 'package:praktikum_android_7m/questions_screen.dart';
import 'package:praktikum_android_7m/result_screen.dart';
import 'package:praktikum_android_7m/services/question_api_service.dart';
import 'package:praktikum_android_7m/models/quiz_question.dart';
import 'package:praktikum_android_7m/models/user_answer.dart'; // Pastikan import ini ada

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start-screen';
  // Ubah menjadi List<UserAnswer> sesuai gambar
  List<UserAnswer> selectedAnswers = []; 
  List<QuizQuestion> questions = [];
  bool isLoading = false;
  // Tambahkan state untuk proses submit
  bool isSubmitting = false; 
  String? errorMessage;

  // Fungsi chooseAnswer diperbarui untuk menerima id dan string answer
  Future<void> chooseAnswer(int questionId, String answer) async {
    // Tambahkan jawaban dalam bentuk object UserAnswer
    selectedAnswers.add(UserAnswer(questionId: questionId, answer: answer));

    if (selectedAnswers.length == questions.length) {
      // Jika semua soal sudah dijawab, kirim ke server
      setState(() {
        isSubmitting = true;
      });

      try {
        final apiService = QuestionApiService();
        // Ubah list jawaban menjadi format JSON
        final answersJson = selectedAnswers.map((a) => a.toJson()).toList();
        
        // Panggil fungsi submit (Pastikan fungsi ini ada di QuestionApiService Anda)
        // Jika error 'submitAnswers' tidak ditemukan, Anda perlu menambahkannya di service.
        await apiService.submitAnswers(answersJson); 

        print('Submission successful');
        
        setState(() {
          activeScreen = 'result-screen';
        });
      } catch (e) {
        print('Failed to submit answers: $e');
        print('Continuing to result screen with local data');
        // Tetap pindah ke result screen meskipun gagal submit (opsional, sesuai kebutuhan)
        setState(() {
          activeScreen = 'result-screen';
        });
      } finally {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<void> switchScreen() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiService = QuestionApiService();
      final fetchedQuestions = await apiService.fetchQuestions();

      setState(() {
        questions = fetchedQuestions;
        activeScreen = 'questions-screen';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load questions: $e';
        isLoading = false;
      });
    }
  }

  Future<void> restartQuiz() async {
    setState(() {
      selectedAnswers = [];
      isLoading = true;
      errorMessage = null;
      activeScreen = 'questions-screen'; // Langsung set screen agar tidak flicker
    });

    try {
      final apiService = QuestionApiService();
      final fetchedQuestions = await apiService.fetchQuestions();

      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load questions: $e';
        isLoading = false;
      });
    }
  }

  void profileScreen() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'profile-screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = HomeScreen(
      startQuiz: switchScreen,
      profile: profileScreen,
    );

    // Logika Loading Tampilan Baru (Sesuai Gambar 5)
    if (isLoading || isSubmitting) {
      final loadingText = isSubmitting 
          ? 'Submitting answers...' 
          : 'Loading questions...';

      return MaterialApp(
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    loadingText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      screenWidget = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                  });
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    } else if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        // Pastikan QuestionsScreen Anda sudah diperbarui untuk menerima 
        // fungsi dengan parameter (int id, String answer)
        onSelectedAnswer: chooseAnswer,
        questions: questions,
      );
    } else if (activeScreen == 'result-screen') {
      screenWidget = ResultScreen(
        chosenAnswers: selectedAnswers,
        onRestart: restartQuiz,
        questions: questions,
      );
    } else if (activeScreen == 'profile-screen') {
      screenWidget = const Profile();
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}