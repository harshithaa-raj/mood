import 'package:flutter/material.dart';
import 'package:flutter_mood/pages/Home_Page.dart';
import 'package:flutter_mood/pages/editprofile_page.dart';
import 'package:flutter_mood/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MoodTracker());
}

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  
  bool _isDarkMode = false;
  bool _isLoggedIn = true;




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
      home: _isLoggedIn ? Homepage() : LoginPage(),

      // Routes for navigation to other pages like Settings
      routes: {
        '/settings': (context) => SettingsPage(
          onThemeChanged: (bool isDark) {
            setState(() {
              _isDarkMode = isDark;
            });
          },
          isDarkMode: _isDarkMode,
        ),
      },
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
  bool _isLoggedIn = true;

  final List<String> _languages = ['English', 'hindi' ];

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

          

          // Account Management
          ListTile(
            title: Text("Manage Account"),
            subtitle: Text("Edit profile or log out"),
            onTap: () {
               _showManageAccountDialog();
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

 
  

void _showManageAccountDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Manage Account"),
        content: Text("Would you like to edit your profile or log out?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog first
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
            child: Text("Edit Profile"),
          ),
          TextButton(
            onPressed: () {
              _logout(); // Call logout function
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Log Out"),
          ),
        ],
      );
    },
  );
}



