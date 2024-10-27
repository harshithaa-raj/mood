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
        title: Center(child: Text('Mood Tracker')),
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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit the height to 80% of the screen
          ),
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView( // Make it scrollable
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
                  _buildTextField('What triggered your mood?', (value) => moodTrigger = value),
                  SizedBox(height: 10),
                  _buildTextField('Sleep Quality (1-10)', (value) => sleepQuality = value, keyboardType: TextInputType.number),
                  SizedBox(height: 10),
                  _buildTextField('Did you exercise today?', (value) => exercise = value),
                  SizedBox(height: 10),
                  _buildTextField('Any significant events?', (value) => significantEvents = value),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateInputs()) {
                        _showConfirmationDialog(context);
                      } else {
                        _showErrorDialog(context);
                      }
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
        ),
      );
    },
  );
}


  // New helper method for building text fields
  Widget _buildTextField(String hint, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
      keyboardType: keyboardType,
    );
  }

  // Validation method for input fields
  bool _validateInputs() {
    if (moodTrigger.isEmpty || sleepQuality.isEmpty || exercise.isEmpty || significantEvents.isEmpty) {
      return false; // Ensure all fields are filled
    }
    int? sleepQualityValue = int.tryParse(sleepQuality);
    if (sleepQualityValue == null || sleepQualityValue < 1 || sleepQualityValue > 10) {
      return false; // Ensure sleep quality is between 1 and 10
    }
    return true; // All validations passed
  }

  // Show confirmation dialog before saving
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Mood Recording'),
          content: Text('Are you sure you want to record this mood?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                recordMood(selectedMood, selectedEmoji, moodTrigger, sleepQuality, exercise, significantEvents);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close mood dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Show error dialog for input validation
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields correctly.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MoodPainter extends CustomPainter {
  final Map<String, dynamic> mood;

  MoodPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    // Use a Paint object to set styles
    final paint = Paint()
      ..color = mood['color']
      ..style = PaintingStyle.fill;

    // Example of drawing a circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

    // Drawing the emoji as text
    final textPainter = TextPainter(
      text: TextSpan(
        text: mood['emoji'],
        style: TextStyle(fontSize: 60, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();
    
    // Calculate the position to center the text
    double textX = (size.width - textPainter.width) / 2;
    double textY = (size.height - textPainter.height) / 2;

    // Draw the text
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
