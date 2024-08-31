import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Controller/LoginController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/UserInputFeild.dart';
import 'package:astepup_website/Screens/Widgets/coloredContainer.dart';
import 'package:astepup_website/Utils/Helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));

  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: ResponsiveBuilder(builder: (context, sizeInfo) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sizeInfo.isDesktop ? 40 : 30, vertical: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            AssetManager.applogo,
                            width: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: formKey,
                        child: ColoredContainer(
                          constraints: const BoxConstraints(
                              minWidth: 200, maxWidth: 630, maxHeight: 470),
                          padding: EdgeInsets.symmetric(
                              horizontal: sizeInfo.isDesktop ? 100 : 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                style: textTheme.headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              UserInputField(
                                title: "Email",
                                autofillHints: const [AutofillHints.email],
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.continueAction,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).nextFocus();
                                },
                                controller: controller.emailController,
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your email";
                                  }
                                  if (!value.isValidEmail()) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: textColor.withOpacity(.5)),
                                    hintText: "Enter email",
                                    border: textFieldBorder,
                                    enabledBorder: textFieldBorder,
                                    focusedBorder: textFieldBorder),
                              ),
                              UserInputField(
                                title: "Password",
                                autofillHints: const [AutofillHints.password],
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                controller: controller.passwordController,
                                showForgotButton: true,
                                maxLines: 1,
                                obscureText: !showPassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your password";
                                  }
                                  if (value.length < 6 || value.length > 16) {
                                    return Strings.passwordLength;
                                  }
                                  if (!value.isValidPassword()) {
                                    return Strings.passwordError;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  if (formKey.currentState!.validate()) {
                                    controller.login(context);
                                  }
                                },
                                decoration: InputDecoration(
                                    errorMaxLines: 2,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Colors.red),
                                    prefixIcon: Icon(Icons.lock,
                                        color: textColor.withOpacity(.5)),
                                    hintText: "Enter password",
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        icon: Icon(
                                            showPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: textColor.withOpacity(.5))),
                                    border: textFieldBorder,
                                    enabledBorder: textFieldBorder,
                                    focusedBorder: textFieldBorder),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              controller.login(context);
                                            }
                                          },
                                          child: Text(
                                            "Login".toUpperCase(),
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                          ))),
                                  const SizedBox(height: 15),
                                  Wrap(
                                    runAlignment: WrapAlignment.center,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      Text(
                                        "Don’t have an account? ",
                                        style: sizeInfo.isDesktop
                                            ? textTheme.bodyLarge!
                                                .copyWith(letterSpacing: 1)
                                            : textTheme.bodyMedium!
                                                .copyWith(letterSpacing: 1),
                                      ),
                                      InkWell(
                                        child: Text(
                                          "Register",
                                          style: sizeInfo.isDesktop
                                              ? textTheme.bodyLarge!.copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w600)
                                              : textTheme.bodyMedium!.copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        onTap: () {
                                          debugPrint("clicked");
                                          context.go('/register');
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
