import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _securityQuestionKey = 'securityQuestion';
  static const String _securityAnswerKey = 'securityAnswer';
  static const String _proprietorNameKey = 'proprietorName';
  static const String _firmNameKey = 'firmName';
  static const String _addressKey = 'address';
  static const String _phoneNumberKey = 'phoneNumber';
  static const String _emailKey = 'email';
  static const String _gstNumberKey = 'gstNumber';
  static const String _recieptNumKey = 'username';


  // Save user registration data to shared preferences
  static Future<void> saveUserData(
      String username,
      String password,
      String securityQuestion,
      String securityAnswer,
      String firmName,
      String proprietorName,
      String address,
      String phoneNumber,
      String email,
      String gstNumber,
      String recieptNum,
      ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(_usernameKey, username);
    prefs.setString(_passwordKey, password);
    prefs.setString(_securityQuestionKey, securityQuestion);
    prefs.setString(_securityAnswerKey, securityAnswer);
    prefs.setString(_proprietorNameKey, proprietorName);
    prefs.setString(_firmNameKey, firmName);
    prefs.setString(_addressKey, address);
    prefs.setString(_phoneNumberKey, phoneNumber);
    prefs.setString(_emailKey, email);
    prefs.setString(_gstNumberKey, gstNumber);
    prefs.setString(_recieptNumKey, recieptNum);
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

  // Function to retrieve proprietor name
  static Future<String?> getFirmName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firmNameKey);
  }

  // Function to retrieve proprietor name
  static Future<String?> getProprietorName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_proprietorNameKey);
  }

  // Function to retrieve adress
  static Future<String?> getAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_addressKey);
  }

  // Function to retrieve contact number
  static Future<String?> getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  // Function to retrieve email
  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Function to retrieve GST Number
  static Future<String?> getGSTNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_gstNumberKey);
  }
  //Function to retrieve receipt Number
  static Future<String?> getReceiptNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_recieptNumKey);
  }
}
