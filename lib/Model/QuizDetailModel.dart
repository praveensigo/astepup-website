class QuizDetailsModel {
  int stageId;
  String stageName;
  String stageDescription;
  int noOfQuestion;
  List<Question> questions;
  QuizCriteria quizCriteria;

  QuizDetailsModel({
    required this.stageId,
    required this.stageName,
    required this.stageDescription,
    required this.noOfQuestion,
    required this.questions,
    required this.quizCriteria,
  });

  factory QuizDetailsModel.fromJson(Map<String, dynamic> json) =>
      QuizDetailsModel(
        stageId: json["stage_id"],
        stageName: json["stage_name"],
        stageDescription: json["stage_description"],
        noOfQuestion: json["no_of_question"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        quizCriteria: QuizCriteria.fromJson(json["quiz_criteria"]),
      );

  Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage_name": stageName,
        "stage_description": stageDescription,
        "no_of_question": noOfQuestion,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "quiz_criteria": quizCriteria.toJson(),
      };
}

class Question {
  int questionId;
  String question;
  String answer;
  String answerExplanation;
  String duration;
  List<Choice> choices;
  Choice? selectedChoice;

  Question({
    required this.questionId,
    required this.question,
    required this.answer,
    required this.answerExplanation,
    required this.duration,
    required this.choices,
    this.selectedChoice,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
      questionId: json["question_id"],
      question: json["question"],
      answer: json["answer"],
      answerExplanation: json["answer_explanation"],
      duration: json["duration"],
      choices:
          List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      selectedChoice: json["selectedChoice"] == null
          ? null
          : Choice.fromJson(json["selectedChoice"]));

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question": question,
        "answer": answer,
        "answer_explanation": answerExplanation,
        "duration": duration,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        'selectedChoice': selectedChoice
      };
}

class Choice {
  int choiceId;
  String choice;

  Choice({
    required this.choiceId,
    required this.choice,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        choiceId: json["choice_id"],
        choice: json["choice"],
      );

  Map<String, dynamic> toJson() => {
        "choice_id": choiceId,
        "choice": choice,
      };
}

class QuizCriteria {
  String stagePercentage;
  int stageExplanation;

  QuizCriteria({
    required this.stagePercentage,
    required this.stageExplanation,
  });

  factory QuizCriteria.fromJson(Map<String, dynamic> json) => QuizCriteria(
        stagePercentage: json["percentage"],
        stageExplanation: json["explanation"],
      );

  Map<String, dynamic> toJson() => {
        "percentage": stagePercentage,
        "explanation": stageExplanation,
      };
}
