import 'dart:async';
import 'dart:developer';

import 'package:cat_tapper_telegram_web_app/config/routes_config.dart';
import 'package:cat_tapper_telegram_web_app/config/setup.dart';
import 'package:cat_tapper_telegram_web_app/exceptions/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';

void main() async {
  // usePathUrlStrategy();
  if (kDebugMode) {
    await setupServices();
    runApp(const AppWidget());
  } else {
    runZonedGuarded(
      () async {
        await setupServices();
        FlutterError.onError = (FlutterErrorDetails details) {
          log(details.exception.toString());
          final catcher = GetIt.I.get<ErrorCatcher>();
          final appException = details.exception is AppExceptions
              ? details.exception as AppExceptions
              : AppExceptions.fromError(details.exception);
          catcher.showDialogForError(appException);
        };
        runApp(const AppWidget());
      },
      (error, stack) async {
        log(error.toString());
        final catcher = GetIt.I.get<ErrorCatcher>();
        final appException =
            error is AppExceptions ? error : AppExceptions.fromError(error);
        catcher.showDialogForError(appException);
      },
    );
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp.router(
    //   title: 'Cat Tapper Telegram Web App',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: const ColorScheme.dark(
    //       brightness: Brightness.dark,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   routerConfig: goRouter,
    // );
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: Size(375, 812),
      builder: (_, __) {
        return MaterialApp.router(
          title: 'Cat Tapper Telegram Web App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          routerConfig: goRouter,
        );
      },
    );
  }
}
