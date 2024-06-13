import 'package:flutter/material.dart';
import '/screens/screens.dart';

import '/models/models.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case UsersScreen.routeName:
        return UsersScreen.route(user: settings.arguments as User);
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case OnboardingScreen.routeName:
        return OnboardingScreen.route();
      case MatchesScreen.routeName:
        return MatchesScreen.route();
      case SettingsScreen.routeName:
        return SettingsScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route(match: settings.arguments as Match);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: const Text('Error'))),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
