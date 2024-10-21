import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class MoodHistoryPage extends StatefulWidget {
  final Map<String, List<Map<String, String>>> moodHistory;

    MoodHistoryPage({required this.moodHistory});



  @override
  _MoodHistoryPageState createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  final List<String> moods = ['Angry', 'Sad', 'Neutral', 'Happy', 'Calm'];
  List<String> savedMoods = [];

  @override
  void initState() {
    super.initState();
    loadMoodHistory();
  }

  // Load mood history from SharedPreferences
  Future<void> loadMoodHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? moodHistoryString = prefs.getString('moodHistory');
  if (moodHistoryString != null) {
    Map<String, dynamic> decodedMoodHistory = jsonDecode(moodHistoryString);
    setState(() {
      savedMoods = [];
      decodedMoodHistory.forEach((key, value) {
        for (var moodEntry in value) {
          savedMoods.add('${moodEntry['mood']} at $key');
        }
      });
    });
  }
}

  // Get mood counts for visualization
  Map<String, int> getMoodCounts() {
    Map<String, int> moodCounts = {};
    for (var moodEntry in savedMoods) {
      String mood = moodEntry.split(' at ')[0]; // Extract mood
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1; // Count occurrences
    }
    return moodCounts;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> moodCounts = getMoodCounts();

    // Prepare the Bar Chart data
    List<BarChartGroupData> barGroups = moods.map((mood) {
      return BarChartGroupData(
        x: moods.indexOf(mood),
        barRods: [
          BarChartRodData(
            toY: moodCounts[mood]?.toDouble() ?? 0, // Use 0 if no data
            color: Colors.blueAccent,
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood History'),
      ),
      body: Column(
        children: [
          Text('Mood Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
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
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedMoods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savedMoods[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
