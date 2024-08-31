import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({
    super.key,
    this.width,
    this.height,
    this.onPressed,
    required this.sizingInformation,
    required this.buttonTextStyle,
  });
  final double? width;
  final double? height;
  final Function()? onPressed;
  final SizingInformation sizingInformation;
  final TextStyle? buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??
          (sizingInformation.screenSize.width < 470
              ? double.infinity
              : sizingInformation.screenSize.width * .35),
      height: height ?? 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          onPressed: onPressed,
          child: Text(
            'Edit Profile',
            style: buttonTextStyle,
          )),
    );
  }
}
