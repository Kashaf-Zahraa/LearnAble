
import 'package:shared_preferences/shared_preferences.dart';

class LearnerStorage {
  static const String _learnerIdKey = 'active_learner_id';

  // Save the active learner ID.
  static Future<void> saveLearnerId(String learnerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_learnerIdKey, learnerId);
  }

  // Retrieve the saved learner ID.
  static Future<String?> getLearnerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_learnerIdKey);
  }

  // Clear the active learner ID when switching or logging out.
  static Future<void> clearLearnerId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_learnerIdKey);
  }
}
