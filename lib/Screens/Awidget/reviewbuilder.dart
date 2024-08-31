import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Awidget/questionwidget.dart';
import 'package:astepup_website/Screens/Widgets/AnswerDialog.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:astepup_website/Screens/Widgets/LessonSections.dart';
import 'package:astepup_website/Screens/Widgets/QuestionIndicator.dart';

class QuizReviewBuilderWidget extends StatefulWidget {
  final String route;
  final String quizId;
  final String pageTitle;
  final int questionCount;
  final List<Question> questionList;
  final String buttonTitle;
  final int progressCounter;
  final Function()? onPressed;
  final Function(int)? onCurrenPageChange;
  final String nextRoute;
  const QuizReviewBuilderWidget({
    super.key,
    required this.pageTitle,
    this.questionCount = 5,
    required this.questionList,
    this.buttonTitle = "NEXT",
    this.progressCounter = 4,
    this.onPressed,
    this.onCurrenPageChange,
    required this.nextRoute,
    required this.quizId,
    required this.route,
  }) : assert(questionCount == questionList.length,
            "question list and question count should be same");

  @override
  State<QuizReviewBuilderWidget> createState() =>
      _FinalMasteryQuizReviewBuilderWidgetState();
}

class _FinalMasteryQuizReviewBuilderWidgetState
    extends State<QuizReviewBuilderWidget> {
  int page = 0;
  bool showToastEnabled = true;

  bool validationResult = false;
  @override
  void initState() {
    list = List.generate(widget.questionCount, (index) => index);
    super.initState();
  }

  late List list;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return LessonSectionLayout(
        body: ResponsiveBuilder(builder: (context, sizeInfo) {
      return GetBuilder<QuizController>(
          initState: (_) {},
          builder: (controller) {
            return SingleChildScrollView(
              child: widget.questionList.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AssetManager.nocourse),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "We are currently having some problems with the quiz.\n Please give it another go later.",
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  }
                                },
                                child: Text(
                                  "Go Back",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .05, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .1),
                              width: double.infinity,
                              child: QuestionIndicator(
                                height: !sizeInfo.isDesktop ? 35 : 45,
                                paddingLine:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                padding: const EdgeInsets.all(4),
                                list: list,
                                division: widget.progressCounter,
                                onChange: (i) {},
                                page: page,
                                onClickItem: (p0) {
                                  setState(() {
                                    page = p0;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            widget.pageTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 25),
                          ),
                          const SizedBox(height: 25),
                          QuestionWidget(
                            isDesktop: sizeInfo.isDesktop,
                            questionData: widget.questionList[page],
                            questionIndex: page + 1,
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minWidth: 200, maxWidth: 400),
                                child: ElevatedButton(
                                    onPressed: widget.onPressed ??
                                        () async {
                                          if (controller.optionid == "" ||
                                              controller.optionid == null) {
                                            if (showToastEnabled) {
                                              showToast(Strings.chooseAnAnswer);
                                              showToastEnabled = false;
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 4300), () {
                                                showToastEnabled = true;
                                              });
                                            }
                                          } else {
                                            if (widget.route == "course") {
                                              validationResult =
                                                  await controller
                                                      .coursequizValidation(
                                                widget.quizId,
                                                widget.questionList[page]
                                                    .questionId
                                                    .toString(),
                                              );
                                              if (validationResult == true ||
                                                  validationResult == false) {
                                                if (page <
                                                    widget.questionCount - 1) {
                                                  page += 1;
                                                } else {
                                                  controller.quizPercetage =
                                                      calculateQuizPercentage();
                                                  if (context.mounted) {
                                                    GoRouter.of(context)
                                                        .go(widget.nextRoute);
                                                  }
                                                  page = 0;
                                                }
                                                // Navigator.pop(context);
                                                // Navigator.pop(context);
                                                setState(() {});
                                              }
                                              // Navigator.pop(context);
                                            } else if (widget.route ==
                                                "section") {
                                              validationResult =
                                                  await controller
                                                      .sectionquizValidation(
                                                context,
                                                widget.quizId,
                                                widget.questionList[page]
                                                    .questionId
                                                    .toString(),
                                              );
                                            } else if (widget.route ==
                                                "module") {
                                              validationResult =
                                                  await controller
                                                      .modulequizValidation(
                                                context,
                                                widget.quizId,
                                                widget.questionList[page]
                                                    .questionId
                                                    .toString(),
                                              );
                                            } else if (widget.route ==
                                                "stage") {
                                              validationResult =
                                                  await controller
                                                      .stagequizValidation(
                                                widget.quizId,
                                                widget.questionList[page]
                                                    .questionId
                                                    .toString(),
                                              );
                                              if (validationResult == true ||
                                                  validationResult == false) {
                                                if (page <
                                                    widget.questionCount - 1) {
                                                  page += 1;
                                                } else {
                                                  controller.quizPercetage =
                                                      calculateQuizPercentage();
                                                  if (context.mounted) {
                                                    GoRouter.of(context)
                                                        .go(widget.nextRoute);
                                                  }
                                                  page = 0;
                                                }
                                                // Navigator.pop(context);
                                                // Navigator.pop(context);
                                                setState(() {});
                                              }
                                              // Navigator.pop(context);
                                            }
                                            if (widget.route == "section" ||
                                                widget.route == "module") {
                                              if (context.mounted) {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return AnswerDialogWidget(
                                                        message: controller
                                                            .errorMessage,
                                                        isCorrectAnswer:
                                                            validationResult,
                                                        onPressed: () {
                                                          if (page <
                                                              widget.questionCount -
                                                                  1) {
                                                            page += 1;
                                                          } else {
                                                            controller
                                                                    .quizPercetage =
                                                                calculateQuizPercentage();
                                                            GoRouter.of(context)
                                                                .go(widget
                                                                    .nextRoute);
                                                            page = 0;
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        },
                                                      );
                                                    });
                                              }
                                            }
                                          }
                                        },
                                    child: Text(
                                      widget.buttonTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                    ))),
                          ),
                        ],
                      ),
                    ),
            );
          });
    }));
  }

  String calculateQuizPercentage() {
    int correctCount = 0;
    for (int i = 0; i < widget.questionList.length; i++) {
      if ((widget.questionList[i].selectedChoice?.choice ?? "") ==
          widget.questionList[i].answer) {
        correctCount++;
      }
    }
    String percentage =
        ((correctCount / widget.questionList.length) * 100).toStringAsFixed(0);
    savename(StorageKeys.quizPercentage, percentage);
    return percentage;
  }
}
