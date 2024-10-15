import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  final String name='MoodTracker';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('MoodTracker'),),
      body:Center(
        child:Container(
          child:Text("Welocome to $name"),
        ),
      ),
      drawer:Drawer(),
      );
  }
}