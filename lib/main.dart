import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/locator/locator.dart';
import 'package:flutter_demo_structure/generated/l10n.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/theme.dart';
import 'package:flutter_demo_structure/widget/custom_error_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      ///- WidgetFlutterBinding is used to interact with the Flutter engine.
      await setupLocator();
      await locator.isReady<AppDB>();

      /// Disable debugPrint logs in production
      if (kReleaseMode) {
        ///- this is a constant that is true if the application was compiled in Dart with the 'dart.vm.product' flag.
        debugPrint = (String? message, {int? wrapWidth}) {};
      }

      // initialize firebase app
      //await Firebase.initializeApp();

      // set error builder widget
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return CustomErrorWidget(errorDetails: errorDetails);
      };

      ///- handle red errors

      // Fixing App Orientation.
      ///- lock the app orientation.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).then((value) => runApp(
              // DevicePreview(
              // builder: (BuildContext context) =>
              MyApp(appRouter: locator<AppRouter>()))
          // ),
          );
    },
    (error, stack) => (Object error, StackTrace stackTrace) {
      if (!kReleaseMode) {
        debugPrint('[Error]: $error');
        debugPrint('[Stacktrace]: $stackTrace');
      }
    },
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({required this.appRouter, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 830),
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp.router(
        theme: appTheme,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, child) {
          child = ScrollConfiguration(
            ///- add scroll glow
            behavior: MyBehavior(),
            child: child!,
          );
          child = MediaQuery(
            child: child,
            data: MediaQuery.of(context)

                ///-set font size
                .copyWith(textScaler: TextScaler.linear(1.0), boldText: false),
          );
          return child;
        },
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        onGenerateTitle: (context) => S.of(context).applicationTitle,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
