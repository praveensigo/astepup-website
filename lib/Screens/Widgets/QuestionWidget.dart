import 'package:flutter/material.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ReviewBuilderWidget.dart';

class QuestionWidget extends StatefulWidget {
  final String question;
  final List<Choice> optionList;
  final int questionIndex;
  final bool isDesktop;
  const QuestionWidget({
    Key? key,
    required this.question,
    required this.optionList,
    required this.questionIndex,
    required this.isDesktop,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  SelectedOption? _selectedOption = SelectedOption.a;

  Widget optionBuilder(String option) {
    return Text(
      option,
      maxLines: 2,
      style:
          // !widget.isDesktop
          //     ? Theme.of(context).textTheme.bodyMedium!.copyWith()
          //     :
          Theme.of(context).textTheme.bodyLarge!.copyWith(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.questionIndex}. ",
              style:
                  // !widget.isDesktop
                  //     ? Theme.of(context).textTheme.bodyMedium!.copyWith():
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                widget.question,
                style:
                    // !widget.isDesktop
                    //     ? Theme.of(context).textTheme.bodyLarge!.copyWith():
                    Theme.of(context)
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
                  fillColor: MaterialStateProperty.all(Colors.black)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.optionList.length,
                  (index) => RadioListTile<SelectedOption>(
                    value: SelectedOption.values[index],
                    groupValue: _selectedOption,
                    onChanged: (SelectedOption? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                    title: optionBuilder(widget.optionList[index].choice),
                  ),
                )))
      ],
    );
  }
}
