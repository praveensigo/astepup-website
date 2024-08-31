import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/RegisterController.dart';
import 'package:astepup_website/Model/CountrycodeModel.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/UserInputFeild.dart';
import 'package:astepup_website/Screens/Widgets/coloredContainer.dart';
import 'package:astepup_website/Utils/Helper.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  BoxConstraints constraints = const BoxConstraints(maxHeight: 75);
  final formKey = GlobalKey<FormState>();
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));
  List<bool> isHide = [false, false];
  final _debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: GetBuilder<RegisterController>(
      init: RegisterController(),
      initState: (_) {},
      builder: (controller) {
        return ResponsiveBuilder(builder: (context, sizeInfo) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sizeInfo.isDesktop ? 40 : 20, vertical: 15),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
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
                    const SizedBox(height: 30),
                    ColoredContainer(
                      constraints: const BoxConstraints(
                        minWidth: 200,
                        maxWidth: 850,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: sizeInfo.isDesktop ? 100 : 30,
                          vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register",
                            style: textTheme.headlineMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          UserInputField(
                            title: "Unique code",
                            textInputAction: TextInputAction.continueAction,
                            controller: controller.uniqueCodeController,
                            maxLines: 1,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [UpperCaseTextFormatter()],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your unique code";
                              }
                              if (value.length < 10) {
                                return "Enter a valid unique code";
                              }
                              return null;
                            },
                            onChanged: (value) async {
                              _debouncer.run(() {
                                controller.getUserData(value);
                              });
                            },
                            decoration: InputDecoration(
                                constraints: constraints,
                                errorText: controller.uniqueCodeError,
                                prefixIcon: Icon(Icons.password_outlined,
                                    color: textColor.withOpacity(.5)),
                                hintText: "Enter the unique code",
                                border: textFieldBorder,
                                enabledBorder: textFieldBorder,
                                focusedBorder: textFieldBorder),
                          ),
                          UserInputField(
                            title: "Name",
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]")),
                            ],
                            textInputAction: TextInputAction.continueAction,
                            keyboardType: TextInputType.name,
                            controller: controller.nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your name";
                              }
                              if (value.length < 3) {
                                return Strings.nameLengthError;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                constraints: constraints,
                                prefixIcon: Icon(Icons.person_rounded,
                                    color: textColor.withOpacity(.5)),
                                hintText: "Enter your name",
                                border: textFieldBorder,
                                enabledBorder: textFieldBorder,
                                focusedBorder: textFieldBorder),
                          ),
                          UserInputField(
                            readOnly: true,
                            title: "Email",
                            validator: (value) {
                              // if (!value!.isValidEmail()) {
                              //   return "Enter a valid email";
                              // }
                              return null;
                            },
                            controller: controller.emailController,
                            decoration: InputDecoration(
                                constraints: constraints,
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: textColor.withOpacity(.5)),
                                hintText: "Enter email",
                                border: textFieldBorder,
                                enabledBorder: textFieldBorder,
                                focusedBorder: textFieldBorder),
                          ),
                          UserInputField(
                            readOnly: true,
                            title: "Mobile number",
                            controller: controller.mobileController,
                            decoration: InputDecoration(
                                constraints:
                                    const BoxConstraints(maxHeight: 55),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SizedBox(
                                    // height: 75,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.call,
                                            color: textColor.withOpacity(.5)),
                                        const SizedBox(width: 5),
                                        DropdownMenu<CountryCode>(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                          width: 70,
                                          // enabled: false,
                                          inputDecorationTheme:
                                              const InputDecorationTheme(
                                                  border: InputBorder.none),
                                          dropdownMenuEntries: controller
                                              .countryCodes
                                              .map<
                                                  DropdownMenuEntry<
                                                      CountryCode>>(
                                                (e) => DropdownMenuEntry<
                                                    CountryCode>(
                                                  value: e,
                                                  label: e.countryCode,
                                                ),
                                              )
                                              .toList(),
                                          trailingIcon: const Icon(
                                              Icons.expand_more_rounded),
                                          initialSelection:
                                              controller.selectedCountryCode,
                                          onSelected: (value) {
                                            controller.selectedCountryCode =
                                                value!;
                                            controller.update();
                                          },
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          width: 2,
                                          height: 45,
                                          color: textColor.withOpacity(.5),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: "Enter mobile number",
                                border: textFieldBorder,
                                enabledBorder: textFieldBorder,
                                focusedBorder: textFieldBorder),
                          ),
                          UserInputField(
                            textFeildheight: 75,
                            title: "Password",
                            textInputAction: TextInputAction.continueAction,
                            obscureText: !isHide[0],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your password";
                              }
                              if (!value.isValidPassword()) {
                                return Strings.passwordError;
                              }
                              if (value.length < 6 || value.length > 16) {
                                return Strings.passwordLength;
                              }
                              return null;
                            },
                            maxLines: 1,
                            obscuringCharacter: "*",
                            controller: controller.passwordController,
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
                                constraints: constraints,
                                // suffixIcon: IconButton(
                                //   onPressed: () {
                                //     setState(() {
                                //       isHide[0] = !isHide[0];
                                //     });
                                //   },
                                //   icon: Icon(
                                //       isHide[0]
                                //           ? Icons.visibility_outlined
                                //           : Icons.visibility_off_outlined,
                                //       color: textColor.withOpacity(.5)),
                                // ),
                                hintText: "Enter password",
                                border: textFieldBorder,
                                enabledBorder: textFieldBorder,
                                focusedBorder: textFieldBorder),
                          ),
                          UserInputField(
                            textFeildheight: 75,
                            textInputAction: TextInputAction.done,
                            title: "Confirm password",
                            obscureText: !isHide[1],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your confrim password";
                              }
                              if (!value.isValidPassword()) {
                                return Strings.passwordError;
                              }
                              if (value.length < 6 || value.length > 16) {
                                return Strings.passwordLength;
                              }
                              if (controller.confirmPasswordController.text !=
                                  controller.passwordController.text) {
                                return Strings.confrimPasswordError;
                              }
                              return null;
                            },
                            maxLines: 1,
                            obscuringCharacter: "*",
                            controller: controller.confirmPasswordController,
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                controller.completeProfileAPI(context);
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
                                constraints: constraints,
                                prefixIcon: Icon(Icons.lock,
                                    color: textColor.withOpacity(.5)),
                                // suffixIcon: IconButton(
                                //   onPressed: () {
                                //     setState(() {
                                //       isHide[1] = !isHide[1];
                                //     });
                                //   },
                                //   icon: Icon(
                                //       isHide[1]
                                //           ? Icons.visibility_outlined
                                //           : Icons.visibility_off_outlined,
                                //       color: textColor.withOpacity(.5)),
                                // ),
                                hintText: "Enter confirm password",
                                border: textFieldBorder,
                                enabledBorder: textFieldBorder,
                                focusedBorder: textFieldBorder),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          controller
                                              .completeProfileAPI(context);
                                        }
                                      },
                                      child: Text(
                                        "Register".toUpperCase(),
                                        style: textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ))),
                              const SizedBox(height: 15),
                              Wrap(
                                runAlignment: WrapAlignment.center,
                                alignment: WrapAlignment.start,
                                children: [
                                  Text(
                                    "Already have an account?  ",
                                    style: sizeInfo.isDesktop
                                        ? textTheme.bodyLarge
                                        : textTheme.bodyMedium,
                                  ),
                                  InkWell(
                                    child: Text(
                                      "Login",
                                      style: sizeInfo.isDesktop
                                          ? textTheme.bodyLarge!.copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w600)
                                          : textTheme.bodyMedium!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                    ),
                                    onTap: () {
                                      context.go('/login');
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    ));
  }
}
