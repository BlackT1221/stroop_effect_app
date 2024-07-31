import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/high_scores_screen.dart';

// The entry point of the application
void main() {
  runApp(StroopEffectApp());
}

// The main application widget
class StroopEffectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner in the app
      title: 'Stroop Effect App', // Title of the application
      theme: ThemeData(
        // Define the default theme for the application
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Border color when focused
          ),
          labelStyle: TextStyle(color: Colors.black), // Label text color
        ),
      ),
      initialRoute: '/', // The initial route when the app starts
      routes: {
        '/': (context) => HomeScreen(), // Route to the home screen
        '/game': (context) => GameScreen(), // Route to the game screen
        '/settings': (context) => SettingsScreen(), // Route to the settings screen
        '/highscores': (context) => HighScoresScreen(), // Route to the high scores screen
      },
    );
  }
}
