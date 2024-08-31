import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  const BackgroundWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      double contianerHeight = sizingInformation.screenSize.height / 4;
      double horizontalPadding = sizingInformation.screenSize.width * .4;
      double verticalPadding = contianerHeight * .01;
      if (sizingInformation.isDesktop) {
        contianerHeight = sizingInformation.screenSize.height / 2.4;
        horizontalPadding = sizingInformation.screenSize.width * .25;
        print(contianerHeight * .13);
        verticalPadding = contianerHeight * .13;
      }
      if (sizingInformation.isTablet) {
        contianerHeight = sizingInformation.screenSize.height / 2.2;
        verticalPadding = contianerHeight * .08;
        horizontalPadding = sizingInformation.screenSize.width * .08;
      }
      if (sizingInformation.isMobile) {
        contianerHeight = sizingInformation.screenSize.height / 3;
        verticalPadding = contianerHeight * .05;
        horizontalPadding = sizingInformation.screenSize.width * .06;
      }

      return Container(
        height: contianerHeight,
        width: double.infinity,
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 310, maxHeight: 340),
        color: colorPrimary.withOpacity(.5),
        child: Container(
          constraints: const BoxConstraints(
              minHeight: 300, minWidth: 450, maxHeight: 370),
          margin: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          padding: EdgeInsets.symmetric(
              horizontal:
                  sizingInformation.isDesktop || sizingInformation.isTablet
                      ? 20
                      : 10,
              vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: child,
        ),
        // ),
      );
    });
  }
}
