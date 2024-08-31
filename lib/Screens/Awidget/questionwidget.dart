import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';

class QuestionWidget extends StatefulWidget {
  final Question questionData;
  final int questionIndex;
  final bool isDesktop;
  const QuestionWidget({
    super.key,
    required this.questionData,
    required this.questionIndex,
    required this.isDesktop,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  Widget optionBuilder(String option) {
    return Text(
      option,
      maxLines: 2,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
    );
  }

  @override
  void initState() {
    getTempListData();
    super.initState();
  }

  List<dynamic> tempList = [];

  getTempListData() {
    Map<String, dynamic> data = getSavedObject(StorageKeys.quizList) ?? {};
    if (data.containsKey('quiz')) {
      tempList = data['quiz'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.questionIndex}. ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    widget.questionData.question,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Theme(
              data: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                radioTheme: RadioThemeData(
                  fillColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.questionData.choices.length,
                  (index) => RadioListTile<String?>(
                    value:
                        widget.questionData.choices[index].choiceId.toString(),
                    groupValue: controller.optionid,
                    onChanged: (String? value) {
                      setState(() {
                        controller.optionid = value!;
                        widget.questionData.selectedChoice =
                            widget.questionData.choices[index];
                      });
                      for (var e in tempList) {
                        if (e['question_id'] ==
                            widget.questionData.questionId) {
                          e['selectedChoice'] =
                              widget.questionData.choices[index].toJson();
                        }
                      }
                      savename(StorageKeys.quizList, {'quiz': tempList});
                    },
                    title: optionBuilder(
                        widget.questionData.choices[index].choice),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
