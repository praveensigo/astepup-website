import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/ProfileController.dart';
import 'package:astepup_website/Screens/Home/Widgets/CourseListing.dart';
import 'package:astepup_website/Screens/Profile/Widgets/ChangePasswordButton.dart';
import 'package:astepup_website/Screens/Profile/Widgets/CourseEmpty.dart';
import 'package:astepup_website/Screens/Profile/Widgets/Dialogs.dart';
import 'package:astepup_website/Screens/Profile/Widgets/EditProfileButton.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../Widgets/Widgets.dart';

class TabletView extends StatefulWidget {
  const TabletView({
    super.key,
    required this.sizingInformation,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.buttonTextStyle,
  });
  final SizingInformation sizingInformation;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? buttonTextStyle;

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  late ProfileDialogs profileDialogs;
  @override
  void initState() {
    profileDialogs = ProfileDialogs(buildContext: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      initState: (_) {},
      builder: (controller) {
        return controller.isLoading || controller.profileData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    BackgroundWidget(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  httpHeaders: const {
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Method': 'GET',
                                  },
                                  imageUrl: ApiConfigs.imageUrl +
                                      controller.profileData!.image,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          backgroundColor: Colors.grey[200],
                                          radius: 45,
                                          child: Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Colors.grey[800]!,
                                          )),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    radius: 45,
                                    child: const CircularProgressIndicator(),
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    radius: 45,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Row(
                                // alignment: WrapAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        controller.profileData!.userName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "${controller.profileData!.countryCode} ${controller.profileData!.mobile}",
                                            style: widget.subtitleStyle,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            controller.profileData!.email,
                                            style: widget.subtitleStyle,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  widget.sizingInformation.screenSize.width <
                                          605
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            ChangePasswordButton(
                                                width: 140,
                                                sizingInformation: widget
                                                    .sizingInformation,
                                                onTap: () => profileDialogs
                                                    .changePasswordDialog(),
                                                buttonTextStyle:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                            const SizedBox(height: 10),
                                            EditProfileButton(
                                                width: 140,
                                                sizingInformation:
                                                    widget.sizingInformation,
                                                onPressed: () =>
                                                    profileDialogs.editProfile(
                                                        profileData: controller
                                                            .profileData!),
                                                buttonTextStyle:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextTitleBuilder(
                            title: "Organization",
                            titleStyle: Theme.of(context).textTheme.bodyLarge,
                            subtitle: controller.profileData!.organization,
                            subtitleStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (widget.sizingInformation.screenSize.width < 605)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChangePasswordButton(
                                  width: 140,
                                  sizingInformation: widget.sizingInformation,
                                  onTap: () =>
                                      profileDialogs.changePasswordDialog(),
                                  buttonTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              EditProfileButton(
                                  width: 140,
                                  sizingInformation: widget.sizingInformation,
                                  onPressed: () => profileDialogs.editProfile(
                                      profileData: controller.profileData!),
                                  buttonTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold))
                            ],
                          )
                      ],
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      child: controller.profileData!.completedCourse.isEmpty &&
                              controller.profileData!.inprogressCourse.isEmpty
                          ? const CourseEmptyState()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CourseListingWidget(
                                  title: 'In Progress Courses',
                                  length: controller
                                      .profileData!.inprogressCourse.length,
                                  course:
                                      controller.profileData!.inprogressCourse,
                                ),
                                const SizedBox(height: 25),
                                CourseListingWidget(
                                  title: 'Completed Courses',
                                  length: controller
                                      .profileData!.completedCourse.length,
                                  isCourseComplete: true,
                                  course:
                                      controller.profileData!.completedCourse,
                                ),
                                const SizedBox(height: 25),
                                // OutlinedButton(
                                //     style: OutlinedButton.styleFrom(
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 15, vertical: 20),
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(5))),
                                //     onPressed: () {},
                                //     child: Text(
                                //       "View More",
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .bodyMedium!
                                //           .copyWith(
                                //               fontWeight: FontWeight.bold),
                                //     ))
                              ],
                            ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
