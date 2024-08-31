import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/SettingsController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:astepup_website/Screens/Widgets/appbar.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../Utils/Utils.dart';

class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({super.key});
  final privacyStorageData =
      getSavedObject(StorageKeys.maintenanceData) as Map<String, dynamic>? ??
          {};
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
          appBar: CustomAppBar(
            height: sizeInfo.isMobile ? 80 : 120,
          ),
          body: GetBuilder<SettingsController>(
            init: SettingsController(),
            initState: (_) {},
            didChangeDependencies: (state) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                state.controller?.getPrivacyPolicy();
              });
            },
            builder: (controller) {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.privacyPolicy,
                              style: textTheme.headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            HtmlWidget(
                              controller.privacyData?.content ??
                                  privacyStorageData?['data']?['privacy']
                                      ?['content'] ??
                                  "<p>There seems to be a temporary issue with our ${Strings.privacyPolicy}. Please try reloading the page or visit us later.</p>",
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ));
    });
  }
}
