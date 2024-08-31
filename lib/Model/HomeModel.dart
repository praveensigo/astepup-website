class Home {
  String user;
  List<Course> myCourses;
  List<Course> inProgressCourses;

  Home({
    required this.user,
    required this.myCourses,
    required this.inProgressCourses,
  });

  factory Home.fromJson(Map<String, dynamic> json) => Home(
        user: json["user"],
        myCourses: List<Course>.from(
            json["my_courses"].map((x) => Course.fromJson(x))),
        inProgressCourses: List<Course>.from(
            json["in_progress_courses"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "my_courses": List<dynamic>.from(myCourses.map((x) => x.toJson())),
        "in_progress_courses":
            List<dynamic>.from(inProgressCourses.map((x) => x.toJson())),
      };
}

class Course {
  int? courseId;
  String courseName;
  String courseDescription;
  String courseIcon;
  String? certificateUrl;
  int? evaluationStatus;

  Course({
    this.courseId,
    required this.courseName,
    required this.courseDescription,
    required this.courseIcon,
    this.certificateUrl,
    this.evaluationStatus,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseId: json["course_id"] ?? "",
        courseName: json["course_name"] ?? "",
        courseDescription: json["course_description"] ?? "",
        courseIcon: json["course_icon"] ?? "",
        certificateUrl: json["certificate_url"] ?? "",
        evaluationStatus: json["evaluation_status"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "course_name": courseName,
        "course_description": courseDescription,
        "course_icon": courseIcon,
        'certificate_url': certificateUrl,
        "evaluation_status": evaluationStatus,
      };
}
