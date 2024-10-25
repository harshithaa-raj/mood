import 'package:flutter/material.dart';

void main() {
  runApp(MoodTracker());
}

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  bool _isDarkMode = false; // Store the dark mode state

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Use dark or light theme based on toggle
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light, // Light theme
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Dark theme
      ),
      debugShowCheckedModeBanner: false,
      home: SettingsPage(
        onThemeChanged: (bool isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
        isDarkMode: _isDarkMode, // Pass the current theme state to the SettingsPage
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  SettingsPage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          // Dark Mode Toggle
          SwitchListTile(
            title: Text("Dark Mode"),
            subtitle: Text("Toggle between light and dark theme"),
            value: widget.isDarkMode, // Use the current theme state
            onChanged: (value) {
              widget.onThemeChanged(value); // Notify parent widget to change theme
            },
          ),
          Divider(),

          // Notifications Toggle
          SwitchListTile(
            title: Text("Notifications"),
            subtitle: Text("Enable or disable notifications"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          Divider(),

          // Language Selection
          ListTile(
            title: Text("Language"),
            subtitle: Text("Select your preferred language"),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: _languages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Divider(),

          // Account Management
          ListTile(
            title: Text("Manage Account"),
            subtitle: Text("Edit profile or log out"),
            onTap: () {
              _showAccountDialog();
            },
          ),
          Divider(),

          // Privacy Policy and Terms
          ListTile(
            title: Text("Privacy Policy"),
            onTap: () {
              _showPrivacyPolicy();
            },
          ),
          ListTile(
            title: Text("Terms of Service"),
            onTap: () {
              _showTermsOfService();
            },
          ),
          Divider(),

          // App Information
          ListTile(
            title: Text("App Version"),
            subtitle: Text("1.0.0"),
          ),
          ListTile(
            title: Text("About"),
            subtitle: Text("Developed by [Your Name]"),
          ),
        ],
      ),
    );
  }

  void _showAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Manage Account"),
          content: Text("Would you like to edit your profile or log out?"),
          actions: <Widget>[
            TextButton(
              child: Text("Edit Profile"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Log Out"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Privacy Policy"),
          content: Text("Your app's privacy policy details go here."),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terms of Service"),
          content: Text("Your app's terms of service details go here."),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
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
