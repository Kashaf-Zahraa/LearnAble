
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.13:8001';

  // ============================================================
  // API ERROR HANDLING
  // ============================================================

  static String _getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        final detail = data['detail'];

        if (detail is String) {
          return detail;
        }
      }
    } catch (_) {
      // Use a generic error if the response is not valid JSON.
    }

    return 'Request failed (${response.statusCode}).';
  }

  // ============================================================
  // CREATE LEARNER USING NAME + PASSWORD
  // ============================================================

  static Future<String> createLearner({
    required String name,
    required int age,
    required String grade,
    required String avatar,
    required String password,
  }) async {
    final normalizedName = name.trim();

    if (normalizedName.isEmpty) {
      throw Exception('Please enter the learner name.');
    }

    if (password.length < 8 || password.length > 128) {
      throw Exception(
        'Password must contain between 8 and 128 characters.',
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/learners'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': normalizedName,
        'age': age,
        'grade': grade,
        'avatar': avatar,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      final data =
      jsonDecode(response.body) as Map<String, dynamic>;

      return data['learner_id'] as String;
    }

    if (response.statusCode == 409) {
      throw Exception(
        'A learner with this name and password already exists. '
            'Please choose another password.',
      );
    }

    if (response.statusCode == 422) {
      throw Exception(
        'Invalid learner details. '
            'Please check the name, age, grade and password.',
      );
    }

    throw Exception(_getErrorMessage(response));
  }

  // ============================================================
  // LOGIN USING NAME + PASSWORD
  // ============================================================

  static Future<String> loginLearner({
    required String name,
    required String password,
  }) async {
    final normalizedName = name.trim();

    if (normalizedName.isEmpty) {
      throw Exception('Please enter your learner name.');
    }

    if (password.isEmpty) {
      throw Exception('Please enter your password.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/learners/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': normalizedName,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body) as Map<String, dynamic>;

      return data['learner_id'] as String;
    }

    if (response.statusCode == 401) {
      throw Exception(
        'Invalid learner name or password. Please try again.',
      );
    }

    if (response.statusCode == 409) {
      throw Exception(
        'Multiple learner profiles have identical login '
            'credentials. Please contact the administrator.',
      );
    }

    if (response.statusCode == 429) {
      throw Exception(
        'Too many login attempts. '
            'Please try again later.',
      );
    }

    if (response.statusCode == 422) {
      throw Exception(
        'Please enter a valid learner name and password.',
      );
    }

    throw Exception(_getErrorMessage(response));
  }

  // ============================================================
  // SAVE LEARNER SUBJECTS
  // ============================================================

  static Future<void> saveLearnerSubjects({
    required String learnerId,
    required List<String> subjectNames,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/learners/$learnerId/subjects'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'subject_names': subjectNames,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 404) {
      throw Exception('Learner not found.');
    }

    if (response.statusCode == 400) {
      throw Exception('Invalid subject selected.');
    }

    throw Exception(_getErrorMessage(response));
  }

  // ============================================================
  // GET SAVED LEARNER PROFILE AND SUBJECTS
  // ============================================================

  static Future<Map<String, dynamic>> getLearnerProfile(
      String learnerId,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/learners/$learnerId'),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)
      as Map<String, dynamic>;
    }

    if (response.statusCode == 404) {
      throw Exception('Learner profile not found.');
    }

    throw Exception(_getErrorMessage(response));
  }
}
