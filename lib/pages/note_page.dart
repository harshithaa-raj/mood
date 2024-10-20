import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mood/widgets/drawer.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, String>> notes = []; // Ensure the map uses String types
  int streakCount = 0;
  DateTime? lastMoodDate;

  @override
  void initState() {
    super.initState();
    loadNotes();
    loadMoodDate();
    calculateStreak();
  }

  Future<void> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedNotes = prefs.getStringList('notes');
    if (savedNotes != null) {
      notes = savedNotes.map((e) {
        final parts = e.split('::');
        return {'content': parts[0], 'linkedMood': parts[1]};
      }).toList().cast<Map<String, String>>(); // Cast to ensure the correct type
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
                    print("Note added: $noteContent, Mood: $linkedMood"); // Debug statement
                  });
                  saveNotes(); // Save notes to SharedPreferences
                  DateTime now = DateTime.now();
                  saveMoodDate(now); // Save the current mood date
                  calculateStreak(); // Update streak
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  print("Note content is empty."); // Debug statement
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
        backgroundColor: const Color.fromARGB(255, 201, 82, 145),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade200, Colors.purple.shade800],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Current Streak: $streakCount days',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: addNote,
              child: Text('Add Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[50], // Button color
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  Color moodColor;
                  switch (notes[index]['linkedMood']) {
                    case 'Angry':
                      moodColor = Colors.red.shade200;
                      break;
                    case 'Sad':
                      moodColor = Colors.blue.shade200;
                      break;
                    case 'Neutral':
                      moodColor = Colors.grey.shade400;
                      break;
                    case 'Happy':
                      moodColor = Colors.yellow.shade200;
                      break;
                    case 'Calm':
                      moodColor = Colors.green.shade200;
                      break;
                    default:
                      moodColor = Colors.white;
                  }
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: moodColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.note,
                        color: Colors.black87,
                      ),
                      title: Text(
                        notes[index]['content']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Mood: ${notes[index]['linkedMood']}',
                      ),
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
                      onTap: () => editNote(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerPage(),
    );
  }
}
