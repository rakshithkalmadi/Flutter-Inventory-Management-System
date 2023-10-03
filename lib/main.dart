import 'package:flutter/material.dart';
import 'dart:async';
import 'reg_and_login.dart';

void main() => runApp(const MaterialApp(home: SplashScreen()));

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    // Start the pop animation
    Future.delayed(Duration.zero, () {
      setState(() {
        _isPopped = true;
      });
    });

    // Navigate to the next page after animation
    Timer(const Duration(seconds: 2), () {
      FirstTimeExecution().checkAndNavigate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          width: _isPopped ? 200.0 : 100.0,
          height: _isPopped ? 200.0 : 100.0,
          child: Image.asset('assets/splash_image.png'), // Replace with your image
        ),
      ),
    );
  }
}

