class ModuleDetails {
  String moduleKey;
  String parentKey;
  int moduleId;
  String moduleName;
  String moduleDescription;
  int moduleCompletedStatus;
  int moduleQuizCompletedStatus;
  int sectionCount;
  String totalHours;
  int questionCount;
  String quizCompletedPercentage;
  String lessonCompletedPercentage;
  String quizCorrectPercentage;
  String hoursTotalSpent;
  int quizResult;
  List<Section> sections;
  List<SectionStatus> sectionStatus;
  int dependent;

  ModuleDetails({
    this.moduleKey = '',
    this.parentKey = '',
    required this.moduleId,
    required this.moduleName,
    required this.moduleDescription,
    required this.moduleCompletedStatus,
    required this.moduleQuizCompletedStatus,
    required this.sectionCount,
    required this.questionCount,
    this.totalHours = '',
    this.quizCompletedPercentage = '',
    this.lessonCompletedPercentage = '',
    this.quizCorrectPercentage = '',
    this.hoursTotalSpent = '',
    required this.quizResult,
    required this.sections,
    required this.dependent,
    required this.sectionStatus,
  });

  factory ModuleDetails.fromJson(Map<String, dynamic> json) => ModuleDetails(
        moduleKey: json["key"] ?? "",
        parentKey: json["parent_key"] ?? "",
        moduleId: json["module_id"],
        moduleName: json["module_name"],
        moduleDescription: json["module_description"],
        moduleCompletedStatus: json["module_completed_status"],
        moduleQuizCompletedStatus: json["module_quiz_completed_status"],
        sectionCount: json["section_count"],
        totalHours: json["total_hours"].isEmpty || json["total_hours"] == null
            ? "0 Hour"
            : json["total_hours"],
        questionCount: json["question_count"] ?? 0,
        quizCompletedPercentage: json["quiz_completed_percentage"] == null
            ? ''
            : json["quiz_completed_percentage"].toString(),
        lessonCompletedPercentage: json["lesson_completed_percentage"] == null
            ? ""
            : json["lesson_completed_percentage"].toString(),
        quizCorrectPercentage: json["quiz_correct_percentage"] == null
            ? ""
            : json["quiz_correct_percentage"].toString(),
        hoursTotalSpent: json["hours_total_spent"] == null ||
                json["hours_total_spent"].isEmpty
            ? "0 Hour"
            : json["hours_total_spent"],
        quizResult: json["quiz_result"] ?? 0,
        sectionStatus: List<SectionStatus>.from(json["module_section_status"]
            .map((x) => SectionStatus.fromJson(x))),
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
        dependent: json["dependent"],
      );

  Map<String, dynamic> toJson() => {
        "key": moduleKey,
        "parent_key": parentKey,
        "module_id": moduleId,
        "module_name": moduleName,
        "module_description": moduleDescription,
        "module_completed_status": moduleCompletedStatus,
        "module_quiz_completed_status": moduleQuizCompletedStatus,
        "section_count": sectionCount,
        "total_hours": totalHours,
        "question_count": questionCount,
        "quiz_completed_percentage": quizCompletedPercentage,
        "lesson_completed_percentage": lessonCompletedPercentage,
        "quiz_correct_percentage": quizCorrectPercentage,
        "hours_total_spent": hoursTotalSpent,
        "quiz_result": quizResult,
        "module_section_status":
            List<dynamic>.from(sectionStatus.map((x) => x.toJson())),
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
        "dependent": dependent,
      };
}

class Section {
  int sectionId;
  String sectionName;
  String totalTime;

  Section({
    required this.sectionId,
    required this.sectionName,
    required this.totalTime,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        sectionId: json["section_id"],
        sectionName: json["section_name"],
        totalTime: json["total_time"],
      );

  Map<String, dynamic> toJson() => {
        "section_id": sectionId,
        "section_name": sectionName,
        "total_time": totalTime,
      };
}

class SectionStatus {
  int sectionId;
  int completedStatus;
  int quizResult;

  SectionStatus({
    required this.sectionId,
    required this.completedStatus,
    required this.quizResult,
  });

  factory SectionStatus.fromJson(Map<String, dynamic> json) => SectionStatus(
        sectionId: json["section_id"],
        completedStatus: json["completed_status"],
        quizResult: json["quiz_result"],
      );

  Map<String, dynamic> toJson() => {
        "section_id": sectionId,
        "completed_status": completedStatus,
        "quiz_result": quizResult,
      };
}
