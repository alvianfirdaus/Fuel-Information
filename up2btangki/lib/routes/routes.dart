import 'package:flutter/material.dart';
import 'package:up2btangki/pages/splashscreen.dart';
import 'package:up2btangki/pages/dashboard.dart';


class Routes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    dashboard: (context) => DashboardPage(),
    // settings: (context) => SettingsPage(),
  };
}