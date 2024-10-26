import 'package:flutter/material.dart';
import 'package:flutter_mood/pages/mood_history.dart';
import 'package:flutter_mood/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: Homepage()));
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, List<Map<String, String>>> moodHistory = {};

  @override
  void initState() {
    super.initState();
    loadMoodHistory(); // Load the mood history when the app starts
  }

  Future<void> loadMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? moodHistoryString = prefs.getString('moodHistory');

    if (moodHistoryString != null) {
      setState(() {
        moodHistory = (jsonDecode(moodHistoryString) as Map<String, dynamic>).map((key, value) {
          return MapEntry(key, List<Map<String, String>>.from(value));
        });
      });
    }
  }

  String selectedMood = '';
  String selectedEmoji = '';
  Color selectedColor = Colors.white; // Default background color

  // Add fields for additional context
  String moodTrigger = '';
  String sleepQuality = '';
  String exercise = '';
  String significantEvents = '';

  final List<Map<String, dynamic>> moods = [
    {'mood': 'Angry', 'emoji': '😠', 'color': Colors.pinkAccent.shade100},
    {'mood': 'Sad', 'emoji': '😢', 'color': Colors.lightBlue.shade100},
    {'mood': 'Neutral', 'emoji': '😐', 'color': Colors.purple.shade100},
    {'mood': 'Happy', 'emoji': '😊', 'color': Colors.yellow.shade300},
    {'mood': 'Calm', 'emoji': '😌', 'color': Colors.greenAccent.shade100},
  ];

  // Add a list of quotes
  final List<String> quotes = [
    "Keep your face always toward the sunshine—and shadows will fall behind you.",
    "The only way to do great work is to love what you do.",
    "You are never too old to set another goal or to dream a new dream.",
  ];

  String get randomQuote {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % quotes.length;
    return quotes[randomIndex];
  }

  void recordMood(String mood, String emoji, String trigger, String sleepQuality, String exercise, String events) async {
    String today = DateTime.now().toLocal().toString().split(' ')[0]; // Get today's date
    if (!moodHistory.containsKey(today)) {
      moodHistory[today] = []; // Initialize list for today if it doesn't exist
    }
    moodHistory[today]!.add({
      'mood': mood,
      'emoji': emoji,
      'trigger': trigger,
      'sleepQuality': sleepQuality,
      'exercise': exercise,
      'significantEvents': events,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('moodHistory', jsonEncode(moodHistory));
  }

  void navigateToMoodHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodHistoryPage(moodHistory: moodHistory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mood Tracker')
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: moods.map((mood) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood['mood'];
                        selectedEmoji = mood['emoji'];
                        selectedColor = mood['color'];
                      });
                      showMoodFullScreen(context);
                    },
                    child: CustomPaint(
                      size: Size(120, 120),
                      painter: MoodPainter(mood: mood),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '"${randomQuote}"',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToMoodHistory,
                child: Text('View Mood History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerPage(),
    );
  }

  void showMoodFullScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: selectedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedEmoji,
                    style: TextStyle(fontSize: 150),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'I am feeling $selectedMood',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // New input fields for additional context
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'What triggered your mood?',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      moodTrigger = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Sleep Quality (1-10)',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      sleepQuality = value;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Did you exercise today?',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      exercise = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Any significant events?',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      significantEvents = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      recordMood(selectedMood, selectedEmoji, moodTrigger, sleepQuality, exercise, significantEvents); // Record mood and context
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Record Mood'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MoodPainter extends CustomPainter {
  final Map<String, dynamic> mood;

  MoodPainter({required this.mood}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 60;
    Paint circlePaint = Paint()
      ..color = mood['color']
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, circlePaint);

    TextSpan emojiSpan = TextSpan(
      style: TextStyle(fontSize: 30, color: Colors.black),
      text: mood['emoji'],
    );
    TextPainter emojiTp = TextPainter(
      text: emojiSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    emojiTp.layout();
    emojiTp.paint(canvas, Offset(size.width / 2 - emojiTp.width / 2, size.height / 2 - emojiTp.height / 2));

    TextSpan moodSpan = TextSpan(
      style: TextStyle(fontSize: 18, color: Colors.black),
      text: mood['mood'],
    );
    TextPainter moodTp = TextPainter(
      text: moodSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    moodTp.layout();
    moodTp.paint(canvas, Offset(size.width / 2 - moodTp.width / 2, size.height / 2 + emojiTp.height / 2 + 8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
