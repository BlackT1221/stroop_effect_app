import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screen for user settings
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  int _timePerWord = 3000; // Time per word in milliseconds
  int _maxAttempts = 3; // Maximum number of attempts
  bool _isTimeBased = false; // If the game is time-based
  int _totalGameTime = 10000; // Total game time in milliseconds

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load saved settings when the screen initializes
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _timePerWord = prefs.getInt('timePerWord') ?? 3000;
      _maxAttempts = prefs.getInt('maxAttempts') ?? 3;
      _isTimeBased = prefs.getBool('isTimeBased') ?? false;
      _totalGameTime = prefs.getInt('totalGameTime') ?? 10000;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timePerWord', _timePerWord);
    await prefs.setInt('maxAttempts', _maxAttempts);
    await prefs.setBool('isTimeBased', _isTimeBased);
    await prefs.setInt('totalGameTime', _totalGameTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/config.png',
          height: 40,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Switch to toggle between time-based and attempt-based game modes
                  SwitchListTile(
                    title: Text('Play with time only', style: TextStyle(fontWeight: FontWeight.w500)),
                    value: _isTimeBased,
                    onChanged: (bool value) {
                      setState(() {
                        _isTimeBased = value;
                      });
                    },
                  ),
                  // Show the total game time input if the game is time-based
                  if (_isTimeBased)
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Total game time (ms)'),
                      initialValue: _totalGameTime.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un valor';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _totalGameTime = int.parse(value!);
                      },
                    )
                  // Show the time per word and max attempts inputs if the game is not time-based
                  else
                    Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Tiempo por palabra (ms)'),
                          initialValue: _timePerWord.toString(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un valor';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _timePerWord = int.parse(value!);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Cantidad de intentos máximos'),
                          initialValue: _maxAttempts.toString(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un valor';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _maxAttempts = int.parse(value!);
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  // Custom button to save settings
                  CustomElevatedButton(
                    text: 'Guardar la configuración',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _saveSettings();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
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
