import 'dart:convert';

class QuestionSummary {
  final String? questionId;
  final String question;
  final String answers;
  final String? currentAnswer;
  final bool isCorrect;
  QuestionSummary({
    required this.question,
    this.questionId,
    required this.answers,
    this.currentAnswer,
    required this.isCorrect,
  });

  QuestionSummary copyWith(
      {String? question,
      String? answers,
      String? questionId,
      bool? isCorrect,
      String? currentAnswer}) {
    return QuestionSummary(
      question: question ?? this.question,
      answers: answers ?? this.answers,
      questionId: questionId ?? this.questionId,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
      'questionId': questionId,
      'isCorrect': isCorrect,
      'currentAnswer': currentAnswer,
    };
  }

  factory QuestionSummary.fromMap(Map<String, dynamic> map) {
    return QuestionSummary(
      question: map['question'] ?? '',
      answers: map['answers'] ?? '',
      currentAnswer: map['currentAnswer'] ?? '',
      questionId: map['questionId'] ?? '',
      isCorrect: map['isCorrect'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionSummary.fromJson(String source) =>
      QuestionSummary.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuestionSummary(question: $question, answers: $answers, isCorrect: $isCorrect)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionSummary &&
        other.question == question &&
        other.answers == answers &&
        other.currentAnswer == currentAnswer &&
        other.questionId == questionId &&
        other.isCorrect == isCorrect;
  }

  @override
  int get hashCode =>
      question.hashCode ^
      answers.hashCode ^
      isCorrect.hashCode ^
      currentAnswer.hashCode ^
      questionId.hashCode;
}
