import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/ProfileController.dart';
import 'package:astepup_website/Screens/Home/Widgets/CourseListing.dart';
import 'package:astepup_website/Screens/Profile/Widgets/ChangePasswordButton.dart';
import 'package:astepup_website/Screens/Profile/Widgets/CourseEmpty.dart';
import 'package:astepup_website/Screens/Profile/Widgets/Dialogs.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../Widgets/Widgets.dart';

class MobileView extends StatefulWidget {
  const MobileView({
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
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                        radius: 34,
                                        child: Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.grey[800]!,
                                        )),
                                progressIndicatorBuilder:
                                    (context, url, progress) => CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 34,
                                  child: const CircularProgressIndicator(),
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 34,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    controller.profileData!.userName,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "${controller.profileData!.countryCode} ${controller.profileData!.mobile}",
                                        overflow: TextOverflow.ellipsis,
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
                                      Text(
                                        controller.profileData!.email,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: widget.subtitleStyle,
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Organization",
                                style: widget.titleStyle,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                controller.profileData!.organization,
                                style: widget.subtitleStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 40,
                                child: ElevatedButton(
                                    onPressed: () => profileDialogs.editProfile(
                                        profileData: controller.profileData!),
                                    child: Text(
                                      'Edit Profile',
                                      style: widget.buttonTextStyle,
                                    )),
                              ),
                              const SizedBox(width: 5),
                              ChangePasswordButton(
                                  width: 140,
                                  height: 40,
                                  sizingInformation: widget.sizingInformation,
                                  onTap: () =>
                                      profileDialogs.changePasswordDialog(),
                                  buttonTextStyle: widget.buttonTextStyle)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      child: controller.profileData!.completedCourse.isEmpty &&
                              controller.profileData!.inprogressCourse.isEmpty
                          ? const CourseEmptyState()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CourseListingWidget(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    title: 'In Progress Courses',
                                    scrollDirection: Axis.vertical,
                                    length: controller
                                        .profileData!.inprogressCourse.length,
                                    course: controller
                                        .profileData!.inprogressCourse),
                                const SizedBox(height: 25),
                                CourseListingWidget(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    title: 'Completed Courses',
                                    length: controller
                                        .profileData!.completedCourse.length,
                                    isCourseComplete: true,
                                    scrollDirection: Axis.vertical,
                                    course: controller
                                        .profileData!.completedCourse),
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
