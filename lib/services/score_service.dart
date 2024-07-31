import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/score.dart';

// Service class for managing scores
class ScoreService {
  // URL of the API endpoint for scores
  final String apiUrl = 'https://example.com/api/scores';

  // Fetch the list of high scores from the API
  Future<List<Score>> getHighScores() async {
    // Send a GET request to the API endpoint
    final response = await http.get(Uri.parse(apiUrl));

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Decode the JSON response body
      List<dynamic> data = json.decode(response.body);
      // Convert the list of JSON objects to a list of Score objects
      return data.map((json) => Score.fromMap(json)).toList();
    } else {
      // Throw an exception if the response status code is not 200
      throw Exception('Error loading scores');
    }
  }
}
