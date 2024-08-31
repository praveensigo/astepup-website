import 'package:astepup_website/Model/HomeModel.dart';

class ProfileData {
  int userId;
  String userName;
  String email;
  String mobile;
  String image;
  int countryCodeId;
  String countryCode;
  String organization;
  List<Course> inprogressCourse;
  List<Course> completedCourse;

  ProfileData(
      {required this.userId,
      required this.userName,
      required this.email,
      required this.mobile,
      required this.image,
      required this.organization,
      required this.inprogressCourse,
      required this.completedCourse,
      required this.countryCode,
      required this.countryCodeId});

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        userId: json["user_id"],
        countryCodeId: json["country_code_id"] ?? 0,
        countryCode: json["country_code"] ?? "",
        userName: json["user_name"] ?? "user name",
        email: json["email"] ?? "user email",
        mobile: json["mobile"] ?? "user mobile",
        image: json["image"] ?? "",
        organization: json["organization"],
        inprogressCourse: List<Course>.from(
            json["inprogressCourse"].map((x) => Course.fromJson(x))),
        completedCourse: List<Course>.from(
            json["completedCourse"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "country_code_id": countryCodeId,
        "country_code": countryCode,
        "user_name": userName,
        "email": email,
        "mobile": mobile,
        "image": image,
        "organization": organization,
        "inprogressCourse":
            List<dynamic>.from(inprogressCourse.map((x) => x.toJson())),
        "completedCourse":
            List<dynamic>.from(completedCourse.map((x) => x.toJson())),
      };
}
