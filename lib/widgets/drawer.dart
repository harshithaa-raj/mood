import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 196, 150, 227),
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
              Navigator.pushNamed(context, "/home"); 
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notes'),
            onTap: () {
              Navigator.pushNamed(context, "/notepage"); 
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Stats'),
            onTap: () {
              Navigator.pushNamed(context, "/moodhistory"); 
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () {
              Navigator.pushNamed(context,'/');
            },
          ),
          ListTile(
            leading:Icon(Icons.settings),
            title:Text('Setting'),
            onTap: (){
              Navigator.pushNamed(context,"/Settingspage");
            },

          )
        ],
      ),
    );
  }
}