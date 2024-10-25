import 'package:flutter/material.dart';
import 'package:flutter_mood/pages/home_page.dart';
import 'package:flutter_mood/pages/login_page.dart';
import 'package:flutter_mood/pages/mood_history.dart';
import 'package:flutter_mood/pages/note_page.dart';
import 'package:flutter_mood/pages/setting_page.dart';
import 'package:flutter_mood/utils/routes.dart';

void main(){
  runApp(MoodTracker());
}

class MoodTracker extends StatefulWidget {
  
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  
  bool _isDarkMode = false;  // Define _isDarkMode here
  Map<String, List<Map<String, String>>> moodHistory = {};


  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
     return MaterialApp( 
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme:ThemeData(
        primarySwatch:Colors.deepPurple,
       ),
      darkTheme:ThemeData(
        brightness:Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.homeRoute,
      routes: {
        "/":(context)=>LoginPage(),
        MyRoutes.homeRoute:(context)=> Homepage(),
        MyRoutes.loginRoute:(context)=>LoginPage(),
        MyRoutes.NotesPage:(context)=>NotesPage(),
        MyRoutes.moodhistoryroute:(context)=> MoodHistoryPage(moodHistory: moodHistory),
        MyRoutes.SettingsPage:(context)=>SettingsPage(
          onThemeChanged: _toggleTheme,
          isDarkMode: _isDarkMode, 
        ), 
        },
      );
    
  }
}