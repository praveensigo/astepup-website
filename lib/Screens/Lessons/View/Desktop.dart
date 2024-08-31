import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/NoResourseWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Screens/Course%20Details/Widgets/VideoErrorScreen.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/LessonLoader.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/TabbarBuilder.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../Widgets/PdfWidget.dart';
import '../Widgets/Widgets.dart';

class DesktopView extends StatefulWidget {
  const DesktopView({super.key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<String> tabTitles = ["Resources", "Feedback"];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<LessonController>(
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          body: controller.currentState == LoadingState.lessonLoading
              ? const LessonVideoLoader()
              : controller.currentState == LoadingState.error
                  ? const VideoErrorScreen()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.width * .02,
                                left: size.width * .02,
                                right: size.width * .03),
                            child: const VimeoVideoPlayer(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * .04, vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  controller.videoData!.videoName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Presenter : ${controller.videoData!.presenter}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 10),
                                TabbarBuilder(
                                  tabbarTitleList: tabTitles,
                                  tabController: tabController,
                                  tabbarChildren: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30, horizontal: 25),
                                      child:
                                          controller.videoData!.resources
                                                      .isEmpty() &&
                                                  controller.videoData!
                                                      .videoDescription.isEmpty
                                              ? const NoResourseWidget()
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: List.generate(
                                                          controller
                                                              .videoData!
                                                              .resources
                                                              .pdf
                                                              .length,
                                                          (index) =>
                                                              PdfItemWidget(
                                                                pdf: controller
                                                                    .videoData!
                                                                    .resources
                                                                    .pdf[index],
                                                                width: 140,
                                                              )),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      controller.videoData!
                                                          .videoDescription,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    ...List.generate(
                                                        controller
                                                            .videoData!
                                                            .resources
                                                            .links
                                                            .length,
                                                        (index) => RichText(
                                                                text: TextSpan(
                                                                    text:
                                                                        "${controller.videoData!.resources.links[index].resourceName}: ",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                    children: [
                                                                  TextSpan(
                                                                      text:
                                                                          " ${getDomainFromUrl(controller.videoData!.resources.links[index].link)}",
                                                                      recognizer:
                                                                          TapGestureRecognizer()
                                                                            ..onTap =
                                                                                () async {
                                                                              await launchUrl(Uri.parse(controller.videoData!.resources.links[index].link));
                                                                            },
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: colorPrimaryDark)),
                                                                ]))),
                                                  ],
                                                ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Form(
                                        key: controller.formKey,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  controller.feedBackController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Enter your feedback";
                                                }
                                                return null;
                                              },
                                              expands: false,
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 300),
                                                hintText: "Enter your feedback",
                                                enabledBorder:
                                                    controller.textfieldBorder,
                                                focusedBorder:
                                                    controller.textfieldBorder,
                                                border:
                                                    controller.textfieldBorder,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              width: size.width * .15,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    FormData data =
                                                        FormData.fromMap({
                                                      "feedback": controller
                                                          .feedBackController
                                                          .text
                                                          .trim(),
                                                      "video_id": controller
                                                          .videoData?.videoId,
                                                    });
                                                    if (controller
                                                        .formKey.currentState!
                                                        .validate()) {
                                                      await controller
                                                          .updateUserFeedback(
                                                              endPoint: ApiEndPoints
                                                                  .updateVideoFeedback,
                                                              data: data);
                                                    }
                                                  },
                                                  child: Text("SEND",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
