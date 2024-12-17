import 'package:cat_tapper_telegram_web_app/constants/routes.dart';
import 'package:cat_tapper_telegram_web_app/modules/pages/init_page.dart';
import 'package:cat_tapper_telegram_web_app/modules/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
Uri? initUrl = Uri.base;

final goRouter = GoRouter(
  initialLocation: initUrl?.path,
  navigatorKey: navigatorKey,
  routerNeglect: true,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    // if (initUrl != null && initUrl!.path != '/') {
    //   initUrl = null;
    //   return '/';
    // }
    if (initUrl != null && initUrl!.fragment != '') {
      initUrl = null;
      return '/';
    }
    return null;
  },
  onException: (context, state, router) {
    context.go('/');
  },
  routes: [
    GoRoute(
      name: "splash",
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    // StatefulShellRoute.indexedStack(
    //   pageBuilder: (context, state, navigationShell) {
    //     return CustomTransitionPage(
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(
    //           opacity: animation,
    //           child: child,
    //         );
    //       },
    //       child: InitPage(
    //         navigationShell: navigationShell,
    //       ),
    //     );
    //   },
    //   branches: [
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           name: "home",
    //           path: RoutesDirs.home,
    //           builder: (context, state) => const CatTapPage(),
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           name: "market",
    //           path: RoutesDirs.market,
    //           builder: (context, state) => const CatMarketPage(),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
    StatefulShellRoute(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "home",
              path: RoutesDirs.home,
              builder: (context, state) => const CatTapPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          preload: true,
          routes: [
            GoRoute(
              name: "market",
              path: RoutesDirs.market,
              builder: (context, state) => const CatMarketPage(),
            ),
          ],
        ),
      ],
      navigatorContainerBuilder: (context, navigationShell, children) {
        return InitPage(
          navigationShell: navigationShell,
          children: children,
        );
      },
      pageBuilder: (context, state, navigationShell) {
        return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: navigationShell,
        );
      },
    )
  ],
);
