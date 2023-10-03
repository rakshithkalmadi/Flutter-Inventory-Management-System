// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeExecution {
  Future<void> checkAndNavigate(BuildContext context) async {
    // Initialize SharedPreferences
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the flag indicating first-time execution is set
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // Navigate to the appropriate page based on the first-time flag
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false); // Set the flag to false
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const FirstTimeExecutionPage(),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const HomePage(),
      ));
    }
  }
}

class FirstTimeExecutionPage extends StatelessWidget {
  const FirstTimeExecutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Execute code that should only run on the first-time launch here

    return Scaffold(
      appBar: AppBar(title: const Text('First Time Execution')),
      body: const Center(
        child: Text('This code runs only once on the first-time launch.'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Code for the regular app home page

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: const Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}
