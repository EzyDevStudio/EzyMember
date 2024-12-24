import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isLoading = false;
  bool _isEmailMode = true; // Toggle between email and phone number
  static const Color themeColor = Color(0xFF0656A0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    // AppBar code remains the same
    return AppBar(
      backgroundColor: Color(0xFF0656A0),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Image.asset(
        'assets/imin_display_logo.png',
        color: Colors.white,
        height: 20,
      ),
      centerTitle: true,
    );
  }

  void _showErrorAlert(String message) {
    // Error alert code remains the same
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        titlePadding: EdgeInsets.zero,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Image.asset(
              'assets/warning.png',
              height: 50,
            ),
            SizedBox(height: 13),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessAlert() {
    // Success alert code remains the same
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        titlePadding: EdgeInsets.zero,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(height: 13),
            Text(
              'Success',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'Reset link sent to your ${_isEmailMode ? "email" : "phone number"}!',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Return to login page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      _showSuccessAlert();
    }
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/Forget.png',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Don\'t worry! It happens. Please enter the ${_isEmailMode ? "email address" : "phone number"} associated with your account.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: _buildForgotPasswordForm(isTablet: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              'assets/Forget.png',
              height: 400,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Container(
                  width: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Don\'t worry! It happens. Please enter the ${_isEmailMode ? "email address" : "phone number"} associated with your account.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildForgotPasswordForm(isTablet: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm({required bool isTablet}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: Text('Email'),
                selected: _isEmailMode,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _isEmailMode = true;
                      _controller.clear();
                    });
                  }
                },
                selectedColor: themeColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: _isEmailMode ? themeColor : Colors.grey,
                  fontWeight: _isEmailMode ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              SizedBox(width: 16),
              ChoiceChip(
                label: Text('Phone'),
                selected: !_isEmailMode,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _isEmailMode = false;
                      _controller.clear();
                    });
                  }
                },
                selectedColor: themeColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: !_isEmailMode ? themeColor : Colors.grey,
                  fontWeight: !_isEmailMode ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: _controller,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: _isEmailMode ? 'Email' : 'Phone Number',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  _isEmailMode ? Icons.email_outlined : Icons.phone_outlined,
                  color: themeColor,
                  size: 22,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: themeColor, width: 1),
                ),
              ),
              keyboardType: _isEmailMode ? TextInputType.emailAddress : TextInputType.phone,
              inputFormatters: !_isEmailMode
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your ${_isEmailMode ? "email" : "phone number"}';
                }
                if (_isEmailMode) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                } else {
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: isTablet ? 450 : 280,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Remember your password? ",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: isTablet ? _buildTabletLayout(context) : _buildPhoneLayout(context),
    );
  }
}