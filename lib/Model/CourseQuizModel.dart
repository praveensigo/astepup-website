class StageQuiz {
  final int id;
  final int quizCount;
  final String quizTitle;
  StageQuiz({
    required this.id,
    required this.quizCount,
    required this.quizTitle,
  });
}

class ModuleQuiz {
  final int id;
  final int quizCount;
  final String quizTitle;
  ModuleQuiz({
    required this.id,
    required this.quizCount,
    required this.quizTitle,
  });
}

class FinalMastery {
  final int id;
  final int quizCount;
  final String quizTitle;
  final int currentIndex;
  FinalMastery({
    required this.id,
    required this.quizCount,
    required this.quizTitle,
    required this.currentIndex,
  });
}
