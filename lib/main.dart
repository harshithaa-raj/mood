import 'package:flutter/material.dart';
import 'package:flutter_mood/pages/home_page.dart';
import 'package:flutter_mood/pages/login_page.dart';
import 'package:flutter_mood/utils/routes.dart';

void main(){
  runApp(MoodTracker());
}

class MoodTracker extends StatelessWidget {
  

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
      initialRoute: MyRoutes.homeRoute,
      routes: {
        "/":(context)=>LoginPage(),
        MyRoutes.homeRoute:(context)=> Homepage(),
        MyRoutes.loginRoute:(context)=>LoginPage(),

    },
      );
    
  }
}

