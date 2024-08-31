import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/ForgotPasswordController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/UserInputFeild.dart';
import 'package:astepup_website/Screens/Widgets/coloredContainer.dart';
import 'package:astepup_website/Utils/Helper.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NewPassword extends StatefulWidget {
  NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final formKey = GlobalKey<FormState>();
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));
  bool showPassword1 = false;
  bool showPassword2 = false;

  List<String> passwordRequired = [
    'Minimum of 6 characters',
    'Include at least one lower case letter',
    'Include at least one upper case letter',
    'Include at least one number'
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<ForgotController>(
      init: ForgotController(),
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          body: ResponsiveBuilder(builder: (context, sizeInfo) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: sizeInfo.isDesktop ? 100 : 20,
                                vertical: sizeInfo.isDesktop ? 15 : 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "New password",
                                    style: textTheme.headlineMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Set a new password for your account",
                                    style: textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: textColor.withOpacity(.5)),
                                  ),
                                  UserInputField(
                                    title: "New password",
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction:
                                        TextInputAction.continueAction,
                                    controller: controller.passwordController,
                                    obscureText: !showPassword1,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      if (!value.isValidPassword()) {
                                        return Strings.passwordError;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        errorMaxLines: 2,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                        errorStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: Colors.red),
                                        prefixIcon: Icon(Icons.lock,
                                            color: textColor.withOpacity(.5)),
                                        hintText: "Enter password",
                                        border: textFieldBorder,
                                        enabledBorder: textFieldBorder,
                                        focusedBorder: textFieldBorder),
                                  ),
                                  UserInputField(
                                    controller:
                                        controller.confirmPasswordController,
                                    title: "Confirm password",
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 1,
                                    obscureText: !showPassword2,
                                    onFieldSubmitted: (value) async {
                                      if (formKey.currentState!.validate()) {
                                        await controller.resetPassword(context);
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      if (!value.isValidPassword()) {
                                        return Strings.passwordError;
                                      }
                                      if (controller.passwordController.text !=
                                          controller
                                              .confirmPasswordController.text) {
                                        return Strings.confrimPasswordError;
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        errorMaxLines: 2,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                        errorStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: Colors.red),
                                        prefixIcon: Icon(Icons.lock,
                                            color: textColor.withOpacity(.5)),
                                        hintText: "Enter password",
                                        border: textFieldBorder,
                                        enabledBorder: textFieldBorder,
                                        focusedBorder: textFieldBorder),
                                  ),
                                  Text(
                                    "Password must contain:",
                                    style: textTheme.bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          passwordRequired.length,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              shape: BoxShape
                                                                  .circle),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Flexible(
                                                      child: Text(
                                                        passwordRequired[index],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          await controller
                                              .resetPassword(context);
                                        }
                                      },
                                      child: Text(
                                        "SUBMIT",
                                        style: textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ))
                                ]),
                          )
                        ]))));
          }),
        );
      },
    );
  }
}
