import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Home/Widgets/MobileSearch.dart';
import 'package:astepup_website/Screens/Modules/ModulesStart.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

import '../Screens/Screens.dart';
import '../Screens/Widgets/AnswerSummary.dart';

class AppRouter {
  final GoRouter goRouter;
  static AppRouter? _instance;
  static late String initialPath;
  AppRouter._internal(this.goRouter);
  factory AppRouter({String? initialPath}) {
    AppRouter.initialPath = initialPath ?? '/';
    _instance ??= AppRouter._internal(_createGoRouter());
    token = getSavedObject('token') ?? "";
    return _instance!;
  }
  static clearData() {
    removename(StorageKeys.quizData);
    removename(StorageKeys.videoId);
    removename(StorageKeys.lessonIndex);
    removename(StorageKeys.quizPercentage);
    removename(StorageKeys.quizList);
    removename(StorageKeys.stageId);
    removename(StorageKeys.moduleId);
    removename(StorageKeys.sectionId);
    removename(StorageKeys.stageDetails);
    removename(StorageKeys.courseId);
  }

  // Method to create GoRouter instance
  static String token = "";

  static redirectRoute(String currentRoute) {
    switch (currentRoute) {
      case "/login":
        return "/login";
      case '/forgot':
        return '/forgot';
      case '/newpassword':
        return '/newpassword';
      case '/otp':
        return '/otp';
      case '/register':
        return '/register';
      case '/maintenance':
        return '/maintenance';
      default:
        return "/login";
    }
  }

