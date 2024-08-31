import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:astepup_website/Controller/MaintenanceController.dart';
import 'package:astepup_website/Utils/CustomScrollBehavior.dart';
import 'package:astepup_website/routes/AppRouter.dart';

import 'Resource/Strings.dart';
import 'Resource/colors.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
const dsn = 'sentry_url';
Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    setUrlStrategy(NoHistoryUrlStrategy());
    GoRouter.optionURLReflectsImperativeAPIs = true;
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
      },
    );
    runApp(MyApp(currentPath: getPath(Uri.base)));
  }, (exception, stackTrace) async {
    debugPrint(exception.toString());
  });
}

class MyApp extends StatefulWidget {
  final String currentPath;
  const MyApp({
    super.key,
    required this.currentPath,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter appRouter;
  @override
  void initState() {
    super.initState();
    appRouter = AppRouter(initialPath: widget.currentPath);
    Get.lazyPut(() => MaintenanceController(), fenix: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      themeAnimationCurve: Curves.easeInOutCubic,
      routeInformationProvider: appRouter.goRouter.routeInformationProvider,
      routeInformationParser: appRouter.goRouter.routeInformationParser,
      routerDelegate: appRouter.goRouter.routerDelegate,
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: Strings.appname,
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBG,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)))),
        appBarTheme: const AppBarTheme(backgroundColor: colorPrimary),
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrimary),
        useMaterial3: true,
      ),
    );
  }
}

class NoHistoryUrlStrategy extends PathUrlStrategy {
  //?to disable browser navigation uncomment this code
  // @override
  // void pushState(Object? state, String title, String url) =>
  //     replaceState(state, title, url);
}

String getPath(Uri uri, {String? basePath}) {
  String path = uri.path;
  if (basePath != null && path.startsWith(basePath)) {
    path = path.substring(basePath.length);
  }
  path = path.replaceFirst(RegExp(r'^/'), '');
  path = '/$path'.replaceAll(RegExp(r'/$'), '');
  return path.isNotEmpty ? path : '/';

  //?old base path return fucntion
  // String path = uri.path;
  // if (basePath != null && path.startsWith(basePath)) {
  //   print('test1');
  //   path = path.substring(basePath.length);
  //   path = path.replaceAll(RegExp(r'/$'), '');
  //   return path.isNotEmpty ? path : '/';
  // }
  // if (validRoutes.contains(path)) {
  //   print('test2');
  //   path = uri.pathSegments.join('/');
  //   path = '/$path';
  //   path = path.replaceAll(RegExp(r'/$'), '');
  //   return path.isNotEmpty ? path : '/';
  // }
  // if (uri.pathSegments.isNotEmpty) {
  //   print(uri.pathSegments);
  //   if (validRoutes.contains(uri.pathSegments)) {
  //     print('test3');
  //   }
  //   path = '/${uri.pathSegments.skip(1).join('/')}';
  //   path = path.replaceAll(RegExp(r'/$'), '');
  //   return path.isNotEmpty ? path : '/';
  // }
  // if (!path.startsWith('/')) {
  //   print('test4');
  //   path = '/$path';
  //   path = path.replaceAll(RegExp(r'/$'), '');
  //   return path.isNotEmpty ? path : '/';
  // }
  // return '/';
}
