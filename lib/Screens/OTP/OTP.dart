import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:astepup_website/Controller/ForgotPasswordController.dart';

import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/coloredContainer.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../Screens.dart';

class OTP extends StatefulWidget {
  const OTP({
    super.key,
  });

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool resendOtp = true;
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 60);
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));
  final formKey = GlobalKey<FormState>();
  String otp = '';
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    if (mounted) {
      countdownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    }
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    // stopTimer();
    setState(() => myDuration = const Duration(seconds: 60));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      int seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        resendOtp = false;
        resetTimer();
      } else {
        if (resendOtp == false) {
          seconds = 60;
        }
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(0, '0');
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    Get.put(ForgotController());
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return GetBuilder<ForgotController>(
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          body: ResponsiveBuilder(builder: (context, sizeInfo) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sizeInfo.isDesktop ? 40 : 15, vertical: 15),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            AssetManager.applogo,
                            width: 200,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ColoredContainer(
                        constraints: const BoxConstraints(
                            minWidth: 200, maxWidth: 630, maxHeight: 470),
                        padding: EdgeInsets.symmetric(
                            horizontal: sizeInfo.isDesktop ? 100 : 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "OTP",
                                  style: textTheme.headlineMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Enter the code sent to ${controller.userEmail}",
                                  style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                                const SizedBox(height: 30),
                                PinCodeTextField(
                                  autoFocus: true,
                                  useHapticFeedback: true,
                                  appContext: context,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter your otp";
                                    }
                                    return null;
                                  },
                                  pastedTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins-Regular"),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  length: 6,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: size.width * .01),
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  blinkWhenObscuring: true,
                                  animationType: AnimationType.fade,
                                  textInputAction: TextInputAction.done,
                                  pinTheme: PinTheme(
                                    fieldOuterPadding: EdgeInsets.zero,
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    fieldWidth: 50,
                                    inactiveColor: Colors.grey,
                                  ),
                                  cursorColor: Colors.white,
                                  textStyle:
                                      const TextStyle(color: Colors.black),
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  enableActiveFill: false,
                                  keyboardType: TextInputType.number,
                                  boxShadows: const [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.transparent,
                                      blurRadius: 10,
                                    )
                                  ],
                                  onSubmitted: (value) {
                                    if (formKey.currentState!.validate()) {
                                      controller.verifyOtp(
                                          context: context, otp: otp);
                                    }
                                  },
                                  onCompleted: (pin) {
                                    otp = pin;
                                  },
                                  onChanged: (value) {
                                    otp = value;
                                  },
                                  beforeTextPaste: (text) {
                                    return true;
                                  },
                                ),
                                resendOtp
                                    ? Text(
                                        "Resend code in $seconds seconds",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          resendOtp = true;
                                          startTimer();
                                          await controller.sentForgotOtp(
                                              context, controller.userEmail,
                                              enableRedirect: false);

                                          setState(() {});
                                        },
                                        child: Text('Resend OTP',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    controller.verifyOtp(
                                        context: context, otp: otp);
                                  }
                                },
                                child: Text(
                                  "SUBMIT",
                                  style: textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ))
                          ],
                        ))
                  ]),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
