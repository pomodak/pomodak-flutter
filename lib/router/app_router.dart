import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/screens/error_page.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/views/screens/login_page.dart';
import 'package:pomodak/screens/main_page.dart';
import 'package:pomodak/screens/splash_page.dart';

class AppRouter {
  late final AppViewModel appViewModel;
  late final AuthViewModel authViewModel;
  GoRouter get router => _goRouter;

  AppRouter(this.appViewModel, this.authViewModel);

  late final GoRouter _goRouter = GoRouter(
    // 앱의 로그인 상태와 초기화 상태 변경을 리스닝하여 리프레시
    refreshListenable: Listenable.merge([appViewModel, authViewModel]),
    // 초기 페이지
    initialLocation: AppPage.home.toPath,
    // 앱의 모든 라우트
    routes: <GoRoute>[
      GoRoute(
        path: AppPage.home.toPath,
        name: AppPage.home.toName,
        builder: (context, state) => const MyHomePage(),
      ),
      GoRoute(
        path: AppPage.splash.toPath,
        name: AppPage.splash.toName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPage.login.toPath,
        name: AppPage.login.toName,
        builder: (context, state) => const LogInPage(),
      ),
      GoRoute(
        path: AppPage.error.toPath,
        name: AppPage.error.toName,
        builder: (context, state) => ErrorPage(error: state.extra.toString()),
      ),
    ],
    // 에러 발생 시
    errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    // 앱의 상태에 따라 적절한 페이지로 리다이렉팅
    redirect: (_, state) {
      // 전체 라우트 파악
      final loginLocation = state.namedLocation(AppPage.login.toName);
      final homeLocation = state.namedLocation(AppPage.home.toName);
      final splashLocation = state.namedLocation(AppPage.splash.toName);

      final isLogedIn = authViewModel.isLoggedIn; // 로그인 상태
      final isInitialized = appViewModel.initialized; // 초기화 상태

      // 이동중인 라우트 파악
      final isGoingToLogin = state.matchedLocation == loginLocation;
      final isGoingToInit = state.matchedLocation == splashLocation;

      // 앱이 아직 초기화되지 않았고 스플래시 페이지로 가지 않는 경우, 스플래시 페이지
      if (!isInitialized && !isGoingToInit) {
        return splashLocation;
      }
      // 앱이 초기화되었지만 사용자가 로그인하지 않았고 로그인 페이지로 가지 않는 경우, 로그인 페이지
      else if (isInitialized && !isLogedIn && !isGoingToLogin) {
        return loginLocation;
      }
      // 사용자가 로그인한 상태에서 로그인 페이지로 가려고 하거나,
      // 앱이 이미 초기화된 상태에서 스플래시 페이지로 가려고 하는 경우, 홈 페이지
      else if ((isLogedIn && isGoingToLogin) ||
          (isInitialized && isGoingToInit)) {
        return homeLocation;
      } else {
        return null;
      }
    },
  );
}
