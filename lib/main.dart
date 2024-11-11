import 'package:flutter/material.dart';
import 'package:splashify/splashify.dart';
import 'welcome_page.dart'; // Import the WelcomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iMin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set the splash screen as the initial screen
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Splashify(
      imagePath: 'assets/imin_logo.jpg',
      backgroundColor: Colors.white,
      imageSize: 400,
      navigateDuration: 3,
      imageFadeIn: true,
      fadeInNavigation: true,
      child: const WelcomePage(), // Navigate to WelcomePage after splash
    );
  }
}
