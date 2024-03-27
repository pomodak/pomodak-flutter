enum AppPage { splash, login, home, error }

extension AppPageExtension on AppPage {
  String get toPath {
    switch (this) {
      case AppPage.home:
        return "/";
      case AppPage.login:
        return "/login";
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
      case AppPage.login:
        return "LOGIN";
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
