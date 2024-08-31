import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/SettingsController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder(
        init: SettingsController(),
        didChangeDependencies: (state) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            state.controller!.getTermsandCondition();
          });
        },
        builder: (controller) {
          return ResponsiveBuilder(builder: (context, sizeInfo) {
            return Scaffold(
              appBar: CustomAppBar(
                height: sizeInfo.isMobile ? 80 : 120,
              ),
              body: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.termsAndCondition,
                              style: textTheme.headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            HtmlWidget(
                              controller.terms?.content ??
                                  "<p>There seems to be a temporary issue with our ${Strings.termsAndCondition} page. Please try reloading the page or visit us later.</p>",
                              textStyle: const TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
            );
          });
        });
  }
}
