class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.text,
    required this.answers,
  });

  final int id;
  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    // Membuat salinan list agar list asli tidak teracak
    final shuffledList = List.of(answers);
    // Mengacak urutan jawaban
    shuffledList.shuffle();
    return shuffledList;
  }
}