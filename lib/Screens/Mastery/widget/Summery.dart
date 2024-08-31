import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Model/QuestionSummaryModel.dart';
import 'package:astepup_website/Resource/colors.dart';

class SummeryWidget extends StatefulWidget {
  final String result;
  final String title;
  final String totalPercentage;
  final List<QuestionSummary> answersList;
  final Function()? feedbackCallBack;
  final Function()? retakeFunctionCallback;
  final Function()? nextFunctionCallback;

  const SummeryWidget({
    super.key,
    required this.title,
    required this.totalPercentage,
    required this.answersList,
    this.feedbackCallBack,
    this.retakeFunctionCallback,
    this.nextFunctionCallback,
    required this.result,
  });

  @override
  State<SummeryWidget> createState() => _SummeryWidgetState();
}

class _SummeryWidgetState extends State<SummeryWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: MediaQuery.of(context).size.width < 950
            ? AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                    onPressed: () {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              )
            : null,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width < 950
                              ? 10
                              : 25),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width *
                              0.01, // Adjust the multiplier as needed
                          horizontal: MediaQuery.of(context).size.width *
                              0.02, // Adjust the multiplier as needed
                        ),
                      ),
                      child: Text('FEEDBACK',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: size.width * 0.02)),
                      onPressed: () => feedbackDialog(context),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Total Score: ${widget.totalPercentage}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  "Result: ${widget.result}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    shrinkWrap: true,
                    itemCount: widget.answersList.length,
                    itemBuilder: (_, i) {
                      return QuestionWidgetItem(
                          questionIndex: i + 1,
                          reviewQuestion: widget.answersList[i]);
                    }),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width / 2, 50),
                      ),
                      onPressed: () {},
                      child: Text(
                        "RETAKE",
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
  final QuestionSummary reviewQuestion;
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
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reviewQuestion.question,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reviewQuestion.isCorrect
                ? const Icon(Icons.check_circle, color: green)
                : const Icon(Icons.cancel, color: red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reviewQuestion.answers,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        )
      ],
    );
  }
}
