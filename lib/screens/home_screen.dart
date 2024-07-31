import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'high_scores_screen.dart';

// Home screen of the app
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
          children: <Widget>[
            Image.asset('images/logo.png'), // App logo
            const SizedBox(height: 20), // Space between the logo and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
              children: [
                Column(
                  children: [
                    // Button to start the game
                    CustomElevatedButton(
                      text: 'Start Game',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20, // Space between buttons
                ),
                Column(
                  children: [
                    // Button to view high scores
                    CustomElevatedButton(
                      text: 'View High Scores',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HighScoresScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20, // Space between buttons
                ),
                Column(
                  children: [
                    // Button to open settings
                    CustomElevatedButton(
                      text: 'Settings',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom elevated button with hover effects
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomElevatedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.black; // Background color when hovered
            }
            return Colors.white; // Default background color
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.white; // Text color when hovered
            }
            return Colors.black; // Default text color
          }),
          side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Border color
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Button border radius
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
