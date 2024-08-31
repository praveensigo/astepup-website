import 'package:flutter/material.dart';
import 'package:astepup_website/Screens/Widgets/LessonSections.dart';
import 'package:go_router/go_router.dart';

class LessonSectonBuilder extends StatefulWidget {
  final String questionCount;
  final String imageUrl;
  final String title;
  final TextStyle? titleStyle;
  final String subTitle;
  final TextStyle? subTitleStyle;
  final String descripton;
  final TextStyle? descriptonStyle;
  final String questionText;
  final TextStyle? questionTextStyle;
  final void Function()? onPressed;
  final String buttonText;
  final TextStyle? buttonTextStyle;
  final Widget? bottomWidget;

  const LessonSectonBuilder(
      {super.key,
      required this.imageUrl,
      required this.title,
      this.titleStyle,
      required this.subTitle,
      this.subTitleStyle,
      required this.descripton,
      this.descriptonStyle,
      required this.questionText,
      this.questionTextStyle,
      this.onPressed,
      required this.buttonText,
      this.buttonTextStyle,
      this.bottomWidget,
      required this.questionCount});

  @override
  State<LessonSectonBuilder> createState() => _LessonSectonBuilderState();
}

class _LessonSectonBuilderState extends State<LessonSectonBuilder> {
  @override
  Widget build(BuildContext context) {
    return LessonSectionLayout(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(widget.imageUrl),
                  const SizedBox(height: 25),
                  Text(
                    widget.title,
                    style: widget.titleStyle ??
                        Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.subTitle,
                    style: widget.subTitleStyle ??
                        Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: Center(
                      child: Text(
                        widget.descripton,
                        style: widget.descriptonStyle ??
                            Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.questionText,
                    style: widget.questionTextStyle ??
                        Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  widget.bottomWidget ??
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: 200, maxWidth: 400),
                          child: widget.questionCount == "0"
                              ? Container()
                              : ElevatedButton(
                                  onPressed: widget.onPressed ??
                                      () {
                                        GoRouter.of(context)
                                            .push('/lesson/section-review');
                                      },
                                  child: Text(
                                    widget.buttonText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
