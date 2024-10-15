import 'package:flutter/material.dart';
import 'package:flutter_mood/Home_Page.dart';

void main(){
  runApp(MoodTracker());
}

class MoodTracker extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
   
    return MaterialApp(
      home: Homepage(),
    );
  }
}

