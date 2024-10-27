import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, String>> notes = [];
  int streakCount = 0;
  DateTime? lastMoodDate;

  @override
  void initState() {
    super.initState();
    loadNotes();
    loadMoodDate();
    calculateStreak();
  }

  // Load notes and mood date
  Future<void> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedNotes = prefs.getStringList('notes');
    if (savedNotes != null) {
      notes = savedNotes.map((e) {
        final parts = e.split('::');
        return {'content': parts[0], 'linkedMood': parts[1]};
      }).toList();
    }
    setState(() {});
  }

  Future<void> saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedNotes = notes.map((e) {
      return '${e['content']}::${e['linkedMood']}';
    }).toList();
    await prefs.setStringList('notes', savedNotes);
  }

  Future<void> loadMoodDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDateStr = prefs.getString('lastMoodDate');
    if (lastDateStr != null) {
      lastMoodDate = DateTime.parse(lastDateStr);
    }
  }

  Future<void> saveMoodDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMoodDate', date.toIso8601String());
  }

  void calculateStreak() {
    if (lastMoodDate != null) {
      DateTime now = DateTime.now();
      if (lastMoodDate!.day == now.day &&
          lastMoodDate!.month == now.month &&
          lastMoodDate!.year == now.year) {
        streakCount = 0;
      } else {
        int streak = 0;
        DateTime currentDate = lastMoodDate!;
        while (currentDate.isBefore(now) || currentDate.isAtSameMomentAs(now)) {
          streak++;
          currentDate = currentDate.add(Duration(days: 1));
        }
        streakCount = streak;
      }
    }
  }

  void addNote() {
    String noteContent = '';
    String linkedMood = 'Happy'; // Default mood

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      noteContent = value; // Capture the input
                    },
                    decoration: InputDecoration(labelText: 'Note'),
                  ),
                  DropdownButton<String>(
                    value: linkedMood,
                    items: ['Angry', 'Sad', 'Neutral', 'Happy', 'Calm']
                        .map((String mood) => DropdownMenuItem<String>(
                              value: mood,
                              child: Text(mood),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        linkedMood = newValue!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (noteContent.isNotEmpty) {
                  setState(() {
                    notes.add({'content': noteContent, 'linkedMood': linkedMood});
                  });
                  saveNotes();
                  DateTime now = DateTime.now();
                  saveMoodDate(now);
                  calculateStreak();
                  Navigator.of(context).pop();
                } else {
                  print("Note content is empty.");
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void editNote(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String noteContent = notes[index]['content']!;
        String linkedMood = notes[index]['linkedMood']!;
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  noteContent = value;
                },
                decoration: InputDecoration(labelText: 'Note'),
                controller: TextEditingController(text: noteContent),
              ),
              DropdownButton<String>(
                value: linkedMood,
                items: ['Angry', 'Sad', 'Neutral', 'Happy', 'Calm']
                    .map((String mood) => DropdownMenuItem<String>(
                          value: mood,
                          child: Text(mood),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    linkedMood = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                notes[index] = {'content': noteContent, 'linkedMood': linkedMood};
                saveNotes();
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    saveNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: const Color.fromARGB(255, 196, 150, 227),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Current Streak: $streakCount days'),
              ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 128, 229),
              ),
              child: Text(
                'Mood Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, "/home"); // Navigate to Home
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Notes'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, "/notepage"); // Navigate to Notes page
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Stats'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, "/moodhistory"); // Navigate to Stats page
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/'); // Handle logout
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, "/Settingspage");
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 155, 219, 242), const Color.fromARGB(255, 238, 138, 195)],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Streak: $streakCount days',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addNote,
              child: Text('Add Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[50],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.note, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'No notes yet! Tap the button to add some.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.pink[50],
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(notes[index]['content']!),
                            subtitle: Text('Mood: ${notes[index]['linkedMood']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => editNote(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => deleteNote(index),
                                ),
                              ],
                            ),
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
}
