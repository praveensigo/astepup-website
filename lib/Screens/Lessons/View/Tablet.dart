import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/Resource/Strings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Course%20Details/Widgets/VideoErrorScreen.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/LessonLoader.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/NoResourseWidget.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/PdfWidget.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/Sidebar/flutter_sidebar.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/TabbarBuilder.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/VideoPlayer.dart';

import '../../../Utils/Utils.dart';

class TabletView extends StatefulWidget {
  const TabletView({super.key});

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Get.find<SideMenuManager>().retriveStageDetail(
          getSavedObject(StorageKeys.stageDetails)['stages'] ?? []);
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<String> tabTitles = ["Lessons", "Resources", "Feedback"];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<LessonController>(
      initState: (_) {},
      builder: (controller) {
        return controller.currentState == LoadingState.lessonLoading
            ? const LessonVideoLoader()
            : Scaffold(
                body: controller.currentState == LoadingState.error
                    ? const VideoErrorScreen()
                    : SingleChildScrollView(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const VimeoVideoPlayer(),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.videoData!.videoName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Presenter :  ${controller.videoData!.presenter}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 10),
                                TabbarBuilder(
                                  width: double.infinity,
                                  tabbarTitleList: tabTitles,
                                  tabController: tabController,
                                  tabbarChildren: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: LesssonSideBar(
                                        onTabChanged: (value) {
                                          var sidemenuController =
                                              Get.find<SideMenuManager>();
                                          if (sidemenuController
                                                  .sideBarController
                                                  .searchItemIndex(
                                                      sidemenuController
                                                          .sideBarController
                                                          .tabs[0],
                                                      value) !=
                                              null) {
                                            setState(() {
                                              sidemenuController
                                                  .sideBarController
                                                  .selectItem(value);
                                            });
                                          }
                                        },
                                        width: double.infinity,
                                        controller: Get.find<SideMenuManager>()
                                            .sideBarController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 25),
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
                                                    SizedBox(
                                                      height: 180,
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
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
                                                                )),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      controller.videoData!
                                                          .videoDescription,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    ...List.generate(
                                                        controller
                                                            .videoData!
                                                            .resources
                                                            .links
                                                            .length,
                                                        (index) => RichText(
                                                                text: TextSpan(
                                                                    text:
                                                                        "${controller.videoData!.resources.links[index].resourceName} : ",
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
                                              expands: false,
                                              maxLines: 5,
                                              controller:
                                                  controller.feedBackController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Enter your feedback";
                                                }
                                                return null;
                                              },
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
                                              width: size.width * .3,
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
                      )),
              );
      },
    );
  }
}
