class QuizExplainModel {
  int questionId;
  String question;
  String answer;
  String answerExplanation;

  QuizExplainModel({
    required this.questionId,
    required this.question,
    required this.answer,
    required this.answerExplanation,
  });

  factory QuizExplainModel.fromJson(Map<String, dynamic> json) =>
      QuizExplainModel(
        questionId: json["question_id"],
        question: json["question"],
        answer: json["answer"],
        answerExplanation: json["answer_explanation"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question": question,
        "answer": answer,
        "answer_explanation": answerExplanation,
      };
}
