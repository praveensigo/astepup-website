class CourseDetails {
  String courseName;
  String courseDescription;
  String image;
  int stageFlow;
  int moduleFlow;
  int sectionFlow;
  String durationHours;
  int stageCount;
  int sectionCount;
  int questionCount;
  int courseStatus;
  String quizCompletedPercentage;
  String lessonCompletedPercentage;
  String quizCorrectPercentage;
  String totalHourSpent;
  int quizResult;
  List<Stage> stages;
  List<StageStatus> stageStatus;
  String evaluationStatus;

  CourseDetails({
    required this.courseName,
    required this.courseDescription,
    required this.image,
    required this.stageFlow,
    required this.moduleFlow,
    required this.sectionFlow,
    required this.durationHours,
    required this.stageCount,
    required this.sectionCount,
    required this.questionCount,
    required this.courseStatus,
    required this.quizCompletedPercentage,
    required this.lessonCompletedPercentage,
    required this.quizCorrectPercentage,
    required this.totalHourSpent,
    required this.quizResult,
    required this.stages,
    required this.stageStatus,
    this.evaluationStatus = '',
  });

  factory CourseDetails.fromJson(Map<String, dynamic> json) => CourseDetails(
        courseName: json["course_name"] ?? "course name",
        courseDescription: json["course_description"] ?? "course desc",
        image: json["image"] ?? "image",
        evaluationStatus: json['evaluation_status'] == null
            ? "1"
            : json['evaluation_status'].toString(),
        stageFlow: json["stage_flow"] ?? 2,
        moduleFlow: json["module_flow"] ?? 2,
        sectionFlow: json["section_flow"] ?? 2,
        durationHours: json["duration_hours"] ?? "",
        stageCount: json["stage_count"] ?? 0,
        sectionCount: json["section_count"] ?? 0,
        questionCount: json["question_count"] ?? 0,
        courseStatus: json["course_status"] ?? 0,
        quizResult: json['quiz_result'] ?? 0,
        quizCorrectPercentage: json["quiz_correct_percentage"] == null
            ? "0"
            : json["quiz_correct_percentage"].toString(),
        totalHourSpent: json["hours_total_spent"] == null ||
                json["hours_total_spent"].isEmpty
            ? "0 Hour"
            : json["hours_total_spent"],
        quizCompletedPercentage: json["quiz_completed_percentage"] == null
            ? "0"
            : json["quiz_completed_percentage"].toString(),
        lessonCompletedPercentage: json["lesson_completed_percentage"] ?? "0",
        stageStatus: List<StageStatus>.from(
            json["course_stage_status"].map((x) => StageStatus.fromJson(x))),
        stages: List<Stage>.from(json["stages"].map((x) => Stage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course_name": courseName,
        "course_description": courseDescription,
        "image": image,
        "stage_flow": stageFlow,
        "module_flow": moduleFlow,
        "section_flow": sectionFlow,
        "duration_hours": durationHours,
        "stage_count": stageCount,
        "section_count": sectionCount,
        "question_count": questionCount,
        "course_status": courseStatus,
        "quiz_completed_percentage": quizCompletedPercentage,
        "lesson_completed_percentage": lessonCompletedPercentage,
        "quiz_correct_percentage": quizCorrectPercentage,
        "hours_total_spent": totalHourSpent,
        "quiz_result": quizResult,
        "course_stage_status":
            List<dynamic>.from(stageStatus.map((x) => x.toJson())),
        "stages": List<dynamic>.from(stages.map((x) => x.toJson())),
        "evaluation_status": evaluationStatus,
      };
}

class Stage {
  int id;
  String name;

  Stage({
    required this.id,
    required this.name,
  });

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        id: json["id"] ?? 0,
        name: json["name"] ?? "name",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class StageStatus {
  int sectionId;
  int completedStatus;
  int quizResult;

  StageStatus({
    required this.sectionId,
    required this.completedStatus,
    required this.quizResult,
  });

  factory StageStatus.fromJson(Map<String, dynamic> json) => StageStatus(
        sectionId: json["stage_id"],
        completedStatus: json["completed_status"],
        quizResult: json["quiz_result"],
      );

  Map<String, dynamic> toJson() => {
        "stage_id": sectionId,
        "completed_status": completedStatus,
        "quiz_result": quizResult,
      };
}
