class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.text,
    required this.answers,
  });

  final int id;
  final String text;
  final List<String> answers;

  List<String> getSuffledAnswer() {
    final shuffledlist = List.of(answers);
    shuffledlist.shuffle();
    return shuffledlist;
  }
}