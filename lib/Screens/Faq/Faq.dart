import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Controller/SettingsController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Course%20Details/Widgets/CustomExpansionTile.dart';
import 'package:astepup_website/Screens/Widgets/appbar.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
          appBar: CustomAppBar(
            height: sizeInfo.isMobile ? 80 : 120,
          ),
          body: GetBuilder<SettingsController>(
              init: SettingsController(),
              initState: (_) {},
              didChangeDependencies: (state) {
                state.controller?.getFaq();
              },
              builder: (controller) {
                return ResponsiveBuilder(builder: (context, sizingInformation) {
                  return controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: colorPrimary,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(Strings.faq,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    controller.faqList.isEmpty
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 40,
                                                      horizontal: 25),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      AssetManager.noFaq),
                                                  Text(
                                                    "We apologize, but our FAQ section is currently empty. We are \nworking on updating it with useful information shortly. Please check back soon!",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.faqList.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 15),
                                            itemBuilder: (_, i) {
                                              var faq = controller.faqList[i];
                                              return FaqItem(
                                                question: faq.question,
                                                answer: faq.answer,
                                              );
                                            })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                });
              }));
    });
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      isExpanded: isExpanded,
      onExpansionChanged: (expand) {
        setState(() => isExpanded = expand);
      },
      cardShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        widget.question,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: [
        Text(
          widget.answer,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
