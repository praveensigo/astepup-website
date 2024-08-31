class FaqModel {
    int id;
    String question;
    String answer;

    FaqModel({
        required this.id,
        required this.question,
        required this.answer,
    });

    factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
    };
}
