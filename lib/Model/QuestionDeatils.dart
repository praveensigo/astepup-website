import 'dart:convert';

class QuestionExplanation {
  final String question;
  final String explanation;
  QuestionExplanation({
    required this.question,
    required this.explanation,
  });

  QuestionExplanation copyWith({
    String? question,
    String? answers,
  }) {
    return QuestionExplanation(
      question: question ?? this.question,
      explanation: answers ?? explanation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': explanation,
    };
  }

  factory QuestionExplanation.fromMap(Map<String, dynamic> map) {
    return QuestionExplanation(
      question: map['question'] ?? '',
      explanation: map['answers'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionExplanation.fromJson(String source) =>
      QuestionExplanation.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuestionExplanation(question: $question, answers: $explanation, )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionExplanation &&
        other.question == question &&
        other.explanation == explanation;
  }

  @override
  int get hashCode => question.hashCode;
}
