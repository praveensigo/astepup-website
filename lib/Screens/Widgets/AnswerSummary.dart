import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Model/QuestionExplanationModel.dart';

import 'LessonSections.dart';
import 'SummaryBuilder.dart';

class AnswerSummaryPage extends StatefulWidget {
  final String quizId;
  final String title;
  final int quizIndex;
  const AnswerSummaryPage({
    super.key,
    required this.quizId,
    required this.title,
    required this.quizIndex,
  });

  @override
  State<AnswerSummaryPage> createState() => _AnswerSummaryPageState();
}

class _AnswerSummaryPageState extends State<AnswerSummaryPage> {
  QuizExplainModel? quizData;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      didChangeDependencies: (state) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          quizData =
              await state.controller?.answerExplanationAPI(widget.quizId);
          state.controller?.update();
        });
      },
      builder: (controller) {
        return LessonSectionLayout(
            body: Center(
          child: controller.isLoading.value
              ? const CircularProgressIndicator()
              : quizData == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Something went wrong. I could not find the\n question details. Please try again.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            onPressed: () async {
                              quizData = await controller
                                  .answerExplanationAPI(widget.quizId);
                              controller.update();
                            },
                            child: Text(
                              "Try again",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  : SummeryBuilderWidget(
                      title: widget.title,
                      subtitle: 'Answer Explanation',
                      quizNumber: widget.quizIndex,
                      quizData: ReviewQuestion(
                        question: quizData?.question ?? "",
                        answers: quizData?.answerExplanation ?? "",
                      ),
                    ),
        ));
      },
    );
  }
}
