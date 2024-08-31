import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Resource/Strings.dart';

import 'package:astepup_website/Resource/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Utils/Utils.dart';

class SummeryBuilderWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final int quizNumber;
  final ReviewQuestion quizData;
  final Function()? feedbackCallBack;
  final Function()? retakeFunctionCallback;
  final Function()? nextFunctionCallback;

  const SummeryBuilderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.quizNumber,
    required this.quizData,
    this.feedbackCallBack,
    this.retakeFunctionCallback,
    this.nextFunctionCallback,
  });

  @override
  State<SummeryBuilderWidget> createState() => _SummeryBuilderWidgetState();
}

class _SummeryBuilderWidgetState extends State<SummeryBuilderWidget> {
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 950
                ? size.width * 0.05
                : size.width * 0.05,
            vertical: size.width * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width < 950 ? 10 : 20),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.width < 950 ? 5 : 15,
                      horizontal:
                          MediaQuery.of(context).size.width < 950 ? 5 : 15,
                    ),
                  ),
                  child: Text('FEEDBACK',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: MediaQuery.of(context).size.width < 950
                              ? 10
                              : 15)),
                  onPressed: () => feedbackDialog(context),
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(
              widget.subtitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width < 950 ? 10 : 20),
            ),
            const SizedBox(height: 25),
            QuestionWidgetItem(
                questionIndex: widget.quizNumber,
                reviewQuestion: widget.quizData),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * .2, 50)),
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    "GO  BACK",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    ));
  }

  void feedbackDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          final formKey = GlobalKey<FormState>();
          var size = MediaQuery.of(context).size;
          return Center(
              child: Form(
            key: formKey,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: const BoxConstraints(minWidth: 360),
                width: size.width * .45,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Text(
                      "Feedback",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      maxLines: 5,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your feedback";
                        }
                        return null;
                      },
                      controller: feedbackController,
                      decoration: InputDecoration(
                          hintText: 'Feedback here',
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                          onPressed: widget.feedbackCallBack ??
                              () async {
                                if (formKey.currentState!.validate()) {
                                  FormData data = FormData.fromMap({
                                    "feedback": feedbackController.text.trim(),
                                    "stage_id":
                                        getSavedObject(StorageKeys.stageId),
                                  });
                                  await Get.find<LessonController>()
                                      .updateUserFeedback(
                                          endPoint:
                                              ApiEndPoints.updateStagefeedback,
                                          data: data);
                                  if (context.mounted) {
                                    feedbackController.clear();
                                    Navigator.pop(context);
                                  }
                                }
                              },
                          child: Text(
                            "Send",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ));
        });
  }
}

class ReviewQuestion {
  final String question;
  final String answers;
  ReviewQuestion({
    required this.question,
    required this.answers,
  });

  ReviewQuestion copyWith({
    String? question,
    String? answers,
  }) {
    return ReviewQuestion(
      question: question ?? this.question,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
    };
  }

  factory ReviewQuestion.fromMap(Map<String, dynamic> map) {
    return ReviewQuestion(
      question: map['question'] ?? '',
      answers: map['answers'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewQuestion.fromJson(String source) =>
      ReviewQuestion.fromMap(json.decode(source));

  @override
  String toString() =>
      'ReviewQuestion(question: $question, answers: $answers,)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewQuestion &&
        other.question == question &&
        other.answers == answers;
  }

  @override
  int get hashCode => question.hashCode ^ answers.hashCode;
}

class QuestionWidgetItem extends StatelessWidget {
  final int questionIndex;
  final ReviewQuestion reviewQuestion;
  const QuestionWidgetItem({
    super.key,
    required this.questionIndex,
    required this.reviewQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$questionIndex. ",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width < 950 ? 10 : 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(reviewQuestion.question,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.width < 950
                                            ? 10
                                            : 20,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(reviewQuestion.answers,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.width < 950
                                            ? 6
                                            : 16)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
