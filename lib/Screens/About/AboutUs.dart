import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/SettingsController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Widgets/appbar.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});
  final aboutUsStorageData =
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
                state.controller!.getAbout();
              },
              builder: (controller) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(Strings.aboutus,
                                  style: textTheme.headlineMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 50,
                              ),
                              HtmlWidget(controller.aboutus?.content ??
                                  aboutUsStorageData?['data']?['about_us']
                                      ?['content'] ??
                                  "<p>There seems to be a temporary issue with our About Us page. Please try reloading the page or visit us later.</p>")
                            ])),
                );
              }));
    });
  }
}
