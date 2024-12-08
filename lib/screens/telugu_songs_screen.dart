import 'package:flutter/material.dart';

class TeluguSongsScreen extends StatelessWidget {
  final List<String> songs = [
    "Pelli Sandadi – Raa Raa",
    "Samajavaragamana – Ala Vaikunthapurramuloo",
    "Butta Bomma – Ala Vaikunthapurramuloo",
    "Vachindamma – Geetha Govindam",
    "Mind Block – Sarileru Neekevvaru"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telugu Songs'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songs[index], style: TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }
}
