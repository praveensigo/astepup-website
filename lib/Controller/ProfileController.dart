import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/CountrycodeModel.dart';
import 'package:astepup_website/Model/ProfileModel.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:http_parser/http_parser.dart'; // Add this import statement

class ProfileController extends GetxController {
  bool isLoading = true;
  ProfileData? profileData;
  DioInspector inspector = DioInspector(Dio());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confrimPasswordController = TextEditingController();
  Image? selectedImage;
  CountryCode? selectedCountryCode;
  List<CountryCode> countryCodes = [];
  List<PlatformFile>? paths = []; // Initialize _paths variable
  Uint8List? imageBytes;

  @override
  void onInit() {
    getCountryCode();
    profileAPICall();
    super.onInit();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confrimPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  getCountryCode() async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.getCountryCodes;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url),
      );
      if (response.statusCode == 200) {
        response.data['data']['country_codes']
            .map((e) => countryCodes.add(CountryCode.fromJson(e)))
            .toList();
        if (countryCodes.isNotEmpty) {
          selectedCountryCode = countryCodes.first;
        }
        update();
      }
    } catch (e) {
      if (e is DioException) {
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    }
  }

  profileAPICall() async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.profile;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url),
      );
      if (response.statusCode == 200) {
        profileData = ProfileData.fromJson(response.data['data']);
        saveObject('userData', {
          "name": profileData!.userName,
          "organization_name": profileData!.organization,
          'image': profileData!.image,
        });
        isLoading = false;
        update();
      }
    } catch (e) {
      if (e is DioException) {
        Map<String, dynamic> message = e.response?.data['message'];
        showErrorToast(message);
      } else {
        print(e.toString());
      }
    }
  }

  void updateProfileAPICall() async {
    try {
      isLoading = true;
      update();

      var url = ApiConfigs.baseUrl + ApiEndPoints.editProfile;
      FormData data = FormData.fromMap({
        "user_id": profileData!.userId,
        "name": nameController.text,
        "mobile": phoneController.text,
        "country_code": selectedCountryCode!.id,
        "image": paths!.isEmpty
            ? ""
            : MultipartFile.fromBytes(
                (paths!.first.bytes!),
                filename: paths!.first.name,
                contentType: MediaType("image", "png"),
              ),
      });

      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        profileAPICall();
        // showToast(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        Map<String, dynamic> message = e.response?.data['message'];
        showToast(
            message['image'].toString().replaceAll(RegExp(r'[\[\]]'), ''));
      } else {
        showToast(e.toString());
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> updatePassword(
      {required BuildContext context,
      required String currentPassword,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      showDialog(
          context: context,
          builder: (_) {
            return Center(
              child: Container(
                width: 55,
                height: 55,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const CircularProgressIndicator(),
              ),
            );
          });
      var url = ApiConfigs.baseUrl + ApiEndPoints.changePassword;
      FormData data = FormData.fromMap({
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmPassword,
      });

      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        // showToast(response.data['message']);
        currentPasswordController.clear();
        newPasswordController.clear();
        confrimPasswordController.clear();
        return true;
      }
    } catch (e) {
      Navigator.pop(context);
      if (e is DioException) {
        print(e.response?.data);
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    }
    return false;
  }

  void pickFiles() async {
    try {
      paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: [
          'png',
          'jpg',
          'jpeg',
        ],
      ))
          ?.files;
      if (paths != null && paths!.isNotEmpty) {
        final fileBytes = paths!.first.bytes!;
        imageBytes = Uint8List.fromList(fileBytes);
        update();
      }
    } on PlatformException catch (e) {
      showToast(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
