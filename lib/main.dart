import 'package:flutter/material.dart';
import 'package:flutter_mood/pages/home_page.dart';
import 'package:flutter_mood/pages/login_page.dart';
import 'package:flutter_mood/pages/mood_history.dart';
import 'package:flutter_mood/pages/note_page.dart';
import 'package:flutter_mood/utils/routes.dart';

void main(){
  runApp(MoodTracker());
}

class MoodTracker extends StatelessWidget {
  Map<String, List<Map<String, String>>> moodHistory = {}; 
  

  
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      
      themeMode:ThemeMode.light,
      theme:ThemeData(
        primarySwatch:Colors.deepPurple,
       ),
      darkTheme:ThemeData(
        brightness:Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.loginRoute,
      routes: {
        "/":(context)=>LoginPage(),
        MyRoutes.homeRoute:(context)=> Homepage(),
        MyRoutes.loginRoute:(context)=>LoginPage(),
        MyRoutes.NotesPage:(context)=>NotesPage(),
        MyRoutes.moodhistoryroute:(context)=>MoodHistoryPage(moodHistory: moodHistory),
       
        
        },
      );
    
  }
}