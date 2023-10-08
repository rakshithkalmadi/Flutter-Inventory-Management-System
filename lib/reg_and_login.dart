// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sharedprefshelper.dart';
import 'homepage.dart';

class FirstTimeExecution {
  Future<void> checkAndNavigate(BuildContext context) async {
    // Initialize SharedPreferences
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the flag indicating first-time execution is set
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // Navigate to the registration page based on the first-time flag
    if (isFirstTime) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => RegistrationPage(pref: prefs),
      ));
    } else {
      // Navigate to login page from second time onwards
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => LoginPage(pref: prefs),
      ));
    }
  }
}

class RegistrationPage extends StatefulWidget {
  final SharedPreferences pref;
  const RegistrationPage({Key? key, required this.pref}) : super(key: key);

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _securityQuestionController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  final _proprietorNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _firmNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginbg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "REGISTER",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      fillColor:
                          const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Username',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      fillColor:
                          const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _securityQuestionController,
                    decoration: InputDecoration(
                      fillColor:
                          const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Security Question',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _securityAnswerController,
                    decoration: InputDecoration(
                      fillColor:
                          const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Security Answer',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _firmNameController,
                    decoration: InputDecoration(
                      fillColor:
                      const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Firm Name',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _proprietorNameController,
                    decoration: InputDecoration(
                      fillColor:
                      const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Proprietor Name',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      fillColor:
                      const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Address',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      fillColor:
                      const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Phone number controller',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor:
                      const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _gstNumberController,
                    decoration: InputDecoration(
                      fillColor:
                      const Color(0xFFD9D9D9), // Set the background color
                      filled: true,
                      labelText: 'GST Number',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final name = _nameController.text;
                        final password = _passwordController.text;
                        final securityQuestion = _securityQuestionController.text;
                        final securityAnswer = _securityAnswerController.text;
                        final proprietorName = _proprietorNameController.text;
                        final firmName = _firmNameController.text;
                        final address = _addressController.text;
                        final phoneNumber = _phoneNumberController.text;
                        final email = _emailController.text;
                        final gstNumber = _gstNumberController.text;
                        const receiptNum='0';

                        // Check if the required fields are empty
                        if (name.isEmpty ||
                            password.isEmpty ||
                            securityQuestion.isEmpty ||
                            securityAnswer.isEmpty ||
                            proprietorName.isEmpty ||
                            address.isEmpty ||
                            phoneNumber.isEmpty ||
                            email.isEmpty||
                            firmName.isEmpty) {
                          // Show an error message for the required fields
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All fields except GST Number are required.'),
                            ),
                          );
                        } else {
                          // Call a function from shared preferences helper class to save the data
                          await SharedPreferencesHelper.saveUserData(
                            name,
                            password,
                            securityQuestion,
                            securityAnswer,
                            firmName,
                            proprietorName,
                            address,
                            phoneNumber,
                            email,
                            gstNumber,
                            receiptNum,
                          );

                          // Show a dialog or navigate to the next screen
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Registration Successful'),
                                content: const Text('You can now log in.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the current dialog box
                                      Navigator.of(context).pop();
                                      //Navigate to login page after entering all details
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                            pref: widget.pref,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF47BCAE), // Change the button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Add border radius here
                      ),
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.white, // Change the text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _securityQuestionController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }
}

class LoginPage extends StatefulWidget {
  final SharedPreferences pref;
  const LoginPage({Key? key, required this.pref}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final Future<String?> username = SharedPreferencesHelper.getUsername();
  final Future<String?> password = SharedPreferencesHelper.getPassword();
  final Future<String?> securityquestion =
      SharedPreferencesHelper.getSecurityQuestion();
  final Future<String?> securityanswer =
      SharedPreferencesHelper.getSecurityAnswer();

  @override
  Widget build(BuildContext context) {
    widget.pref.setBool('isFirstTime', false);

    return Scaffold(
      body: Container(
        // Background decoration
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loginbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFD9D9D9),
                    filled: true,
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.68),
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter username'),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFD9D9D9),
                    filled: true,
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.68),
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter password'),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Validate and perform login logic here
                    if (_formKey.currentState!.validate()) {
                      final eusername = _nameController.text;
                      final epassword = _passwordController.text;
                      // If successful, navigate to the next screen
                      Future<bool> loginSuccessful =
                          validateLogin(eusername, epassword);
                      if (await loginSuccessful) {
                        String? name = await username;
                        // Navigate to the next screen or show a success message
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Successful'),
                              content: Text('Welcome, $name!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(pref:widget.pref),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Show an error message
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Failed'),
                              content:
                                  const Text('Invalid username or password.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47BCAE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    TextEditingController inputans = TextEditingController();
                    String? securityque = await securityquestion;
                    // Show a dialog to enter security answer
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Forgot Password'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Security Question: $securityque'), // Replace with your security question
                              TextFormField(
                                controller: inputans,
                                decoration: const InputDecoration(
                                  labelText: 'Security Answer',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the current dialog box
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Get the entered answer from the TextEditingController
                                String enteredAnswer = inputans.text;
                                Navigator.of(context).pop();
                                // If entered answer is correct then allow user to login
                                if (await checkSecurityAnswer(enteredAnswer)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: const Text(
                                            'You can reset your password now.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HomePage(pref: widget.pref)
                                                ),
                                                    (Route<dynamic> route) => false,
                                              );
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  //give the message that answer is incorrect
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Incorrect answer.'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Function that validates whether the credentials entered by the user is correct or not
  Future<bool> validateLogin(String eusername, String epassword) async {
    String? uname = await username;
    String? pswd = await password;
    if (eusername == uname && epassword == pswd) {
      return true;
    } else {
      return false; // Return true if login is successful, false otherwise
    }
  }

  // Function that validates  whether the input answer is correct or not
  Future<bool> checkSecurityAnswer(String answer) async {
    String? ans = await securityanswer;
    if (answer == ans) {
      return true; // Return true if the answer is correct, false otherwise
    } else {
      return false;
    }
  }
}
