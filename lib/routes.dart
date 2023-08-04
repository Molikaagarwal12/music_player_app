import 'package:flutter/material.dart';
import 'package:music_player/Screens/login_screen.dart';
import 'package:music_player/Screens/search_screen.dart';
import 'package:music_player/Screens/signup_screen.dart';

import 'Screens/home_screen.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
static const String search = '/search';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) =>  const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) =>  const SignupScreen());
      case home:
        return MaterialPageRoute(builder: (_) =>  const MyHomePage());
      case search:
        return MaterialPageRoute(builder: (_) =>  const SearchScreen());
    }
    return null;
  }
}
