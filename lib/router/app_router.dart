import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/views/screens/error_page.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/views/screens/group_timer/group_timer_page.dart';
import 'package:pomodak/views/screens/login/login_page.dart';
import 'package:pomodak/views/screens/main/main_page.dart';
import 'package:pomodak/views/screens/splash_page.dart';
import 'package:pomodak/views/screens/register/register_page.dart';
import 'package:pomodak/views/screens/timer/timer_page.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';
import 'package:pomodak/views/screens/welcome_page.dart';

class AppRouter {
  final AppViewModel appViewModel;
  final AuthViewModel authViewModel;
  late final GoRouter _goRouter;

  AppRouter({required this.appViewModel, required this.authViewModel}) {
    _goRouter = _initGoRouter();
  }

  GoRouter get router => _goRouter;

  GoRouter _initGoRouter() {
    return GoRouter(
      refreshListenable: Listenable.merge([appViewModel, authViewModel]),
      initialLocation: AppPage.splash.toPath,
      routes: _getRoutes(),
      errorBuilder: (context, state) =>
          ErrorPage(error: state.error.toString()),
      redirect: _redirectLogic,
    );
  }

  List<GoRoute> _getRoutes() {
    return [
      GoRoute(
        path: AppPage.home.toPath,
        name: AppPage.home.toName,
        builder: (context, state) => const MyHomePage(),
      ),
      GoRoute(
        path: AppPage.timer.toPath,
        name: AppPage.timer.toName,
        builder: (context, state) => const TimerPage(),
      ),
      GoRoute(
        path: AppPage.groupTimer.toPath,
        name: AppPage.groupTimer.toName,
        builder: (context, state) => const GroupTimerPage(),
      ),
      GoRoute(
        path: AppPage.timerAlarm.toPath,
        name: AppPage.timerAlarm.toName,
        builder: (context, state) => const TimerAlarmPage(),
      ),
      GoRoute(
        path: AppPage.splash.toPath,
        name: AppPage.splash.toName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPage.welcome.toPath,
        name: AppPage.welcome.toName,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppPage.login.toPath,
        name: AppPage.login.toName,
        builder: (context, state) => const LogInPage(),
      ),
      GoRoute(
        path: AppPage.register.toPath,
        name: AppPage.register.toName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppPage.error.toPath,
        name: AppPage.error.toName,
        builder: (context, state) => ErrorPage(error: state.extra.toString()),
      ),
    ];
  }

  String? _redirectLogic(BuildContext context, GoRouterState state) {
    final isLoggedIn = authViewModel.isLoggedIn;
    final isInitialized = appViewModel.initialized;

    final locations = {
      'welcome': state.namedLocation(AppPage.welcome.toName),
      'login': state.namedLocation(AppPage.login.toName),
      'register': state.namedLocation(AppPage.register.toName),
      'home': state.namedLocation(AppPage.home.toName),
      'timer': state.namedLocation(AppPage.timer.toName),
      'timerAlarm': state.namedLocation(AppPage.timerAlarm.toName),
      'splash': state.namedLocation(AppPage.splash.toName),
    };

    if (!isInitialized && state.matchedLocation != locations['splash']) {
      return locations['splash'];
    }

    if (isInitialized &&
        !isLoggedIn &&
        state.matchedLocation != locations['welcome'] &&
        (state.matchedLocation == locations['home'] ||
            state.matchedLocation == locations['timer'] ||
            state.matchedLocation == locations['timerAlarm'])) {
      return locations['welcome'];
    }

    if ((isLoggedIn &&
            (state.matchedLocation == locations['login'] ||
                state.matchedLocation == locations['welcome'] ||
                state.matchedLocation == locations['register'])) ||
        (isInitialized && state.matchedLocation == locations['splash'])) {
      return locations['home'];
    }

    return null;
  }
}
