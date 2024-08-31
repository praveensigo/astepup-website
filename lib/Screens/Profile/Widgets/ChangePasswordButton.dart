import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({
    super.key,
    required this.onTap,
    this.height,
    this.width,
    required this.buttonTextStyle,
    required this.sizingInformation,
  });

  final Function()? onTap;
  final double? height;
  final double? width;
  final TextStyle? buttonTextStyle;
  final SizingInformation sizingInformation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??
          (sizingInformation.screenSize.width < 470
              ? double.infinity
              : sizingInformation.screenSize.width * .35),
      height: height ?? 50,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          onPressed: onTap,
          child: Text(
            "Change Password",
            style: buttonTextStyle,
          )),
    );
  }
}
