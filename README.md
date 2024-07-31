# Stroop Effect Reaction Time App
This Flutter application measures reaction time using the Stroop effect and displays high scores. Users can configure the game settings, start the game, and view their high scores in a visually appealing manner.

## Features
Measure reaction time with the Stroop effect
User-configurable settings (time per word, game mode, maximum attempts)
Display high scores in a grid format
Save and load high scores using SharedPreferences

## Installation
1. Clone the repository
git clone https://github.com/yourusername/stroop-effect-app.git
cd stroop-effect-app

2. Install dependencies
flutter pub get

3. Run the app
flutter run

## Usage
1. Home Screen

Start the game by clicking on "Start Game".
View high scores by clicking on "View High Scores".
Configure game settings by clicking on "Settings".
Game Screen

2. Enter your username.
Follow the instructions to select the correct color as fast as possible.
The game ends when you run out of time or attempts.

3.High Scores Screen

View a grid of high scores with user names and their performance.

## Configuration
Time Per Word: Set the time each word is displayed.
Game Mode: Choose between time-based or attempt-based mode.
Maximum Attempts: Set the maximum number of attempts for the game.

## File Structure
stroop-effect-app/

├── lib/

│   ├── main.dart

│   ├── screens/

│   │   ├── home_screen.dart

│   │   ├── game_screen.dart

│   │   ├── high_scores_screen.dart

│   │   ├── settings_screen.dart

│   ├── models/

│   │   └── score.dart

│   ├── widgets/

│   │   └── custom_elevated_button.dart

├── assets/

│   ├── images/

│   │   ├── logo.png

│   │   ├── scores.png

│   │   └── game.png

├── pubspec.yaml

└── README.md

## Contributing
Fork the repository.
Create your feature branch: git checkout -b feature/YourFeature.
Commit your changes: git commit -m 'Add some feature'.
Push to the branch: git push origin feature/YourFeature.
Open a pull request.
