import 'package:flutter/material.dart';
import 'package:praktikum_android_7m/home_screen.dart';
import 'package:praktikum_android_7m/models/user_answer.dart'; 
import 'package:praktikum_android_7m/profile.dart';
import 'package:praktikum_android_7m/questions_screen.dart';
import 'package:praktikum_android_7m/result_screen.dart';
import 'package:praktikum_android_7m/services/question_api_service.dart';
import 'package:praktikum_android_7m/models/quiz_question.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start-screen';
  List<UserAnswer> selectedAnswers = []; 
  List<QuizQuestion> questions = [];
  bool isLoading = false;
  bool isSubmitting = false; 
  String? errorMessage;

  Future<void> chooseAnswer(int questionId, String answer) async {
    selectedAnswers.add(UserAnswer(questionId: questionId, answer: answer));

    if (selectedAnswers.length == questions.length) {
      setState(() {
        isSubmitting = true;
      });

      try {
        final apiService = QuestionApiService();
        final answersJson = selectedAnswers.map((a) => a.toJson()).toList();
        
        final response = await apiService.submitAnswers(answersJson);
        
        print('Submission successful: $response');
      } catch (e) {
        print('Failed to submit answers: $e');
        print('Continuing to result screen with local data');
      } finally {
        setState(() {
          activeScreen = 'result-screen';
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

  void profileScreen() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'profile-screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget;

    if (isLoading || isSubmitting) {
      final loadingText = isSubmitting 
          ? 'Submitting answers...' 
          : 'Loading questions...';

      screenWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              loadingText, 
              style: const TextStyle(color: Colors.white)
            ),
          ],
        ),
      );
    } else if (errorMessage != null) {
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
    } else {
      screenWidget = HomeScreen(
        startQuiz: switchScreen,
        profile: profileScreen,
      );
    }

    if (!isLoading && errorMessage == null && !isSubmitting) {
      if (activeScreen == 'questions-screen') {
        screenWidget = QuestionsScreen(
          onSelectedAnswer: chooseAnswer, 
          questions: questions,
        );
      }

      if (activeScreen == 'result-screen') {
        screenWidget = ResultScreen(
          // PERBAIKAN: Kirim selectedAnswers langsung (Tipe datanya sudah List<UserAnswer>)
          chosenAnswers: selectedAnswers, 
          onRestart: restartQuiz,
          questions: questions,
        );
      }

      if (activeScreen == 'profile-screen') {
        screenWidget = const Profile();
      }
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple],
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