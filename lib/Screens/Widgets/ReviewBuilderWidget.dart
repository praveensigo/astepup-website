import 'package:flutter/material.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Screens/Widgets/LessonSections.dart';
import 'package:astepup_website/Screens/Widgets/QuestionIndicator.dart';
import 'package:astepup_website/Screens/Widgets/QuestionWidget.dart';

enum SelectedOption { a, b, c, d }

class ReviewBuilderWidget extends StatefulWidget {
  final String pageTitle;
  final int questionCount;
  final List<Question> questionList;
  final String buttonTitle;
  final int progressCounter;
  final Function()? onPressed;
  final Function(int)? onCurrenPageChange;
  final String nextRoute;
  const ReviewBuilderWidget({
    super.key,
    required this.pageTitle,
    this.questionCount = 5,
    required this.questionList,
    this.buttonTitle = "NEXT",
    this.progressCounter = 4,
    this.onPressed,
    this.onCurrenPageChange,
    required this.nextRoute,
  }) : assert(questionCount == questionList.length,
            "question list and question count should be same");

  @override
  State<ReviewBuilderWidget> createState() => _ReviewBuilderWidgetState();
}

class _ReviewBuilderWidgetState extends State<ReviewBuilderWidget> {
  int page = 0;
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
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .05, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .1),
                    width: double.infinity,
                    child: QuestionIndicator(
                      height: !sizeInfo.isDesktop ? 35 : 45,
                      paddingLine: const EdgeInsets.symmetric(horizontal: 0),
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
                const SizedBox(height: 15),
                Text(
                  widget.pageTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                QuestionWidget(
                  isDesktop: sizeInfo.isDesktop,
                  question: widget.questionList[page].question,
                  questionIndex: page + 1,
                  optionList: widget.questionList[page].choices,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 200, maxWidth: 400),
                      child: ElevatedButton(
                          onPressed: widget.onPressed ??
                              () {
                                print("fgjh");
                                print(widget.questionList[page].question);
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AnswerDialogWidget(
                                //         isCorrectAnswer: page % 2 == 0,
                                //         onPressed: () {
                                //           if (page < widget.questionCount - 1) {
                                //             page += 1;
                                //           } else {
                                //             GoRouter.of(context)
                                //                 .go(widget.nextRoute);
                                //             page = 0;
                                //           }
                                //           Navigator.pop(context);
                                //           setState(() {});
                                //         },
                                //       );
                                //     });
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
      }),
    );
  }
}
