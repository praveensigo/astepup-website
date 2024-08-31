import 'dart:convert';
import 'package:flutter/foundation.dart';

class Question {
  String question;
  List<String> options;
  Question({
    required this.question,
    required this.options,
  });

  Question copyWith({
    String? question,
    List<String>? options,
  }) {
    return Question(
      question: question ?? this.question,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      options: List<String>.from(map['options']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));

  @override
  String toString() => 'Question(question: $question, options: $options)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.question == question &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode => question.hashCode ^ options.hashCode;
}
