class Score {
  final String userName; // Username of the player
  final int wordsShown; // Number of words shown to the player
  final int wordsCorrect; // Number of correct answers by the player

  // Constructor for Score
  Score({
    required this.userName,
    required this.wordsShown,
    required this.wordsCorrect,
  });

  // Create a Score instance from a Map
  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      userName: map['userName'] ?? '',
      wordsShown: map['wordsShown'] ?? 0,
      wordsCorrect: map['wordsCorrect'] ?? 0,
    );
  }

  // Convert a Score instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'wordsShown': wordsShown,
      'wordsCorrect': wordsCorrect,
    };
  }
}