  static GoRouter _createGoRouter() {
    return GoRouter(
      requestFocus: false,
      navigatorKey: rootNavigatorKey,
      initialLocation: initialPath,
      overridePlatformDefaultLocation: true,
      debugLogDiagnostics: false,
      redirect: (context, state) {
        token = getSavedObject('token') ?? "";
        if (token.isEmpty) {
          return redirectRoute(state.matchedLocation);
        } else if (state.matchedLocation == '/login' ||
            state.matchedLocation == '/register') {
          return '/';
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          name: "detail",
          path: '/detail/:cid',
          pageBuilder: (context, state) {
            Get.delete<LessonController>();
            Get.delete<QuizController>();
            clearData();
            return NoTransitionPage<void>(
              key: UniqueKey(),
              child: CourseDetailsScreen(
                key: UniqueKey(),
                courseId: state.pathParameters['cid'] ?? "",
              ),
            );
          },
        ),
        ShellRoute(
          parentNavigatorKey: rootNavigatorKey,
          navigatorKey: shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            Map<String, dynamic> data = {};
            if (state.extra != null) {
              data = state.extra as Map<String, dynamic>;
            }
            Get.put(QuizController());
            Get.lazyPut(() => LessonController(
                videoId:
                    data['vid'] ?? getSavedObject(StorageKeys.videoId) ?? ""));
            Get.lazyPut(() => SideMenuManager(
                selectedStageId: data['selectedStageId'] ?? "",
                selectedItemKeyUrl: data['selectedKey'] ??
                    getSavedObject(StorageKeys.selectedKey) ??
                    ""));
            return LessonScreen(
              child: child,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: shellNavigatorKey,
              name: "lesson",
              path: '/lesson',
              builder: (BuildContext context, GoRouterState state) {
                return const LessonView();
              },
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'section',
                  path: 'section/:sid',
                  builder: (BuildContext context, GoRouterState state) {
                    var data = {};
                    if (state.extra != null) {
                      data = state.extra as Map<String, dynamic>;
                    }
                    return SectionStart(
                      key: ValueKey(state.pathParameters['sid'] ?? 'sid'),
                      sectionId: state.pathParameters['sid'] ?? "",
                      stageId: data['sid'] ?? "",
                      moduleId: data['mid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                    parentNavigatorKey: shellNavigatorKey,
                    name: 'section-review',
                    path: 'section-review/:sid',
                    builder: (BuildContext context, GoRouterState state) {
                      return SectionReview(
                        sectionid: state.pathParameters['sid'] ?? "",
                      );
                    }),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'section-result',
                  path: 'section-result/:sid',
                  builder: (BuildContext context, GoRouterState state) {
                    return SectionResult(
                      sectionId: state.pathParameters['sid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'section-answer',
                  path: 'section-answer/:sid',
                  builder: (BuildContext context, GoRouterState state) {
                    return SectionAnswerReview(
                      sectionId: state.pathParameters['sid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'module',
                  path: 'module/:mid',
                  builder: (BuildContext context, GoRouterState state) {
                    var data = {};
                    if (state.extra != null) {
                      data = state.extra as Map<String, dynamic>;
                    }
                    return ModuleStart(
                      key: ValueKey(state.pathParameters['mid'] ?? 'mid'),
                      moduleId: (state.pathParameters['mid'] ?? ""),
                      stageId: (data['sid'] ?? ""),
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'module-review',
                  path: 'module-review/:mid',
                  builder: (BuildContext context, GoRouterState state) {
                    return ModuleReview(
                      moduleId: state.pathParameters['mid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'module-result',
                  path: 'module-result/:mid',
                  builder: (BuildContext context, GoRouterState state) {
                    return ModulesResult(
                      moduleId: state.pathParameters['mid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'module-answer',
                  path: 'module-answer/:mid',
                  builder: (BuildContext context, GoRouterState state) {
                    return ModuleAnswerReview(
                      moduleId: state.pathParameters['mid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                    parentNavigatorKey: shellNavigatorKey,
                    name: 'stage-review',
                    path: 'stage-review/:sid',
                    builder: (BuildContext context, GoRouterState state) {
                      return StageReview(
                        stageId: state.pathParameters['sid'] ?? "",
                      );
                    }),
                GoRoute(
                    parentNavigatorKey: shellNavigatorKey,
                    name: 'stage-answer-review',
                    path: 'stage-answer-review/:sid',
                    builder: (BuildContext context, GoRouterState state) {
                      return StageAnswerReview(
                        stageId: state.pathParameters['sid'] ?? "",
                      );
                    }),
                GoRoute(
                    parentNavigatorKey: shellNavigatorKey,
                    name: 'stage-result',
                    path: 'stage-result/:sid',
                    builder: (BuildContext context, GoRouterState state) {
                      return StageResult(
                        stageId: state.pathParameters['sid'] ?? "",
                      );
                    }),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'stage',
                  path: 'stage/:sid',
                  builder: (BuildContext context, GoRouterState state) {
                    return StageStart(
                      key: ValueKey(state.pathParameters['sid'] ?? 'sid'),
                      stageId: state.pathParameters['sid'] ?? "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'mastery',
                  path: 'mastery/:cid',
                  builder: (BuildContext context, GoRouterState state) {
                    return MasteryStart(
                      key: ValueKey(state.pathParameters['cid'] ?? 'cid'),
                      courseId: state.pathParameters['cid'] ??
                          getSavedObject(StorageKeys.courseId) ??
                          "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'mastery-Result',
                  path: 'mastery-Result/:cid',
                  builder: (BuildContext context, GoRouterState state) {
                    return MasteryResult(
                      courseId: state.pathParameters['cid'] ??
                          getSavedObject(StorageKeys.courseId) ??
                          "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  path: 'mastery-assesment_summery',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MasteryAssesmentSummery();
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  name: 'mastery-review',
                  path: 'mastery-review/:cid',
                  builder: (BuildContext context, GoRouterState state) {
                    return MasteryReview(
                      courseId: state.pathParameters['cid'] ??
                          getSavedObject(StorageKeys.courseId) ??
                          "",
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: shellNavigatorKey,
                  path: 'answer-summery',
                  builder: (BuildContext context, GoRouterState state) {
                    Map<String, dynamic> data =
                        state.extra as Map<String, dynamic>;
                    return AnswerSummaryPage(
                      quizId: data['quiz_id'],
                      title: data['quiz_title'],
                      quizIndex: data['quiz_index'],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/certificate',
          builder: (BuildContext context, GoRouterState state) {
            return const MasteryViewCertificate();
          },
        ),
        GoRoute(
          path: '/evaluation-survey',
          builder: (BuildContext context, GoRouterState state) {
            return EvaluationSurvey();
          },
        ),
        GoRoute(
          path: '/mobile-search',
          builder: (BuildContext context, GoRouterState state) {
            return MobileSearch();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: '/forgot',
          builder: (BuildContext context, GoRouterState state) {
            return ForgotPassword();
          },
        ),
        GoRoute(
          name: 'otp',
          path: '/otp',
          builder: (BuildContext context, GoRouterState state) {
            return OTP();
          },
        ),
        GoRoute(
          name: 'newpassword',
          path: '/newpassword',
          builder: (BuildContext context, GoRouterState state) {
            return NewPassword();
          },
        ),
        GoRoute(
          path: '/contactus',
          builder: (BuildContext context, GoRouterState state) {
            return const ContactUs();
          },
        ),
        GoRoute(
          path: '/aboutus',
          builder: (BuildContext context, GoRouterState state) {
            return AboutUs();
          },
        ),
        GoRoute(
          path: '/terms',
          builder: (BuildContext context, GoRouterState state) {
            return const TermsAndCondition();
          },
        ),
        GoRoute(
          path: '/privacy',
          builder: (BuildContext context, GoRouterState state) {
            return PrivacyPolicy();
          },
        ),
        GoRoute(
          path: '/faq',
          builder: (BuildContext context, GoRouterState state) {
            return const Faq();
          },
        ),
        GoRoute(
          path: '/contributors',
          builder: (BuildContext context, GoRouterState state) {
            return const Contributors();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: '/viewCertificate/:cid',
          builder: (BuildContext context, GoRouterState state) {
            var data = {};
            if (state.extra != null && state.extra is Map) {
              data = state.extra as Map<String, dynamic>;
            }
            return RestorationScope(
              restorationId: 'viewcertifcate_screen',
              child: ViewCertificates(
                courseId: state.pathParameters['cid'] ?? "",
                courseName: data['courseName'] ?? "",
              ),
            );
          },
        ),
        GoRoute(
          path: '/404',
          builder: (BuildContext context, GoRouterState state) {
            Map<String, dynamic> data = {};
            if (state.extra is Map<String, dynamic>) {
              data = state.extra as Map<String, dynamic>;
            }
            return ErrorScreen(
              api: data['api'],
              method: data['method'],
            );
          },
        ),
        GoRoute(
          path: '/maintenance',
          builder: (BuildContext context, GoRouterState state) {
            return const Maintenance();
          },
        ),
        GoRoute(
          path: '/500',
          builder: (BuildContext context, GoRouterState state) {
            return const Serverdown();
          },
        ),
      ],
      errorBuilder: (context, state) {
        String token = getSavedObject('token') ?? "";
        if (state.matchedLocation.contains("minified") && token.isNotEmpty) {
          return const HomePage();
        }
        return const ErrorScreen();
      },
    );
  }

  static clearStackAndNavigate(String path) {
    final router = GoRouter.of(rootNavigatorKey.currentContext!);
    router.routeInformationParser.configuration
        .findMatch(Uri.parse(path))
        .matches
        .clear();
    while (rootNavigatorKey.currentContext!.canPop()) {
      rootNavigatorKey.currentContext?.pop();
    }
    rootNavigatorKey.currentContext!.go(path);
  }
}
