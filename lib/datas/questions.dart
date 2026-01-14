import 'package:praktikum_android_7m/models/quiz_question.dart';

const questions = [
  QuizQuestion(
    id: 1, 
    text: 'Disebut apa blok penyusun utama UI Flutter?', 
    answers: [
      'Widgets',
      'Components',
      'Blocks',
      'Functions',
    ]
  ),
  QuizQuestion(
    id: 2,
    text: 'Bagaimana UI Flutter di "build" ?', 
    answers: [
      'Dengan menggabungkan widget dalam kode',
      'Dengan menggabungkan widget dalam visual editor',
      'Dengan mendefinisikan widget dalam config file',
      'Dengan menggunakan XCode untuk iOS dan Android Studio untuk Android',
    ]
  ),
  QuizQuestion(
    id: 3,
    text: 'Apa tujuan dari sebuah StatefulWidget?', 
    answers: [
      'Merubah UI saat data berubah',
      'Merubah data saat UI berubah',
      'Menabaikan perubahan data',
      'Merender UI dan tidak bergantung pada data',
    ]
  ),
  QuizQuestion(
    id: 4,
    text: 'Widget mana yang sebaiknya Anda coba gunakan lebih sering: StatelessWidget atau StatefulWidget ?',
    answers: [
      'StatelessWidget',
      'StatefulWidget',
      'Keduanya sama-sama bagus',
      'Bukan salahsatu dari keduanya',
    ],
  ),
  QuizQuestion(
    id: 5,
    text: 'Apa yang terjadi jika Anda mengubah data dalam StatelessWidget?',
    answers: [
      'UI tidak diperbarui',
      'UI diperbarui',
      'StatefulWidget terdekat diperbarui',
      'Semua StatefulWidgets turunan diperbarui',
    ],
  ),
  QuizQuestion(
    id: 6,
    text: 'Bagaimana Anda harus memperbarui data di dalam Widget Stateful?',
    answers: [
      'dengan memanggil setState()',
      'dengan memanggil updateData()',
      'dengan memanggil updateUI()',
      'dengan memanggil updateState()',
    ],
  ),
];