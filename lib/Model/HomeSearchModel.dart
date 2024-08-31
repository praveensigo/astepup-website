

class HomeSearchModel {
    int id;
    int userId;
    int courseId;
    int stageId;
    int moduleId;
    int sectionId;
    int status;
    int quizResult;
    int addedBy;
    int updatedBy;
    DateTime createdAt;
    DateTime updatedAt;
    String sectionName;
    String moduleName;
    String stageName;
    String courseName;

    HomeSearchModel({
        required this.id,
        required this.userId,
        required this.courseId,
        required this.stageId,
        required this.moduleId,
        required this.sectionId,
        required this.status,
        required this.quizResult,
        required this.addedBy,
        required this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.sectionName,
        required this.moduleName,
        required this.stageName,
        required this.courseName,
    });

    factory HomeSearchModel.fromJson(Map<String, dynamic> json) => HomeSearchModel(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        stageId: json["stage_id"],
        moduleId: json["module_id"],
        sectionId: json["section_id"],
        status: json["status"],
        quizResult: json["quiz_result"],
        addedBy: json["added_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sectionName: json["section_name"],
        moduleName: json["module_name"],
        stageName: json["stage_name"],
        courseName: json["course_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "stage_id": stageId,
        "module_id": moduleId,
        "section_id": sectionId,
        "status": status,
        "quiz_result": quizResult,
        "added_by": addedBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "section_name": sectionName,
        "module_name": moduleName,
        "stage_name": stageName,
        "course_name": courseName
    };
}

