import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:praktikum_android_7m/models/quiz_question.dart'; // HAPUS INI: Tidak digunakan

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.startQuiz,
    required this.profile,
  });

  final void Function() startQuiz;
  final void Function() profile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CARA PRO: Gunakan color & blendMode untuk transparansi gambar
          // Ini lebih ringan daripada membungkus dengan widget Opacity
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(150, 255, 255, 255), // Transparansi (~0.6 opacity)
            colorBlendMode: BlendMode.modulate,
          ),
          const SizedBox(height: 80),
          Text(
            'Learn Flutter the fun Way!',
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 237, 223, 252),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          // Tombol Start Quiz
          OutlinedButton.icon(
            onPressed: startQuiz,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              // Tambah padding biar tombol lebih 'berisi'
              padding: const EdgeInsets.symmetric(
                vertical: 12, 
                horizontal: 20
              ), 
            ),
            icon: const Icon(Icons.arrow_right_alt),
            label: const Text('Start Quiz'),
          ),
          const SizedBox(height: 15),
          // Tombol Profile
          OutlinedButton.icon(
            onPressed: profile,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 12, 
                horizontal: 20
              ),
            ),
            icon: const Icon(Icons.person), // Gunakan icon person yang umum
            label: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}