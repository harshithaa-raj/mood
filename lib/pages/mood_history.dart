import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mood/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodHistoryPage extends StatefulWidget {

  final List<Map<String, String>> moodHistory; // Add this line

  MoodHistoryPage({required this.moodHistory}); // Ensure this constructor accepts moodHistory


  @override
  
  _MoodHistoryPageState createState() => _MoodHistoryPageState();
  
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  List<Map<String, String>> moodHistory = [];
  final List<String> moods = ['Angry', 'Sad', 'Neutral', 'Happy', 'Calm'];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadMoodHistory(); // Load mood history from shared preferences
  }

  // Load mood history from shared preferences
  Future<void> loadMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedMoods = prefs.getStringList('moodHistory');
    if (savedMoods != null) {
      moodHistory = savedMoods.map((e) {
        List<String> parts = e.split('::');
        return {'mood': parts[0], 'timestamp': parts[1]};
      }).toList();
    }
    setState(() {});
  }

  // Save mood history to shared preferences
  Future<void> saveMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMoods = moodHistory.map((e) {
      return '${e['mood']}::${e['timestamp']}';
    }).toList();
    await prefs.setStringList('moodHistory', savedMoods);
  }

  void addMood(String mood) {
    final timestamp = DateTime.now().toString();
    moodHistory.add({'mood': mood, 'timestamp': timestamp});
    saveMoodHistory(); // Save mood after adding
    setState(() {});
  }

  void resetMoodHistory() {
    moodHistory.clear();
    saveMoodHistory(); // Save the empty list
    setState(() {});
  }

  void analyzeMoods() {
    Map<String, int> moodCount = {};
    for (var moodEntry in moodHistory) {
      String mood = moodEntry['mood']!;
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    // Show analysis (for example, in a dialog)
    String analysis = moodCount.entries.map((entry) {
      return '${entry.key}: ${entry.value} times';
    }).join('\n');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mood Analysis for ${selectedDate.toLocal().toString().split(' ')[0]}'),
          content: Text(analysis.isNotEmpty ? analysis : 'No moods recorded.'),
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      // Load mood history for the selected date (if implemented)
      // loadMoodHistoryForDate(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prepare data for the bar chart
    Map<String, int> moodCount = {};
    for (var moodEntry in moodHistory) {
      String mood = moodEntry['mood']!;
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups = moodCount.entries.map((entry) {
      return BarChartGroupData(
        x: moods.indexOf(entry.key), // Mood index
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(), // Count of each mood
            color: Colors.deepPurple, // Bar color
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood History'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: analyzeMoods, // Show mood analysis
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => selectDate(context), // Open date picker
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: resetMoodHistory, // Reset mood history
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          return Text(moods[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                ),
              ),
            ),
           
            
          ],
        ),
      ),
      drawer: DrawerPage(),
    );
  }
}