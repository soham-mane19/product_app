import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserSession {
  static Future<String> getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('sessionId');

    if (sessionId == null) {
      sessionId = Uuid().v4(); // Generate a new UUID
      await prefs.setString('sessionId', sessionId);
    }

    return sessionId;
  }
}
