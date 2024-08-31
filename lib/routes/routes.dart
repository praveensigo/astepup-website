class Routes {
  static const String globalPath = '';
  static const String home = '$globalPath/';
  static const String intro = '$globalPath/welcome';
  static const String settings = '$globalPath/settings';
  static const String lesson = '$globalPath/lesson';
  static String detail(String id) => '$globalPath/detail/$id';
  static String section(String id) => '$globalPath/section/$id';
  static String sectionReview(String id) => '$globalPath/section-review/$id';
  static String sectionResult(String id) => '$globalPath/section-result/$id';
  static String sectionAnswer(String id) => '$globalPath/section-answer/$id';
  static String module(String id) => '$globalPath/module/$id';
  static String moduleReview(String id) => '$globalPath/module-review/$id';
  static String moduleResult(String id) => '$globalPath/module-result/$id';
  static String moduleAnswer(String id) => '$globalPath/module-answer/$id';
  static String stageReview(String id) => '$globalPath/stage-review/$id';
  static String stageAnswerReview(String id) =>
      '$globalPath/stage-answer-review/$id';
  static String stageResult(String id) => '$globalPath/stage-result/$id';
  static String stage(String id) => '$globalPath/stage/$id';
  static String mastery(String id) => '$globalPath/mastery/$id';
  static String masteryResult(String id) => '$globalPath/mastery-result/$id';
  static String masteryReview(String id) => '$globalPath/mastery-review/$id';
  static const String masteryAssesmentSummery =
      '$globalPath/mastery-assesment_summery';
  static const String answerSummary = '$globalPath/answer-summery';
  static const String certificate = '$globalPath/certificate';
  static const String evaluationSurvey = '$globalPath/evaluation-survey';
  static const String mobileSearch = '$globalPath/mobile-search';
  static const String login = '$globalPath/login';
  static const String register = '$globalPath/register';
  static const String forgotPassword = '$globalPath/forgot';
  static const String otp = '$globalPath/otp';
  static const String newPassword = '$globalPath/newpassword';
  static const String contactUs = '$globalPath/contactus';
  static const String aboutUs = '$globalPath/aboutus';
  static const String termsAndConditions = '$globalPath/terms';
  static const String privacyPolicy = '$globalPath/privacy';
  static const String faq = '$globalPath/faq';
  static const String contributors = '$globalPath/contributors';
  static const String profile = '$globalPath/profile';
  static String viewCertificate(String cid) =>
      '$globalPath/viewCertificate/$cid';
  static const String notFound = '$globalPath/404';
  static const String maintenance = '$globalPath/maintenance';
  static const String serverDown = '$globalPath/500';
}
