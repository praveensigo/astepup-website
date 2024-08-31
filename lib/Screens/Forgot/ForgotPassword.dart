import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/ForgotPasswordController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Utils/Helper.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../Screens.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));
  final forgotController = Get.put(ForgotController());
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<ForgotController>(
      initState: (_) {},
      builder: (controller) {
        return Scaffold(body: ResponsiveBuilder(builder: (context, sizeInfo) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sizeInfo.isDesktop ? 40 : 20, vertical: 15),
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
                                "Forgot Password?",
                                style: textTheme.headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              UserInputField(
                                title: "Enter the email registered with us",
                                titleStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter a email";
                                  }
                                  if (!value.isValidEmail()) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  if (formKey.currentState!.validate()) {
                                    controller.sentForgotOtp(
                                        context, emailController.text);
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: textColor.withOpacity(.5)),
                                    hintText: "Enter email",
                                    border: textFieldBorder,
                                    enabledBorder: textFieldBorder,
                                    focusedBorder: textFieldBorder),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.sentForgotOtp(context,
                                      emailController.text); // context.go('/',
                                  //     extra: {'email': });
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
        }));
      },
    );
  }
}
