import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:astepup_website/Controller/EvaluationController.dart';
import 'package:astepup_website/Model/EvaluationSurvayModel.dart';
import 'package:astepup_website/Resource/colors.dart';

import '../../../Resource/Strings.dart';
import '../../../Utils/Utils.dart';

class EvaluationQuestionWidget extends StatefulWidget {
  final EvaluationSurveyModel questionData;
  final int questionIndex;
  final bool isDesktop;
  const EvaluationQuestionWidget({
    Key? key,
    required this.questionData,
    required this.questionIndex,
    required this.isDesktop,
  }) : super(key: key);

  @override
  State<EvaluationQuestionWidget> createState() =>
      _EvaluationQuestionWidgetState();
}

class _EvaluationQuestionWidgetState extends State<EvaluationQuestionWidget> {
  Widget optionBuilder(String option) {
    return Text(
      option,
      maxLines: 2,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EvaluationSurveyController>(
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
            if (widget.questionData.choices.isEmpty)
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: borderColorDark)),
                    fillColor: Colors.white,
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showToast(Strings.evaluationFillError);
                    return '';
                  }
                  return null;
                },
                onChanged: (value) {
                  int index = controller.dataArray.indexWhere(
                    (element) =>
                        element['evaluation_id'] == widget.questionData.id,
                  );
                  if (index != -1) {
                    controller.dataArray[index]['answer'] = value;
                  } else {
                    controller.dataArray.add({
                      'evaluation_id': widget.questionData.id,
                      'choice_id': "",
                      'answer': value,
                    });
                  }
                },
              )
            else
              Theme(
                data: ThemeData(
                  textTheme: GoogleFonts.poppinsTextTheme(),
                  radioTheme: RadioThemeData(
                    fillColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                child: FormBuilderRadioGroup<ChoiceEvaluation>(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2))),
                  name: '',
                  orientation: OptionsOrientation.vertical,
                  wrapDirection: Axis.vertical,
                  wrapRunSpacing: 45,
                  wrapSpacing: 45,
                  wrapRunAlignment: WrapAlignment.end,
                  validator: (value) {
                    if (value == null) {
                      showToast(Strings.evaluationFillError);
                      return '';
                    }
                    return null;
                  },
                  onChanged: (ChoiceEvaluation? value) {
                    if (value != null) {
                      setState(() {
                        controller.optionId = value.choiceId.toString();
                        widget.questionData.selectedChoice = value;
                        var existingEntryIndex = controller.dataArray
                            .indexWhere((element) =>
                                element['evaluation_id'] ==
                                widget
                                    .questionData.selectedChoice!.evaluationId);

                        if (existingEntryIndex != -1) {
                          controller.dataArray[existingEntryIndex]
                                  ['choice_id'] =
                              widget.questionData.selectedChoice!.choiceId;
                          controller.dataArray[existingEntryIndex]['answer'] =
                              "";
                        } else {
                          controller.dataArray.add({
                            'evaluation_id': widget
                                .questionData.selectedChoice!.evaluationId,
                            'choice_id':
                                widget.questionData.selectedChoice!.choiceId,
                            'answer': "",
                          });
                        }
                      });
                    }
                  },
                  options: widget.questionData.choices
                      .map((choice) => FormBuilderFieldOption(
                          value: choice,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              choice.choice,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(),
                            ),
                          )))
                      .toList(growable: false),
                ),
              ),
          ],
        );
      },
    );
  }
}
