class StageDetail {
  String stageKey;
  int stageId;
  String stageName;
  String stageDescription;
  int questionCount;
  int stageCompletedStatus;
  int stageQuizCompletedStatus;
  int moduleCount;
  String totalHours;
  int sectionCount;
  String quizCompletedPercentage;
  String lessonCompletedPercentage;
  String quizCorrectPercentage;
  String hoursTotalSpent;
  int quizResult;
  List<Module> modules;
  int dependent;
  List<ModuleStatus> moduleStatus;

  StageDetail({
    this.stageKey = '',
    required this.stageId,
    required this.stageName,
    required this.stageDescription,
    required this.questionCount,
    required this.stageCompletedStatus,
    required this.stageQuizCompletedStatus,
    required this.moduleCount,
    this.totalHours = '',
    required this.sectionCount,
    this.quizCompletedPercentage = '',
    this.lessonCompletedPercentage = '',
    this.quizCorrectPercentage = '',
    this.hoursTotalSpent = '',
    required this.quizResult,
    required this.modules,
    required this.dependent,
    required this.moduleStatus,
  });

  factory StageDetail.fromJson(Map<String, dynamic> json) => StageDetail(
        stageKey: json["key"] ?? "",
        stageId: json["stage_id"],
        stageName: json["stage_name"],
        stageDescription: json["stage_description"],
        questionCount: json["question_count"],
        stageCompletedStatus: json["stage_completed_status"],
        stageQuizCompletedStatus: json["stage_quiz_completed_status"],
        moduleCount: json["module_count"],
        totalHours: json["total_hours"].isEmpty || json["total_hours"] == null
            ? "0 Hour"
            : json["total_hours"],
        sectionCount: json["section_count"],
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
        quizResult: json["quiz_result"],
        moduleStatus: List<ModuleStatus>.from(
            json["stage_module_status"].map((x) => ModuleStatus.fromJson(x))),
        modules:
            List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
        dependent: json["dependent"],
      );

  Map<String, dynamic> toJson() => {
        "key": stageKey,
        "stage_id": stageId,
        "stage_name": stageName,
        "stage_description": stageDescription,
        "question_count": questionCount,
        "stage_completed_status": stageCompletedStatus,
        "stage_quiz_completed_status": stageQuizCompletedStatus,
        "module_count": moduleCount,
        "total_hours": totalHours,
        "section_count": sectionCount,
        "quiz_completed_percentage": quizCompletedPercentage,
        "lesson_completed_percentage": lessonCompletedPercentage,
        "quiz_correct_percentage": quizCorrectPercentage,
        "hours_total_spent": hoursTotalSpent,
        "quiz_result": quizResult,
        "stage_module_status":
            List<dynamic>.from(moduleStatus.map((x) => x.toJson())),
        "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
        "dependent": dependent,
      };
}

class Module {
  int moduleId;
  String moduleName;

  Module({
    required this.moduleId,
    required this.moduleName,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        moduleId: json["module_id"],
        moduleName: json["module_name"],
      );

  Map<String, dynamic> toJson() => {
        "module_id": moduleId,
        "module_name": moduleName,
      };
}

class ModuleStatus {
  int sectionId;
  int completedStatus;
  int quizResult;

  ModuleStatus({
    required this.sectionId,
    required this.completedStatus,
    required this.quizResult,
  });

  factory ModuleStatus.fromJson(Map<String, dynamic> json) => ModuleStatus(
        sectionId: json["module_id"],
        completedStatus: json["completed_status"],
        quizResult: json["quiz_result"],
      );

  Map<String, dynamic> toJson() => {
        "module_id": sectionId,
        "completed_status": completedStatus,
        "quiz_result": quizResult,
      };
}
