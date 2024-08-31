import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Resource/Strings.dart';

import '../../Controller/QuizController.dart';
import '../../Controller/SidebarManager.dart';
import '../../Model/QuestionSummaryModel.dart';
import '../../Resource/CustomIcons.dart';
import '../../Resource/colors.dart';
import '../../Utils/Utils.dart';
import 'LessonSections.dart';
import 'PercentageWidget.dart';

enum CurrentQuiz { section, module, stage, mastery }

class ReviewAnswerWidget extends StatefulWidget {
  final String? retake;
  final String title;
  final String totalPercentage;
  final CurrentQuiz currentQuiz;
  final List<QuestionSummary> answersList;
  final Function()? feedbackCallBack;
  final Function()? retakeFunctionCallback;
  final Function()? nextFunctionCallback;
  final Widget? nextWidget;
  final Widget? retakeWidget;
  final VoidCallback? feedbackWidget;
  const ReviewAnswerWidget(
      {super.key,
      required this.title,
      required this.totalPercentage,
      required this.answersList,
      this.feedbackCallBack,
      this.retakeFunctionCallback,
      this.nextFunctionCallback,
      this.retake,
      required this.currentQuiz,
      this.nextWidget,
      this.retakeWidget,
      this.feedbackWidget})
      : assert(retake != null || retakeWidget != null,
            "retake path and retake widget both can't be null ");

  @override
  State<ReviewAnswerWidget> createState() => _ReviewAnswerWidgetState();
}

class _ReviewAnswerWidgetState extends State<ReviewAnswerWidget> {
  final Map<String, dynamic> quizData =
      getSavedObject(StorageKeys.quizData) as Map<String, dynamic>;
  @override
  Widget build(BuildContext context) {
    int quizPercentageChecker =
        convertStringToInteger(quizData['quiz_criteria']["percentage"]);
    getroute(context);
    var size = MediaQuery.of(context).size;
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: sizeInfo.isDesktop ? 45 : 25,
              vertical: sizeInfo.isDesktop ? 15 : 10),
          child: LessonSectionLayout(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: sizeInfo.isDesktop
                              ? Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)
                              : Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6))),
                        onPressed: widget.feedbackWidget,
                        child: Text(
                          'FEEDBACK',
                          style: sizeInfo.isDesktop
                              ? Theme.of(context).textTheme.bodyLarge
                              : Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Total Score: ${widget.totalPercentage}%",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  if (quizPercentageChecker != 0)
                    Text.rich(
                      TextSpan(text: "Result: ", children: [
                        TextSpan(
                            text: getResultBool(
                                    userPercentage:
                                        int.parse(widget.totalPercentage),
                                    checkPercentage: quizPercentageChecker)
                                ? "Pass"
                                : "Fail",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: getResultColor(
                                        userPercentage:
                                            int.parse(widget.totalPercentage),
                                        checkPercentage:
                                            quizPercentageChecker)))
                      ]),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 25),
                  ListView.separated(
                      padding: const EdgeInsets.only(right: 15),
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 30),
                      shrinkWrap: true,
                      itemCount: widget.answersList.length,
                      itemBuilder: (_, i) {
                        return QuestionWidgetItem(
                            title: widget.title,
                            userPercentage: int.parse(widget.totalPercentage),
                            questionIndex: i + 1,
                            currentQuiz: widget.currentQuiz,
                            reviewQuestion: widget.answersList[i]);
                      }),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: getResultBool(
                            userPercentage: int.parse(
                                Get.find<QuizController>().quizPercetage),
                            checkPercentage: quizPercentageChecker)
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceAround,
                    children: [
                      widget.retakeWidget ??
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(size.width / 5, 50)),
                              onPressed: () {
                                removename(StorageKeys.quizList);
                                var sideMenuManager =
                                    Get.find<SideMenuManager>();
                                GoRouter.of(context)
                                    .go(widget.retake ?? "/", extra: {
                                  'mid': sideMenuManager
                                          .selectedItem?.idMapper?.moduleId ??
                                      "",
                                  'sid': sideMenuManager
                                          .selectedItem?.idMapper?.stageId ??
                                      "",
                                  'cid':
                                      getSavedObject(StorageKeys.courseId) ?? ""
                                });
                              },
                              child: Text(
                                "RETAKE",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )),
                      const SizedBox(width: 10),
                      PercentageWidgetBuilder(
                          userPercentage: int.parse(
                              Get.find<QuizController>().quizPercetage),
                          checkPercentage: quizPercentageChecker,
                          child: widget.nextWidget ??
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(size.width / 5, 50)),
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .go('/lesson/stage-answer-explain');
                                  },
                                  child: Text(
                                    widget.currentQuiz == CurrentQuiz.mastery
                                        ? "Home"
                                        : "NEXT",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )))
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }

  void feedbackDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          return Center(
              child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: const BoxConstraints(minWidth: 360),
              width: size.width * .45,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                            () {
                              Navigator.pop(context);
                            },
                        child: const Text("Send")),
                  )
                ],
              ),
            ),
          ));
        });
  }
}

class QuestionWidgetItem extends StatelessWidget {
  final int questionIndex;
  final int userPercentage;
  final String title;
  final CurrentQuiz currentQuiz;
  final QuestionSummary reviewQuestion;
  QuestionWidgetItem({
    super.key,
    required this.questionIndex,
    required this.title,
    required this.userPercentage,
    required this.currentQuiz,
    required this.reviewQuestion,
  });
  final Map<String, dynamic> quizCriteria =
      getSavedObject(StorageKeys.quizData)['quiz_criteria']
          as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    int quizPercentageChecker =
        convertStringToInteger(quizCriteria["percentage"]);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$questionIndex. ",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(height: 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      reviewQuestion.question,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(height: 2, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 15),
                  if (getResultBool(
                          userPercentage: userPercentage,
                          checkPercentage: quizPercentageChecker) &&
                      quizCriteria['explanation'] == 1)
                    IconButton(
                        onPressed: () {
                          context.push('/lesson/answer-summery', extra: {
                            'quiz_id': reviewQuestion.questionId,
                            'quiz_title': title,
                            'quiz_index': questionIndex,
                          });
                        },
                        icon: SvgPicture.asset(
                          CustomIcons.search,
                          width: 25,
                        ))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        !reviewQuestion.isCorrect
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.cancel, color: red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      reviewQuestion.answers,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      reviewQuestion.answers,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              )
      ],
    );
  }
}
