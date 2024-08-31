import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/EvaluationController.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Mastery/widget/Evaluationquestion.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';

import '../../Resource/Strings.dart';

class EvaluationSurvey extends StatelessWidget {
  EvaluationSurvey({super.key});
  int page = 0;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: GetBuilder<EvaluationSurveyController>(
            init: EvaluationSurveyController(),
            didChangeDependencies: (state) async {
              await state.controller!.evaluationSurvey();
              if (state.controller!.choices.isEmpty) {
                if (context.mounted) {
                  context.go('/certificate');
                }
              }
            },
            initState: (_) {},
            builder: (controller) {
              return controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: colorPrimary,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(55, 50, 50, 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Evaluation Survey",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (_, __) => const SizedBox(
                                        height: 10,
                                      ),
                                  shrinkWrap: true,
                                  itemCount: controller.choices.length,
                                  itemBuilder: (_, i) {
                                    return EvaluationQuestionWidget(
                                      isDesktop: true,
                                      questionData: controller.choices[i],
                                      questionIndex: i + 1,
                                    );
                                  }),
                              const SizedBox(height: 15),
                              Center(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(400, 50),
                                      maximumSize: const Size(400, 50),
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        var response = await controller
                                            .addEvaluation(context);
                                        if (response == true) {
                                          if (context.mounted) {
                                            GoRouter.of(context)
                                                .go('/certificate');
                                          }
                                        } else {
                                          showToast(Strings.evaluationApi);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'SUBMIT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
            }));
  }
}
