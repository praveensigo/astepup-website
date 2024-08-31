import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Home/Widgets/CourseListing.dart';
import 'package:astepup_website/Screens/Profile/Widgets/ChangePasswordButton.dart';
import 'package:astepup_website/Screens/Profile/Widgets/CourseEmpty.dart';
import 'package:astepup_website/Screens/Profile/Widgets/EditProfileButton.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Profile/Widgets/Dialogs.dart';

import '../../Controller/ProfileController.dart';
import '../Widgets/appbar.dart';
import 'View/View.dart';
import 'Widgets/Widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));

  String selectedCountryCode = '+1';

  BoxConstraints constraints = const BoxConstraints(maxHeight: 55);

  late ProfileDialogs profileDialogs;
  @override
  void initState() {
    profileDialogs = ProfileDialogs(buildContext: context);
    super.initState();
  }

  bool isOrganizationEmpty = false;
  bool isMobile = false;
  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: Colors.grey, fontWeight: FontWeight.bold);
    TextStyle? subtitleStyle = Theme.of(context).textTheme.bodyMedium;
    TextStyle? organistaionStyle = Theme.of(context).textTheme.bodyLarge;
    TextStyle? buttonTextStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.bold, color: Colors.black);
    return ResponsiveBuilder(
        breakpoints:
            const ScreenBreakpoints(desktop: 801, tablet: 451, watch: 100),
        builder: (context, sizingInformation) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                height: sizingInformation.isMobile ? 80 : 120,
              ),
              body: GetBuilder<ProfileController>(
                init: ProfileController(),
                initState: (_) {},
                builder: (controller) {
                  return controller.isLoading || controller.profileData == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: ResponsiveBuilder(
                              breakpoints: const ScreenBreakpoints(
                                  desktop: 801, tablet: 451, watch: 100),
                              builder: (context, sizingInformation) {
                                if (sizingInformation.isMobile) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    isMobile = true;
                                    setState(() {});
                                  });
                                  TextStyle? titleStyle = Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700);
                                  TextStyle? subtitleStyle =
                                      Theme.of(context).textTheme.bodyMedium;
                                  TextStyle? buttonTextStyle = Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black);
                                  return MobileView(
                                      sizingInformation: sizingInformation,
                                      titleStyle: titleStyle,
                                      subtitleStyle: subtitleStyle,
                                      buttonTextStyle: buttonTextStyle);
                                }
                                if (sizingInformation.isTablet) {
                                  print('talble');
                                  TextStyle? titleStyle = Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700);
                                  TextStyle? subtitleStyle =
                                      Theme.of(context).textTheme.bodyMedium;
                                  TextStyle? buttonTextStyle = Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black);
                                  return TabletView(
                                      sizingInformation: sizingInformation,
                                      titleStyle: titleStyle,
                                      subtitleStyle: subtitleStyle,
                                      buttonTextStyle: buttonTextStyle);
                                }
                                print('pc screen');
                                return Column(
                                  children: [
                                    BackgroundWidget(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  httpHeaders: const {
                                                    'Access-Control-Allow-Origin':
                                                        '*',
                                                    'Access-Control-Allow-Method':
                                                        'GET',
                                                  },
                                                  imageUrl:
                                                      ApiConfigs.imageUrl +
                                                          controller
                                                              .profileData!
                                                              .image,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey[200],
                                                          radius: 45,
                                                          child: Icon(
                                                            Icons.person,
                                                            size: 30,
                                                            color: Colors
                                                                .grey[800]!,
                                                          )),
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    radius: 45,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  ),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    radius: 45,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 25),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        controller.profileData!
                                                            .userName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.phone,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            "${controller.profileData!.countryCode} ${controller.profileData!.mobile}",
                                                            style:
                                                                subtitleStyle,
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.email,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            controller
                                                                .profileData!
                                                                .email,
                                                            style:
                                                                subtitleStyle,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      ChangePasswordButton(
                                                          width: 160,
                                                          sizingInformation:
                                                              sizingInformation,
                                                          onTap: () =>
                                                              profileDialogs
                                                                  .changePasswordDialog(),
                                                          buttonTextStyle:
                                                              buttonTextStyle),
                                                      const SizedBox(
                                                          height: 10),
                                                      EditProfileButton(
                                                          width: 160,
                                                          sizingInformation:
                                                              sizingInformation,
                                                          onPressed: () =>
                                                              profileDialogs.editProfile(
                                                                  profileData:
                                                                      controller
                                                                          .profileData!),
                                                          buttonTextStyle:
                                                              buttonTextStyle)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ResponsiveRowColumnItem(
                                              child: TextTitleBuilder(
                                            title: "Organization",
                                            titleStyle: organistaionStyle,
                                            subtitle: controller
                                                .profileData!.organization,
                                            subtitleStyle: organistaionStyle!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )),
                                        ),
                                      ],
                                    )),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 55, vertical: 30),
                                      color: Colors.white,
                                      child: controller.profileData!
                                                  .completedCourse.isEmpty &&
                                              controller.profileData!
                                                  .inprogressCourse.isEmpty
                                          ? const CourseEmptyState()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CourseListingWidget(
                                                  title: 'In Progress Courses',
                                                  length: controller
                                                      .profileData!
                                                      .inprogressCourse
                                                      .length,
                                                  course: controller
                                                      .profileData!
                                                      .inprogressCourse,
                                                ),
                                                const SizedBox(height: 25),
                                                CourseListingWidget(
                                                  title: 'Completed Courses',
                                                  length: controller
                                                      .profileData!
                                                      .completedCourse
                                                      .length,
                                                  isCourseComplete: true,
                                                  course: controller
                                                      .profileData!
                                                      .completedCourse,
                                                ),
                                                const SizedBox(height: 25),
                                                // controller
                                                //             .profileData!
                                                //             .completedCourse
                                                //             .isEmpty ||
                                                //         controller
                                                //                 .profileData!
                                                //                 .completedCourse
                                                //                 .length <
                                                //             5
                                                //     ? const SizedBox.shrink()
                                                //     : OutlinedButton(
                                                //         style: OutlinedButton.styleFrom(
                                                //             padding:
                                                //                 const EdgeInsets
                                                //                     .symmetric(
                                                //                     horizontal:
                                                //                         15,
                                                //                     vertical:
                                                //                         20),
                                                //             shape: RoundedRectangleBorder(
                                                //                 borderRadius:
                                                //                     BorderRadius
                                                //                         .circular(
                                                //                             5))),
                                                //         onPressed: () {},
                                                //         child: Text(
                                                //           "View More",
                                                //           style: Theme.of(
                                                //                   context)
                                                //               .textTheme
                                                //               .bodyMedium!
                                                //               .copyWith(
                                                //                   fontWeight:
                                                //                       FontWeight
                                                //                           .bold),
                                                //         ))
                                              ],
                                            ),
                                    )
                                  ],
                                );
                              }),
                        );
                },
              ));
        });
  }
}
