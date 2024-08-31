class SectionDetail {
  String sectionKey;
  String parentKey;
  int sectionId;
  String sectionName;
  String sectionDescription;
  int sectionCompletedStatus;
  int sectionQuizCompletedStatus;
  String totalDuration;
  int lessonCount;
  String quizCompletedPercentage;
  String lessonCompletedPercentage;
  String quizCorrectPercentage;
  String hoursTotalSpent;
  int quizResult;
  List<Video> videos;
  int questionCount;
  List<VideoStatus> videoStatus;
  int dependent;

  SectionDetail({
    this.sectionKey = '',
    this.parentKey = '',
    required this.sectionId,
    required this.sectionName,
    required this.sectionDescription,
    required this.sectionCompletedStatus,
    required this.sectionQuizCompletedStatus,
    this.totalDuration = '',
    required this.lessonCount,
    this.quizCompletedPercentage = '',
    this.lessonCompletedPercentage = '',
    this.quizCorrectPercentage = '',
    this.hoursTotalSpent = '',
    required this.quizResult,
    required this.videos,
    required this.questionCount,
    required this.videoStatus,
    required this.dependent,
  });

  factory SectionDetail.fromJson(Map<String, dynamic> json) => SectionDetail(
        sectionKey: json["key"] ?? "",
        parentKey: json["parent_key"] ?? "",
        sectionId: json["section_id"],
        sectionName: json["section_name"],
        sectionDescription: json["section_description"],
        totalDuration:
            json["total_duration"].isEmpty || json["total_duration"] == null
                ? "0 Hour"
                : json["total_duration"],
        lessonCount: json["lesson_count"],
        sectionCompletedStatus: json["section_completed_status"],
        sectionQuizCompletedStatus: json["section_quiz_completed_status"],
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
        quizResult: json["quiz_result"] ?? 2,
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        questionCount: json["question_count"],
        videoStatus: List<VideoStatus>.from(
            json["video_status"].map((x) => VideoStatus.fromJson(x))),
        dependent: json["dependent"] ?? 2,
      );

  Map<String, dynamic> toJson() => {
        "key": sectionKey,
        "parent_key": parentKey,
        "section_id": sectionId,
        "section_name": sectionName,
        "section_description": sectionDescription,
        "section_completed_status": sectionCompletedStatus,
        "section_quiz_completed_status": sectionQuizCompletedStatus,
        "total_duration": totalDuration,
        "lesson_count": lessonCount,
        "quiz_completed_percentage": quizCompletedPercentage,
        "lesson_completed_percentage": lessonCompletedPercentage,
        "quiz_correct_percentage": quizCorrectPercentage,
        "hours_total_spent": hoursTotalSpent,
        "quiz_result": quizResult,
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
        "question_count": questionCount,
        "video_status": List<dynamic>.from(videoStatus.map((x) => x.toJson())),
        "dependent": dependent,
      };
}

class VideoStatus {
  int videoId;
  int watchStatus;
  int dependent;

  VideoStatus({
    required this.videoId,
    required this.watchStatus,
    required this.dependent,
  });

  factory VideoStatus.fromJson(Map<String, dynamic> json) => VideoStatus(
        videoId: json["video_id"],
        watchStatus: json["watch_status"],
        dependent: json["dependent"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "watch_status": watchStatus,
        "dependent": dependent,
      };
}

class Video {
  int videoId;
  String videoName;
  String presenter;
  String videoDuration;

  Video({
    required this.videoId,
    required this.videoName,
    required this.presenter,
    required this.videoDuration,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videoId: json["video_id"],
        videoName: json["video_name"],
        presenter: json["presenter"],
        videoDuration: json["video_duration"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "video_name": videoName,
        "presenter": presenter,
        "video_duration": videoDuration,
      };
}
