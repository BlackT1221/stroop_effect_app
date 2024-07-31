import 'dart:convert'; // Import dart:convert to use json.decode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart'; // Import your Score model

// Screen to display high scores
class HighScoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/puntajes.png', // Image for the app bar title
          height: 40,
        ),
      ),
      body: FutureBuilder<List<Score>>(
        future: _getHighScores(), // Fetch high scores asynchronously
        builder: (context, snapshot) {
          // Handle different states of the future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator while waiting
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error message if there's an error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No high scores available.')); // Show message if no data is available
          } else {
            // Display a list of high scores if data is available
            return ListView.builder(
              itemCount: snapshot.data!.length, // Number of items in the list
              itemBuilder: (context, index) {
                final score = snapshot.data![index]; // Get the score at the current index
                return ListTile(
                  title: Text('User: ${score.userName}'), // Display user name
                  subtitle: Text(
                    'Words Shown: ${score.wordsShown}\n'
                    'Words Correct: ${score.wordsCorrect}', // Display words shown and correct
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fetch high scores from SharedPreferences
  Future<List<Score>> _getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedScores = prefs.getStringList('highScores') ?? [];

    // Convert JSON strings to Score objects
    return savedScores
        .map((score) => Score.fromMap(json.decode(score)))
        .toList();
  }
}
