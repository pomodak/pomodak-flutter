enum AppPage {
  splash,
  welcome,
  login,
  register,
  home,
  error,
  timer,
  timerAlarm
}

extension AppPageExtension on AppPage {
  String get toPath {
    switch (this) {
      case AppPage.home:
        return "/";
      case AppPage.welcome:
        return "/welcome";
      case AppPage.login:
        return "/login";
      case AppPage.register:
        return "/register";
      case AppPage.splash:
        return "/splash";
      case AppPage.error:
        return "/error";
      case AppPage.timer:
        return "/timer";
      case AppPage.timerAlarm:
        return "/timer-alarm";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case AppPage.home:
        return "HOME";
      case AppPage.welcome:
        return "WELCOME";
      case AppPage.login:
        return "LOGIN";
      case AppPage.register:
        return "REGISTER";
      case AppPage.splash:
        return "SPLASH";
      case AppPage.error:
        return "ERROR";
      case AppPage.timer:
        return "TIMER";
      case AppPage.timerAlarm:
        return "TIMER_ALARM";
      default:
        return "HOME";
    }
  }
}
