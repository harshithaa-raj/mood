import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  final String name='MoodTracker';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Mood Tracker'),
        backgroundColor: const Color.fromARGB(255, 255, 77, 222),
        elevation: 5,
        centerTitle: true,),
      body:Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey, ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MoodButton(
                  mood:'HAPPY',
                  color:Colors.yellowAccent,
                  emoji:'😊',
                ),
                MoodButton(
                  mood:'SAD',
                  color:Colors.lightBlueAccent,
                  emoji:'😢',
                ),
                MoodButton(
                  mood:'STRESSED',
                  color:Colors.redAccent,
                  emoji:'😫',
                ),
               

    
              ],
            ),
            
          ],
        ),
       
        ),
      
      drawer:Drawer(),
      );
  }
}

class MoodButton extends StatelessWidget {
  final String mood;
  final String emoji;
  final Color color;

  MoodButton({required this.mood,required this.emoji,required this.color});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: color,
          child: Text(
            emoji,
            style: TextStyle(fontSize: 30),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          mood,
          style: TextStyle(
            fontSize: 16
          ),
        )
      ],
    );
  }
}