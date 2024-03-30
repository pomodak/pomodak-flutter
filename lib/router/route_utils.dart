enum AppPage { splash, welcome, login, register, home, error }

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
      default:
        return "HOME";
    }
  }

  String get toTitle {
    switch (this) {
      case AppPage.home:
        return "My App";
      case AppPage.login:
        return "My App Log In";
      case AppPage.splash:
        return "My App Splash";
      case AppPage.error:
        return "My App Error";
      default:
        return "My App";
    }
  }
}
