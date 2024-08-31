import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:astepup_website/Controller/SettingsController.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Screens/Screens.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
              state.controller?.getContactAPI();
            },
            builder: (controller) {
              return controller.isLoading.value ||
                      controller.contactData == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ResponsiveBuilder(builder: (context, sizeInfo) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: sizeInfo.isMobile
                                ? 15
                                : sizeInfo.isTablet
                                    ? 30
                                    : 50,
                            vertical: sizeInfo.isMobile
                                ? 30
                                : sizeInfo.isTablet
                                    ? 40
                                    : 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Contact US",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Call us at",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(
                                    'tel:${controller.contactData?.countryCode.countryCode ?? ''} ${controller.contactData?.mobile ?? ""}'));
                              },
                              child: Text(
                                "${controller.contactData?.countryCode.countryCode ?? ''} ${controller.contactData?.mobile ?? ''}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: const Color(0xff686868)),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Email us at",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                launchUrl(Uri.parse(
                                    'mailto:${controller.contactData?.email ?? ""}'));
                              },
                              child: Text(
                                  controller.contactData?.email ?? "Email",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: const Color(0xff686868))),
                            ),
                            const SizedBox(height: 30),
                            const Divider(
                              thickness: 2,
                              color: Color(0xffE1DDDD),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Company Office",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              SvgPicture.asset(CustomIcons.location),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  controller.contactData!.address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: const Color(0xff686868)),
                                ),
                              )
                            ]),
                          ],
                        ),
                      );
                    });
            },
          ));
    });
  }
}
