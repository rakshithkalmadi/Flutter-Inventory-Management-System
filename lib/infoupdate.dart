// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final SharedPreferences pref;
  VoidCallback refresh;
  ProfilePage({Key? key, required this.pref, required this.refresh})
      : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _securityQuestionController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  final _firmNameController = TextEditingController();
  final _proprietorNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Retrieve user data from SharedPreferences and pre-fill text fields
    _nameController.text = widget.pref.getString('username') ?? '';
    _passwordController.text = widget.pref.getString('password') ?? '';
    _securityQuestionController.text =
        widget.pref.getString('securityQuestion') ?? '';
    _securityAnswerController.text =
        widget.pref.getString('securityAnswer') ?? '';
    _proprietorNameController.text =
        widget.pref.getString('proprietorName') ?? '';
    _firmNameController.text = widget.pref.getString('firmName') ?? '';
    _addressController.text = widget.pref.getString('address') ?? '';
    _phoneNumberController.text = widget.pref.getString('phoneNumber') ?? '';
    _emailController.text = widget.pref.getString('email') ?? '';
    _gstNumberController.text = widget.pref.getString('gstNumber') ?? '';
  }

  // Function to show a confirmation dialog
  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Update'),
          content: const Text('Are you sure you want to update your profile?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Save updated user data to SharedPreferences
                await widget.pref.setString('name', _nameController.text);
                await widget.pref
                    .setString('password', _passwordController.text);
                await widget.pref.setString(
                    'securityQuestion', _securityQuestionController.text);
                await widget.pref.setString(
                    'securityAnswer', _securityAnswerController.text);
                await widget.pref.setString(
                    'proprietorName', _proprietorNameController.text);
                await widget.pref
                    .setString('firmName', _firmNameController.text);
                await widget.pref.setString('address', _addressController.text);
                await widget.pref
                    .setString('phoneNumber', _phoneNumberController.text);
                await widget.pref.setString('email', _emailController.text);
                await widget.pref
                    .setString('gstNumber', _gstNumberController.text);

                widget.refresh();
                // Show a success message or navigate to another page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully.'),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _securityQuestionController.text.isEmpty ||
                            _securityAnswerController.text.isEmpty ||
                            _proprietorNameController.text.isEmpty ||
                            _addressController.text.isEmpty ||
                            _phoneNumberController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _firmNameController.text.isEmpty) {
                          // Show an error message for the required fields
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'All fields except GST Number are required.'),
                            ),
                          );
                        } else {
                          // Show the confirmation dialog before updating the profile
                          _showConfirmationDialog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF47BCAE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
