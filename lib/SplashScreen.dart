import 'package:flutter/material.dart';
import 'package:splashify/splashify.dart';

class SplashScreen extends StatelessWidget {
  final Widget child;

  const SplashScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Splashify(
          imagePath: 'assets/imin_logo.jpg', // Main logo in the center
          backgroundColor: Colors.white,
          imageSize: 400, // Increased size for better visibility
          navigateDuration: 3,
          imageFadeIn: true,
          fadeInNavigation: false,
          child: child,
        ),
        // Small logo at the bottom center
        Positioned(
          bottom: 20, // Distance from the bottom
          left: MediaQuery.of(context).size.width / 2 - 50, // Center horizontally
          child: SizedBox(
            width: 100, // Fixed width for the small logo
            height: 100, // Fixed height for the small logo
            child: Image.asset('assets/imin_logo.jpg'), // Small logo
          ),
        ),
      ],
    );
  }
}
