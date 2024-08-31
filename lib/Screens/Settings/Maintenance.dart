import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/MaintenanceController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageSize =
        screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.7;
    return GetBuilder<MaintenanceController>(
      init: MaintenanceController(),
      initState: (_) {},
      builder: (controller) {
        return ResponsiveBuilder(builder: (context, sizeInfo) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              toolbarHeight: Size.fromHeight(
                sizeInfo.isMobile ? 80 : 120,
              ).height,
              automaticallyImplyLeading: false,
              backgroundColor: colorPrimary,
              leadingWidth: (sizeInfo.isMobile ? 100 : 200),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  AssetManager.applogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      AssetManager.maintenance,
                      width: imageSize,
                      height: imageSize,
                    ),
                    Text(
                      Strings.maintenancemode,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        controller.maintanceSettings?.maintenanceReasonWeb ??
                            Strings.maintenancemessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
