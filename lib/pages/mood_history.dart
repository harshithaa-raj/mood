import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class MoodHistoryPage extends StatefulWidget {
  final Map<String, List<Map<String, String>>> moodHistory;

  MoodHistoryPage({required this.moodHistory});

  @override
  _MoodHistoryPageState createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  final List<String> moods = ['Angry', 'Sad', 'Neutral', 'Happy', 'Calm'];
  List<String> savedMoods = [];
  String dominantMood = 'Neutral';
  DateTime selectedDate = DateTime.now();
  bool showCalendar = false; // Toggle calendar visibility

  @override
  void initState() {
    super.initState();
    loadMoodHistory();
  }

  Future<void> loadMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? moodHistoryString = prefs.getString('moodHistory');
    if (moodHistoryString != null) {
      Map<String, dynamic> decodedMoodHistory = jsonDecode(moodHistoryString);
      setState(() {
        savedMoods.clear();
        decodedMoodHistory.forEach((key, value) {
          for (var moodEntry in value) {
            savedMoods.add('${moodEntry['mood']} at $key');
          }
        });
        dominantMood = getDominantMood();
      });
    }
  }

  Future<void> saveMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String moodHistoryString = jsonEncode(widget.moodHistory);
    await prefs.setString('moodHistory', moodHistoryString);
  }

  void addNewMood(String mood) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    widget.moodHistory.putIfAbsent(currentDate, () => []);
    widget.moodHistory[currentDate]!.add({'mood': mood});

    saveMoodHistory();

    setState(() {
      savedMoods.add('$mood at $currentDate');
      dominantMood = getDominantMood();
    });
  }

  void deleteMood(String moodEntry) {
    String dateKey = moodEntry.split(' at ')[1];
    String mood = moodEntry.split(' at ')[0];

    // Remove the mood entry from the moodHistory
    widget.moodHistory[dateKey]?.removeWhere((entry) => entry['mood'] == mood);
    
    // Save updated mood history
    saveMoodHistory();

    // Remove from savedMoods
    setState(() {
      savedMoods.remove(moodEntry);
      dominantMood = getDominantMood();
    });
  }

  Map<String, int> getMoodCounts() {
    Map<String, int> moodCounts = {};
    for (var moodEntry in savedMoods) {
      String mood = moodEntry.split(' at ')[0];
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    }
    return moodCounts;
  }

  String getDominantMood() {
    Map<String, int> moodCounts = getMoodCounts();
    String dominant = moods[0];
    int maxCount = 0;

    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominant = mood;
      }
    });

    return dominant;
  }

  String getMoodForDate(DateTime date) {
    String dateKey = DateFormat('yyyy-MM-dd').format(date);
    if (widget.moodHistory.containsKey(dateKey)) {
      var moodsOnDate = widget.moodHistory[dateKey]!;
      return moodsOnDate.map((entry) => entry['mood']).join(', ');
    }
    return 'No mood recorded';
  }

  List<BarChartGroupData> getBarGroups() {
    Map<String, int> moodCounts = getMoodCounts();
    return moods.map((mood) {
      return BarChartGroupData(
        x: moods.indexOf(mood),
        barRods: [
          BarChartRodData(
            toY: moodCounts[mood]?.toDouble() ?? 0,
            color: getMoodColor(mood),
            width: 20,
            borderRadius: BorderRadius.circular(10),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 10,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
      );
    }).toList();
  }

  Color getMoodColor(String mood) {
    switch (mood) {
      case 'Angry':
        return Colors.red;
      case 'Sad':
        return Colors.blue;
      case 'Neutral':
        return Colors.grey;
      case 'Happy':
        return Colors.green;
      case 'Calm':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = getBarGroups();
    String motivation = getMotivationMessage(dominantMood);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood History'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                showCalendar = !showCalendar; // Toggle calendar visibility
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 222, 152, 235),
              const Color.fromARGB(255, 135, 175, 245)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Your Dominant Mood: $dominantMood',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                motivation,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70),
              ),
            ),
            SizedBox(height: 20),
            Text('Mood Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          getTitlesWidget: (value, meta) {
                            return Text(
                              moods[value.toInt()],
                              style: TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)),
                    gridData: FlGridData(show: false),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        tooltipRoundedRadius: 10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${moods[group.x]}: ${rod.toY.round()}',
                            TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  swapAnimationDuration: Duration(milliseconds: 300),
                ),
              ),
            ),
            if (showCalendar) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select a Date to Check Mood:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              TableCalendar(
                firstDay: DateTime.now().subtract(Duration(days: 30)),
                lastDay: DateTime.now(),
                focusedDay: selectedDate,
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                  });

                  String moodForSelectedDate = getMoodForDate(selectedDay);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Mood on ${DateFormat('yyyy-MM-dd').format(selectedDay)}'),
                      content: Text(moodForSelectedDate),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    color: Colors.red[200],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: savedMoods.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      savedMoods[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteMood(savedMoods[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getMotivationMessage(String mood) {
    switch (mood) {
      case 'Angry':
        return 'Take a deep breath and let it go!';
      case 'Sad':
        return 'It’s okay to feel sad sometimes.';
      case 'Neutral':
        return 'Every day is a new beginning.';
      case 'Happy':
        return 'Keep smiling and spread positivity!';
      case 'Calm':
        return 'Stay grounded and keep your peace.';
      default:
        return '';
    }
  }
}
