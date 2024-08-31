class EvaluationSurveyModel {
  int id;
  String question;
  int type;
  List<ChoiceEvaluation> choices;
  ChoiceEvaluation? selectedChoice;

  EvaluationSurveyModel({
    required this.id,
    required this.question,
    required this.type,
    required this.choices,
    this.selectedChoice,
  });

  factory EvaluationSurveyModel.fromJson(Map<String, dynamic> json) =>
      EvaluationSurveyModel(
          id: json["id"],
          question: json["question"],
          type: json["type"],
          choices: List<ChoiceEvaluation>.from(
              json["choices"].map((x) => ChoiceEvaluation.fromJson(x))),
          selectedChoice: null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "type": type,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        'selectedChoice': null
      };
}

class ChoiceEvaluation {
  int id;
  int evaluationId;
  String choice;
  int choiceId;

  ChoiceEvaluation({
    required this.id,
    required this.evaluationId,
    required this.choice,
    required this.choiceId,
  });

  factory ChoiceEvaluation.fromJson(Map<String, dynamic> json) =>
      ChoiceEvaluation(
        id: json["id"],
        evaluationId: json["evaluation_id"],
        choice: json["choice"],
        choiceId: json['choice_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "evaluation_id": evaluationId,
        "choice": choice,
        "choice_id": choiceId
      };
}
