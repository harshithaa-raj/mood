import 'package:flutter/material.dart';
import 'package:flutter_mood/pages/editprofile_page.dart';
import 'package:flutter_mood/pages/home_page.dart';
import 'package:flutter_mood/pages/login_page.dart';
import 'package:flutter_mood/pages/mood_history.dart';
import 'package:flutter_mood/pages/note_page.dart';
import 'package:flutter_mood/pages/registration_page.dart';  // Import RegistrationPage
import 'package:flutter_mood/pages/setting_page.dart';
import 'package:flutter_mood/utils/routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MoodTracker());
}

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  bool _isDarkMode = false;
  bool _isLoggedIn = true;
  Map<String, List<Map<String, String>>> moodHistory = {};

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); 
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false; 
    });
  }

  void _login() {
    setState(() {
      _isLoggedIn = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.loginRoute,
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => Homepage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.registrationPage: (context) => RegistrationPage(), // Register the route for RegistrationPage
        MyRoutes.NotesPage: (context) => NotesPage(),
        MyRoutes.moodhistoryroute: (context) => MoodHistoryPage(moodHistory: moodHistory),
        MyRoutes.SettingsPage: (context) => SettingsPage(onThemeChanged: _toggleTheme, isDarkMode: _isDarkMode),
        MyRoutes.EditProfilePage: (context) => EditProfilePage(),
      },
    );
  }
}
