import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
import 'LoginPage.dart'; // Assuming you have this page
import 'ProfilePage.dart';
import 'Main_profile.dart';
import 'package:ezymember/HomePage.dart';



// Animated Button Widget
class AnimatedPressButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const AnimatedPressButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  _AnimatedPressButtonState createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0656A0),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, _scaleAnimation.value * 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Welcome Page Widget
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Method to handle button press for the first button
  void _onPressed1() {
    // Navigate to RegistrationPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  // Method to handle button press for the second button
  void _onPressed2() {
    // Navigate to LoginPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Assuming you have LoginPage
    );
  }

  // Method to handle button press for the ProfilePage button
  void _onProfilePressed() {
    // Navigate to ProfilePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          return isTablet ? _buildTabletLayout() : _buildMobileLayout();
        },
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Left side with centered image
        Expanded(
          flex: 1,
          child: Center(
            child: Image.asset(
              'assets/welcome.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Right side with text and buttons
        Expanded(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WELCOME!',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0656A0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 500,
                    child: Text(
                      'Welcome to Ezy Membership! Your gateway to exclusive deals and rewards.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildButton(
                    onPressed: _onPressed1,
                    buttonText: 'Create a new account',
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    onPressed: _onPressed2,
                    buttonText: 'I already have an account',
                  ),
                  const SizedBox(height: 20),
                  // Temporary button to navigate to ProfilePage
                  _buildButton(
                    onPressed: _onProfilePressed,
                    buttonText: 'Go to Profile Page',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60), // Add padding at the top
          Image.asset(
            'assets/welcome.png',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'WELCOME!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0656A0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 300,
                child: Text(
                  'Welcome to Ezy Membership! Your gateway to exclusive deals and rewards.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                _buildButton(
                  onPressed: _onPressed1,
                  buttonText: 'Create a new account',
                ),
                const SizedBox(height: 20),
                _buildButton(
                  onPressed: _onPressed2,
                  buttonText: 'I already have an account',
                ),
                const SizedBox(height: 20),
                // Temporary button to navigate to ProfilePage
                _buildButton(
                    onPressed: _onProfilePressed,
                    buttonText: 'Go to Profile Page',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40), // Add padding at the bottom
        ],
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String buttonText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedPressButton(
        onPressed: onPressed,
        buttonText: buttonText,
      ),
    );
  }
}
