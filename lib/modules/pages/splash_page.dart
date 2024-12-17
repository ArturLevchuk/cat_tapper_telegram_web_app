import 'package:cat_tapper_telegram_web_app/constants/routes.dart';
import 'package:cat_tapper_telegram_web_app/modules/vms/account_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        GetIt.I.get<AccountController>().init().then(
          (value) {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                context.go(RoutesDirs.home);
              },
            );
          },
        );
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: FractionallySizedBox(
                heightFactor: .4,
                child: Image.asset("assets/images/loading-cat.gif"),
              ),
            ),
            SizedBox(height: 10),
            const Text(
              "Loading...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
