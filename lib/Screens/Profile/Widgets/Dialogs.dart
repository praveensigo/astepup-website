import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/ProfileController.dart';
import 'package:astepup_website/Model/CountrycodeModel.dart';
import 'package:astepup_website/Model/ProfileModel.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/UserInputFeild.dart';
import 'package:astepup_website/Screens/Widgets/coloredContainer.dart';
import 'package:astepup_website/Utils/Helper.dart';

class ProfileDialogs {
  final BuildContext buildContext;
  ProfileDialogs({
    required this.buildContext,
  });
  final textFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: borderColor, width: 1.4),
      borderRadius: BorderRadius.circular(6));
  BoxConstraints constraints = const BoxConstraints(maxHeight: 70);
  BoxConstraints dialogconstraints =
      const BoxConstraints(minWidth: 60, maxWidth: 550, maxHeight: 330);

  void editProfile({required ProfileData profileData}) {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
          initState: (_) {},
          builder: (controller) {
            controller.nameController.text = profileData.userName;
            controller.phoneController.text = profileData.mobile;
            controller.selectedCountryCode =
                controller.countryCodes.firstWhereOrNull(
              (element) => element.id == profileData.countryCodeId,
            );
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                controller.imageBytes = null;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: ColoredContainer(
                        constraints: const BoxConstraints(
                            minWidth: 70, maxWidth: 550, maxHeight: 450),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    controller.imageBytes = null;
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      controller.imageBytes == null
                                          ? CachedNetworkImage(
                                              httpHeaders: const {
                                                'Access-Control-Allow-Origin':
                                                    '*',
                                                'Access-Control-Allow-Method':
                                                    'GET',
                                              },
                                              imageUrl: ApiConfigs.imageUrl +
                                                  profileData.image,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                radius: 40,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.grey[800]!,
                                                ),
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                radius: 40,
                                                backgroundImage: imageProvider,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: ClipOval(
                                                child: SizedBox(
                                                  width: 80,
                                                  height: 80,
                                                  child: Image.memory(
                                                      controller.imageBytes!,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                      Positioned(
                                        bottom: 0,
                                        right: -5,
                                        child: InkWell(
                                          onTap: () {
                                            controller.pickFiles();
                                          },
                                          child: SvgPicture.asset(
                                              width: 30, CustomIcons.editicon),
                                        ),
                                      ),
                                    ],
                                  ),
                                  UserInputField(
                                    title: "Name",
                                    controller: controller.nameController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your name";
                                      }
                                      if (value.length < 3) {
                                        return Strings.nameLengthError;
                                      }
                                      if (value.length < 3) {
                                        return "Please enter a valid name";
                                      }

                                      return null;
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      constraints: constraints,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                      prefixIcon: Icon(Icons.person_rounded,
                                          color: textColor
                                              .withOpacity(.5)
                                              .withOpacity(.5)),
                                      hintText: "Enter your name",
                                      border: textFieldBorder,
                                      enabledBorder: textFieldBorder,
                                      focusedBorder: textFieldBorder,
                                    ),
                                  ),
                                  UserInputField(
                                    title: "Mobile number",
                                    controller: controller.phoneController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your mobile number";
                                      }
                                      if (value.length < 5) {
                                        return "Please enter a valid mobile number";
                                      }
                                      if (value.length < 6 ||
                                          value.length > 14) {
                                        return "The mobile number you entered is invalid. Please enter a number between 6 and 14 digits.";
                                      }
                                      return null;
                                    },
                                    textFeildheight: 90,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                      constraints: constraints,
                                      prefixIcon: Container(
                                        height: 60,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.call,
                                                color:
                                                    textColor.withOpacity(.5)),
                                            const SizedBox(width: 5),
                                            DropdownMenu<CountryCode>(
                                              width: 80,
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
                                              initialSelection: controller
                                                  .selectedCountryCode,
                                              onSelected: (value) {
                                                controller.selectedCountryCode =
                                                    value!;
                                                controller.update();
                                              },
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              width: 2,
                                              height: 45,
                                              color: textColor.withOpacity(.5),
                                            )
                                          ],
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                      hintText: "Enter mobile number",
                                      border: textFieldBorder,
                                      enabledBorder: textFieldBorder,
                                      focusedBorder: textFieldBorder,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          Navigator.pop(context);
                                          controller.updateProfileAPICall();
                                        }
                                      },
                                      child: Text(
                                        "SAVE".toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void forgotPassword() {
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: ColoredContainer(
                constraints: dialogconstraints,
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To change your password, enter the registered email, and we will send an OTP for the password change.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                      ),
                      UserInputField(
                        title: "Email",
                        decoration: InputDecoration(
                            constraints: constraints,
                            prefixIcon: Icon(Icons.email_outlined,
                                color:
                                    textColor.withOpacity(.5).withOpacity(.5)),
                            hintText: "Enter email",
                            border: textFieldBorder,
                            enabledBorder: textFieldBorder,
                            focusedBorder: textFieldBorder),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text("SAVE",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black)))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void otpDialog() {
    showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (BuildContext context) {
          var size = MediaQuery.of(context).size;
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Material(
                color: Colors.transparent,
                child: Center(
                    child: ColoredContainer(
                  constraints: dialogconstraints.copyWith(maxWidth: 530),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "OTP",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Enter the code sent to qwerty@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black),
                      ),
                      PinCodeTextField(
                        useHapticFeedback: true,
                        appContext: context,
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
                            SizedBox(width: size.width * .02),
                        obscureText: true,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        // validator: (v) {
                        //   if (v!.length < 3) {
                        //     return "I'm from validator";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        pinTheme: PinTheme(
                            fieldOuterPadding: EdgeInsets.zero,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Theme.of(context).primaryColor,
                            disabledColor: Theme.of(context).primaryColor,
                            activeColor: Theme.of(context).primaryColor,
                            selectedColor: Theme.of(context).primaryColor,
                            inactiveColor: Theme.of(context).primaryColor),
                        cursorColor: Colors.white,
                        textStyle: const TextStyle(color: Colors.black),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: false,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.transparent,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (pin) {},
                        onChanged: (value) {},
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Resend otp",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                          )),
                      Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("SEND",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black))),
                      )
                    ],
                  ),
                ))),
          );
        });
  }

  void changePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final controller = Get.find<ProfileController>();
    showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (BuildContext context) {
          bool showPassword1 = false;
          bool showPassword2 = false;
          bool showPassword3 = false;
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                  color: Colors.transparent,
                  child: Center(
                      child: ColoredContainer(
                    constraints: dialogconstraints.copyWith(
                        maxWidth: 530, maxHeight: 470),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 30,
                            ),
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                UserInputField(
                                  textFeildheight: 75,
                                  maxLines: 1,
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction:
                                      TextInputAction.continueAction,
                                  title: "Current password",
                                  obscureText: !showPassword1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    if (!value.isValidPassword()) {
                                      return Strings.passwordError;
                                    }
                                    if (value.length < 6 || value.length > 16) {
                                      return Strings.passwordLength;
                                    }
                                    return null;
                                  },
                                  controller:
                                      controller.currentPasswordController,
                                  decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                      constraints:
                                          const BoxConstraints(maxHeight: 55),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                      prefixIcon: Icon(Icons.lock,
                                          color: textColor.withOpacity(.5)),
                                      hintText: "Enter password",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showPassword1 = !showPassword1;
                                            });
                                          },
                                          icon: Icon(
                                              showPassword1
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color:
                                                  textColor.withOpacity(.5))),
                                      border: textFieldBorder,
                                      enabledBorder: textFieldBorder,
                                      focusedBorder: textFieldBorder),
                                ),
                                UserInputField(
                                  textFeildheight: 75,
                                  maxLines: 1,
                                  title: "New password",
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction:
                                      TextInputAction.continueAction,
                                  obscureText: !showPassword2,
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
                                  controller: controller.newPasswordController,
                                  decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                      constraints:
                                          const BoxConstraints(maxHeight: 55),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                      prefixIcon: Icon(Icons.lock,
                                          color: textColor.withOpacity(.5)),
                                      hintText: "Enter password",
                                      border: textFieldBorder,
                                      enabledBorder: textFieldBorder,
                                      focusedBorder: textFieldBorder),
                                ),
                                UserInputField(
                                  textFeildheight: 75,
                                  maxLines: 1,
                                  title: "Confirm New password",
                                  obscureText: !showPassword3,
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    if (controller.newPasswordController.text !=
                                        controller
                                            .confrimPasswordController.text) {
                                      return Strings.confrimPasswordError;
                                    }
                                    if (!value.isValidPassword()) {
                                      return Strings.passwordError;
                                    }
                                    if (value.length < 6 || value.length > 16) {
                                      return Strings.passwordLength;
                                    }
                                    return null;
                                  },
                                  controller:
                                      controller.confrimPasswordController,
                                  decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                      constraints:
                                          const BoxConstraints(maxHeight: 55),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                      prefixIcon: Icon(Icons.lock,
                                          color: textColor.withOpacity(.5)),
                                      hintText: "Enter password",
                                      border: textFieldBorder,
                                      enabledBorder: textFieldBorder,
                                      focusedBorder: textFieldBorder),
                                ),
                                Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(200, 50)),
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          bool password =
                                              await controller.updatePassword(
                                                  context: context,
                                                  confirmPassword: controller
                                                      .confrimPasswordController
                                                      .text,
                                                  currentPassword: controller
                                                      .currentPasswordController
                                                      .text,
                                                  newPassword: controller
                                                      .newPasswordController
                                                      .text);
                                          if (password) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: Text("SAVE",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
            );
          });
        });
  }
}
