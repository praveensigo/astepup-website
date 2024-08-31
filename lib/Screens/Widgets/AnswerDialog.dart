import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:astepup_website/Resource/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AnswerDialogWidget extends StatelessWidget {
  final String message;
  final bool isCorrectAnswer;
  final Function()? onPressed;
  const AnswerDialogWidget({
    super.key,
    required this.isCorrectAnswer,
    this.onPressed,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double iconSize = MediaQuery.of(context).size.width * .045 > 70
        ? MediaQuery.of(context).size.width * .045
        : 65;
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 260),
          width: size.width * .3,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isCorrectAnswer
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: green,
                          size: iconSize,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "GREAT",
                          style: sizeInfo.isDesktop
                              ? Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)
                              : Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Correct Answer",
                          style: sizeInfo.isDesktop
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold)
                              : Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: red,
                                size: iconSize,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "OOPS",
                                style: sizeInfo.isDesktop
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Incorrect Answer",
                                style: sizeInfo.isDesktop
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Correct answer",
                              textAlign: TextAlign.center,
                              style: sizeInfo.isDesktop
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                message,
                                textAlign: TextAlign.start,
                                style: sizeInfo.isDesktop
                                    ? Theme.of(context).textTheme.bodyLarge
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Text(
                        //   "Laborum magna nulla duis ullamco cillum dolor. Voluptateyhayi exercitation repr incididunt aliquip deserunt reprehenderit elit.  ",
                        //   textAlign: TextAlign.justify,
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .bodyMedium!
                        //       .copyWith(fontWeight: FontWeight.bold),
                        // )
                      ],
                    ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                    onPressed: onPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Text(
                      "NEXT",
                      style: sizeInfo.isDesktop
                          ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold)
                          : Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      );
    });
  }
}
