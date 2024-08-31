import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:html' as html;
import '../../Config/ApiConfig.dart';
import '../../Controller/HomeController.dart';
import '../../Controller/LoginController.dart';
import '../../Resource/AssetsManger.dart';
import '../../Resource/CustomIcons.dart';
import '../../Resource/colors.dart';
import '../Home/Widgets/Search.dart';
import '../../Utils/Utils.dart';

enum Options {
  profile,
  contactUs,
  aboutUs,
  terms,
  privacy,
  faq,
  contributors,
  logout
}

// double kappBarHeight = 120;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController? textController;
  final Widget? leading;
  final double? leadingWidth;
  final Color? backgroundColor;
  final double height;

  const CustomAppBar({
    super.key,
    this.textController,
    this.leading,
    this.leadingWidth,
    this.backgroundColor,
    this.height = 120,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Map<String, dynamic> userData = {};
  int menuItemIndex = 0;
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    userData = getSavedObject('userData') ?? {};
    setState(() {});
  }

  updateData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenKey(
          key: 'userData',
          callback: (value) {
            if (mounted) {
              setState(() {
                if (value != null) {
                  userData = json.decode(value);
                }
              });
            }
          });
    });
  }

  PopupMenuItem buildPopupMenuItem(
      BuildContext context, String title, String iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          SvgPicture.asset(iconData),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  PopupMenuItem buildProfileItem(BuildContext context, int position) {
    Map<String, dynamic> data = getSavedObject('userData') ?? {};
    String userImage = '';
    if (data.containsKey("image")) {
      userImage = data['image'] ?? "";
    }
    if (data.containsKey("profile_img")) {
      userImage = data['profile_img'] ?? "";
    }
    return PopupMenuItem(
      value: position,
      enabled: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: ApiConfigs.imageUrl + userImage,
                httpHeaders: const {
                  'Access-Control-Allow-Origin': '*',
                  'Access-Control-Allow-Method': 'GET',
                },
                errorWidget: (context, url, error) => Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[300]),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[800]!,
                    )),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 20,
                  backgroundImage: imageProvider,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                (getSavedObject('userData') as Map).containsKey('name')
                    ? getSavedObject('userData')['name']
                    : "User name",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            (getSavedObject('userData') as Map).containsKey('organization_name')
                ? getSavedObject('userData')['organization_name']
                : "Organization",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: textColor),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                context.go('/profile');
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: borderColor.withOpacity(.8), width: 1.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: colorPrimary,
                  minimumSize: const Size(double.infinity, 45)),
              child: Text(
                "Profile",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  onMenuItemSelected(int value, BuildContext context) {
    switch (value) {
      case 1:
        context.go('/contactus');
        break;
      case 2:
        context.go('/aboutus');
        break;
      case 3:
        context.go('/terms');
        break;
      case 4:
        context.go('/privacy');
        break;
      case 5:
        context.go('/faq');
        break;
      case 6:
        context.go('/contributors');
        break;
      case 7:
        logoutDialog();
        break;
    }
  }

  final InputBorder border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1.3),
      borderRadius: BorderRadius.circular(5));

  @override
  Widget build(BuildContext context) {
    updateData();
    Map<String, dynamic> data = getSavedObject('userData') ?? {};
    String userImage = '';
    String userName = "User name";

    if (data.containsKey("image")) {
      userImage = data['image'] ?? "";
    }
    if (data.containsKey("profile_img")) {
      userImage = data['profile_img'] ?? "";
    }
    if (data.containsKey("name")) {
      userName = data['name'] ?? "";
    }
    var size = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (controller) {
        return ResponsiveBuilder(builder: (context, sizedInfo) {
          return AppBar(
            centerTitle: false,
            toolbarHeight: Size.fromHeight(widget.height).height,
            automaticallyImplyLeading: false,
            backgroundColor: widget.backgroundColor ?? colorPrimary,
            leadingWidth:
                widget.leadingWidth ?? (sizedInfo.isMobile ? 100 : 200),
            leading: widget.leading ??
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      final router = GoRouter.of(context);
                      final matches =
                          router.routeInformationParser.configuration;
                      html.window.history.replaceState(null, "home", "/");
                      // html.window.history
                      //     .pushState('/detail/1', "", html.window.location.href);
                      // html.window.onPopState.listen((event) {
                      //   html.window.history.pushState(
                      //       '/detail/1', "", html.window.location.href);
                      // });
                      GoRouter.of(context).go('/');
                    },
                    child: Image.asset(
                      AssetManager.applogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            title: ((getSavedObject('token') ?? "").isNotEmpty)
                ? const HomeSearch()
                : const SizedBox(),
            actions: [
              if ((getSavedObject('token') ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PopupMenuButton(
                    tooltip: '',
                    offset: Offset(0, widget.height - 20),
                    onSelected: (value) {
                      onMenuItemSelected(value as int, context);
                    },
                    itemBuilder: (ctx) => [
                      buildProfileItem(context, Options.profile.index),
                      buildPopupMenuItem(context, 'Contact us',
                          CustomIcons.contactus, Options.contactUs.index),
                      buildPopupMenuItem(context, 'About us',
                          CustomIcons.aboutus, Options.aboutUs.index),
                      buildPopupMenuItem(context, 'Terms & conditions',
                          CustomIcons.terms, Options.terms.index),
                      buildPopupMenuItem(context, 'Privacy policy',
                          CustomIcons.privacy, Options.privacy.index),
                      buildPopupMenuItem(
                          context, 'FAQ', CustomIcons.faq, Options.faq.index),
                      buildPopupMenuItem(context, 'Contributors',
                          CustomIcons.contributors, Options.contributors.index),
                      buildPopupMenuItem(context, 'Logout', CustomIcons.logout,
                          Options.logout.index),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: size.width < 560
                          ? Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: ApiConfigs.imageUrl + userImage,
                                  httpHeaders: const {
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Method': 'GET',
                                  },
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[200]),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey[800]!,
                                          )),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 20,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Text(
                                  userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.expand_more_rounded)
                              ],
                            ),
                    ),
                  ),
                )
            ],
          );
        });
      },
    );
  }

  void logoutDialog() {
    showDialog(
        context: context,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          return AlertDialog(
            title: Image.asset(
              "Assets/Images/SignOut.png",
              height: 100,
            ),
            content: Text(
              "Are you sure you want to logout?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              Container(
                width: size.width * .27,
                constraints: const BoxConstraints(maxWidth: 140),
                height: 40,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "NO",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(width: 10),
              Container(
                width: size.width * .27,
                constraints: const BoxConstraints(maxWidth: 140),
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      loginController.logout(context);
                    },
                    child: Text(
                      "YES",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
              )
            ],
          );
        });
  }
}