void _logout() async {
  // Clear any saved user session data (like tokens or preferences)
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all stored data

  // Optionally set flags or variables to indicate that the user has logged out
  setState(() {
    // For example, you can use a boolean flag to track the user's login status
    // _isLoggedIn is an example flag you might define earlier in your app's state
    _isLoggedIn = false; // This flag will indicate the user is logged out
  });

  // Navigate to the LoginPage and remove all previous routes from the stack
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginPage()), // Ensure LoginPage is correct
    (Route<dynamic> route) => false, // This removes all previous routes
  );

  // Optional: Provide feedback to the user that they've logged out successfully
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Logged out successfully')),
  );
}



  void _showPrivacyPolicy() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Privacy Policy"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make the dialog only as tall as its content
            children: [
              Text(
                "Privacy Policy for MoodTracker\n\n"
                "Effective Date: [Insert Date]\n\n"
                "Thank you for using MoodTracker! We value your privacy and are committed to protecting your personal information. This Privacy Policy explains what information we collect, how we use it, and your rights regarding your data when using the MoodTracker app.\n\n"
                "1. Information We Collect:\n"
                "We collect the following types of information to provide and improve the MoodTracker app:\n"
                "   a. Personal Data: If you create an account, we may collect your email address and other profile information (such as username or profile picture). This information is used solely to provide account-related features.\n"
                "   b. Mood Data: MoodTracker allows you to track your moods over time. This data is stored locally on your device and may be synced to our servers if you create an account or enable cloud backup. We do not share this data with third parties.\n"
                "   c. Usage Data: We may collect information about how you use the app, including the features you access and the frequency of use. This data is used for analytics to improve app performance and user experience.\n\n"
                "2. How We Use Your Information:\n"
                "We use the information collected to:\n"
                "   - Provide and personalize the app’s features and services.\n"
                "   - Maintain and improve the performance of the app.\n"
                "   - Troubleshoot and provide technical support.\n"
                "   - Conduct analytics to understand how users engage with the app.\n"
                "   - Send you notifications if you have enabled them (e.g., daily mood reminders).\n\n"
                "3. Data Storage and Security:\n"
                "   - Your mood data is stored locally on your device and is only uploaded to our servers if you choose to back it up or create an account.\n"
                "   - We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no system is completely secure, and we cannot guarantee the security of your data.\n"
                "   - If you wish to delete your data or account, you can do so within the app, and all associated data will be permanently deleted from our servers.\n\n"
                "4. Sharing of Information:\n"
                "We do not sell, trade, or otherwise transfer your personal information to third parties. We may share your information only in the following situations:\n"
                "   - With Your Consent: We may share data with your explicit consent for specific purposes.\n"
                "   - For Legal Compliance: We may disclose information if required by law, court order, or government regulations.\n"
                "   - Service Providers: We may share data with trusted third-party providers who assist us in operating the app. These providers are bound by confidentiality agreements.\n\n"
                "5. Your Rights:\n"
                "   - Access: You can request access to the personal data we have about you.\n"
                "   - Correction: You can correct any inaccurate personal information within the app’s settings.\n"
                "   - Deletion: You have the right to delete your data at any time by choosing the appropriate options in the app.\n"
                "   - Opt-Out: You may opt out of receiving notifications or communications from us by disabling notifications in the app’s settings.\n\n"
                "6. Third-Party Links and Services:\n"
                "MoodTracker may include links to third-party services or websites, which are governed by their own privacy policies. We are not responsible for the privacy practices of these third parties.\n\n"
                "7. Children’s Privacy:\n"
                "MoodTracker is not intended for use by children under the age of 13. We do not knowingly collect or store personal information from children under 13. If we become aware of such data, we will take immediate steps to delete it.\n\n"
                "8. Changes to this Privacy Policy:\n"
                "We may update this Privacy Policy from time to time. When changes are made, we will notify users within the app or via email. Please review this policy periodically for any updates.\n\n"
                "9. Contact Us:\n"
                "If you have any questions or concerns about this Privacy Policy or your data, please contact us at:\n"
                "Email: [your.email@example.com]\n"
                "Phone: [your contact number]\n\n"
                "By using MoodTracker, you consent to this Privacy Policy.",
                textAlign: TextAlign.left, // Align text to the left
              ),
            ],
          ),
        ),
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
          content: SingleChildScrollView(
            child: Text(
              '''Welcome to MoodTracker! By using our app, you agree to the following Terms of Service (ToS). Please read these terms carefully as they outline your rights, obligations, and limitations while using the app.

1. Acceptance of Terms:
By downloading, accessing, or using MoodTracker, you agree to be bound by these terms. If you do not agree, you may not use the app.

2. User Responsibilities:
You are responsible for all activities that occur under your account. You agree to use the app in compliance with applicable laws and not to:
- Share harmful or offensive content.
- Use the app for any illegal purposes.
- Attempt to harm or exploit the app’s functionality, including hacking or introducing malware.

3. Accounts and Registration:
MoodTracker may allow you to create an account to store your preferences and data. You agree to provide accurate information during registration and to keep your login credentials secure. MoodTracker is not responsible for any loss or damage resulting from unauthorized access to your account.

4. Mood Data Collection:
MoodTracker allows users to track their mood and related data for personal reflection. While we make efforts to secure your data, the app should not be used as a substitute for medical or psychological advice. Always consult a healthcare professional if you're experiencing mental health issues.

5. Intellectual Property:
The design, code, and content of the MoodTracker app are the intellectual property of [Your Name/Company]. You may not copy, distribute, or reproduce any part of the app without prior written consent.

6. Termination:
We reserve the right to terminate or suspend your access to the app at any time, with or without cause, and with or without notice. Reasons for termination may include violation of these ToS, harmful behavior, or illegal activities.

7. Disclaimers:
MoodTracker is provided “as is” without any warranties of any kind. We do not guarantee that the app will be free from bugs, errors, or interruptions. MoodTracker does not provide medical advice, and we are not liable for any actions you take based on data from the app.

8. Limitation of Liability:
To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising out of your use or inability to use the app, including but not limited to data loss, personal injury, or emotional distress.

9. Changes to the Terms:
We reserve the right to modify or update these Terms of Service at any time. We will notify you of significant changes through in-app notifications. Your continued use of the app after changes are made signifies your acceptance of the new terms.

10. Governing Law:
These Terms of Service are governed by and construed in accordance with the laws of [Your Country/State]. Any disputes related to these terms will be resolved in the courts of [Your Jurisdiction].

11. Contact Information:
If you have any questions or concerns about these Terms of Service, please contact us at:
Email: [your.email@example.com]
Phone: [your contact number]
              ''',
            ),
          ),
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