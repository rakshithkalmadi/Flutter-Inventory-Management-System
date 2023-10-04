import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _securityQuestionKey = 'securityQuestion';
  static const String _securityAnswerKey = 'securityAnswer';

  // Save user registration data to shared preferences
  static Future<void> saveUserData(
      String username,
      String password,
      String securityQuestion,
      String securityAnswer,
      ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(_usernameKey, username);
    prefs.setString(_passwordKey, password);
    prefs.setString(_securityQuestionKey, securityQuestion);
    prefs.setString(_securityAnswerKey, securityAnswer);
  }

  // Retrieve the stored username
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Retrieve the stored password
  static Future<String?> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  // Retrieve the stored security question
  static Future<String?> getSecurityQuestion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_securityQuestionKey);
  }

  // Retrieve the stored security answer
  static Future<String?> getSecurityAnswer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_securityAnswerKey);
  }

  // Update the new password
  static Future<void> updatePassword(String newPassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString(_passwordKey, newPassword);
  }
}
