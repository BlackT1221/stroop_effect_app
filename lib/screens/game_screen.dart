import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 
import '../models/score.dart'; 

// Game screen widget
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> colors = ['Amarillo', 'Azul', 'Rojo', 'Verde']; // List of colors for the game
  String displayedWord = ''; // Word currently displayed
  String correctColor = ''; // Color that the displayed word should match
  int score = 0; // Player's score
  int showedWords = 0; // Number of words shown to the player
  int attempts = 3; // Number of attempts remaining (for non-time-based mode)
  Timer? _timer; // Timer to manage word and game duration
  int _remainingTime = 3000; // Time remaining for the current word or game
  bool _isTimeBased = false; // If the game is based on time
  int _timePerWord = 3000; // Time per word in milliseconds
  int _totalTime = 10000; // Total time for time-based game in milliseconds
  int _gameDuration = 0; // Elapsed time during the game
  String? _userName; // User's name

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load game settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userName == null) {
        _showUserNameDialog(context); // Show dialog to get username if not set
      }
    });
  }

  // Load game settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _timePerWord = prefs.getInt('timePerWord') ?? 3000;
      _isTimeBased = prefs.getBool('isTimeBased') ?? false;
      attempts = prefs.getInt('maxAttempts') ?? 3;
      _totalTime = prefs.getInt('totalGameTime') ?? 10000;
      _remainingTime = _isTimeBased ? _totalTime : _timePerWord;
    });
  }

  // Show dialog to input the user's name
  void _showUserNameDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ingresa tu nombre'),
        content: TextField(
          onChanged: (value) {
            _userName = value;
          },
          decoration: const InputDecoration(hintText: 'Nombre de usuario'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame(); // Start the game after username is entered
            },
            child: const Text('Jugar'),
          ),
        ],
      ),
    );
  }

  // Start the game
  void _startGame() {
    _nextWord(); // Show the first word
    if (_isTimeBased) {
      _startTimer(); // Start the game timer for time-based mode
    } else {
      _resetWordTimer(); // Initialize timer for each word in non-time-based mode
    }
  }

  // Start a timer to count down the remaining time
  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime -= 100;
          _gameDuration += 100;
        });
      } else {
        _checkAnswer(''); // Consider it an incorrect answer if time runs out
      }
    });
  }

  // Reset the timer for the current word
  void _resetWordTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _timePerWord;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime -= 100;
        });
      } else {
        _checkAnswer(''); // Consider it an incorrect answer if time runs out
      }
    });
  }

  // Show a new word with random color and correct answer color
  void _nextWord() {
    final random = Random();
    final wordColorIndex = random.nextInt(colors.length);
    final inkColorIndex = random.nextInt(colors.length);
    setState(() {
      displayedWord = colors[wordColorIndex];
      correctColor = colors[inkColorIndex];
      if (!_isTimeBased) {
        _resetWordTimer(); // Reset timer for each word in non-time-based mode
      }
    });
  }

  // Check if the selected color is correct
  void _checkAnswer(String selectedColor) {
    if (selectedColor == correctColor) {
      setState(() {
        score++;
        showedWords++;
      });
    } else {
      setState(() {
        if (!_isTimeBased) {
          attempts--;
        }
        showedWords++;
      });
    }

    // Check if the game should end
    if (_isTimeBased) {
      if (_gameDuration >= _totalTime) {
        _endGame(); // End the game if total time is reached
      } else {
        _nextWord(); // Show the next word
      }
    } else {
      if (attempts == 0) {
        _endGame(); // End the game if no attempts left
      } else {
        _nextWord(); // Show the next word
      }
    }
  }

  // End the game and show final score
  void _endGame() {
    _timer?.cancel();
    _saveScore(); // Save score before showing the end game dialog

    // Show end game dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(
            '¡Se acabó el juego!.\nPuntaje: $score\n Palabras mostradas: $showedWords'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushNamed(
                  '/highscores'); // Navigate to the high scores screen
            },
            child: const Text('Ver puntajes'),
          ),
        ],
      ),
    );
  }

  // Save the current score to SharedPreferences
  void _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedScores = prefs.getStringList('highScores') ?? [];

    final newScore = Score(
      userName: _userName ?? 'Anonymous',
      wordsShown: showedWords,
      wordsCorrect: score,
    ).toMap();

    savedScores.add(json.encode(newScore));
    await prefs.setStringList('highScores', savedScores);
  }

  // Get color based on the color name
  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Amarillo':
        return Colors.yellow;
      case 'Azul':
        return Colors.blue;
      case 'Rojo':
        return Colors.red;
      case 'Verde':
        return Colors.green;
      default:
        print('Unknown color name: $colorName');
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/juego.png',
          height: 40,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Palabra: $displayedWord',
            style: TextStyle(
              fontSize: 24,
              color: _getColor(correctColor),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: colors.map((color) {
              return Row(
                children: [
                  CustomElevatedButton(
                    text: color,
                    color: _getColor(color),
                    onPressed: () => _checkAnswer(color),
                  ),
                  SizedBox(width: 10,)
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Puntaje: $score', style: const TextStyle(fontSize: 24)),
          if (!_isTimeBased) ...[
            Text('Intentos restantes: $attempts',
                style: const TextStyle(fontSize: 24)),
            Text(
                'Tiempo restante: ${(_remainingTime / 1000).toStringAsFixed(1)} s',
                style: const TextStyle(fontSize: 24)),
          ],
          if (_isTimeBased)
            Text(
                'Tiempo restante: ${(_remainingTime / 1000).toStringAsFixed(1)} s',
                style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

// Custom button with color change on hover
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  CustomElevatedButton(
      {required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(color),
          side:
              MaterialStateProperty.all(const BorderSide(color: Colors.black)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold)),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
