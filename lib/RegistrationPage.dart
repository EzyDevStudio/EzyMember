import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

// Registration Service
class RegistrationService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://ezymember.ezymember.com.my/api/auth/ezymember123';

  Future<bool> registerUser({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/newRegister',
        data: {
          'name': name,
          'email': email,
          'phone_number1': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection';
      case DioExceptionType.badResponse:
        return _handleErrorResponse(error.response);
      case DioExceptionType.connectionError:
        return 'Connection error';
      default:
        return 'Something went wrong';
    }
  }

  String _handleErrorResponse(Response? response) {
    if (response?.data != null && response?.data['message'] != null) {
      return response?.data['message'];
    }
    switch (response?.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }
}

// Custom Alert Dialog Widget
class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath;
  final Color buttonColor;
  final VoidCallback onPressed;
  final bool showEmailNote;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.imagePath,
    required this.buttonColor,
    required this.onPressed,
    this.showEmailNote = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Image.asset(
            imagePath,
            height: 50,
          ),
          SizedBox(height: 13),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          if (showEmailNote) ...[
            SizedBox(height: 16),
            Text(
              'Please check your inbox. We have sent your password to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        AnimatedPressButton(
          onPressed: onPressed,
          backgroundColor: buttonColor,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _registrationService = RegistrationService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }
    if (value.length < 2) {
      return 'Name should be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final cleanPhone = value.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length != 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
        title: 'Error',
        message: message,
        imagePath: 'assets/error.png',
        buttonColor: Colors.red,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _showWarningAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
        title: 'Warning',
        message: message,
        imagePath: 'assets/warning.png',
        buttonColor: Colors.orange,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
        title: 'Success',
        message: 'Registration completed successfully!',
        imagePath: 'assets/success.png',
        buttonColor: Color(0xFF0656A0),
        onPressed: () => Navigator.pop(context),
        showEmailNote: true,
      ),
    );
  }

  void _showLoadingAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          children: [
            CircularProgressIndicator(
              color: Color(0xFF0656A0),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                'Creating your account...',
                style: TextStyle(
                  color: Color(0xFF0656A0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    // Validate name
    String? nameError = validateName(_nameController.text);
    if (nameError != null) {
      _showWarningAlert(nameError);
      return;
    }

    // Validate email
    String? emailError = validateEmail(_emailController.text);
    if (emailError != null) {
      _showWarningAlert(emailError);
      return;
    }

    // Validate phone
    String? phoneError = validatePhone(_phoneController.text);
    if (phoneError != null) {
      _showWarningAlert(phoneError);
      return;
    }

    try {
      _showLoadingAlert();

      final success = await _registrationService.registerUser(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
      );

      // Remove loading dialog
      Navigator.pop(context);

      if (success) {
        _showSuccessAlert();
        // Clear form fields after successful registration
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
      } else {
        _showErrorAlert('Registration failed. Please try again.');
      }
    } catch (error) {
      // Remove loading dialog
      Navigator.pop(context);
      _showErrorAlert(error.toString());
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
                  'Sign up',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0656A0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/Sign_up.png',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'We are thrilled to have you here! To get started on your journey with us, please take a moment to fill out the signup form below.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: _buildRegistrationForm(context, isTablet: false),
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
              'assets/Sign_up.png',
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
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0656A0),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'We are thrilled to have you here! To get started on your journey with us, please take a moment to fill out the signup form below.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildRegistrationForm(context, isTablet: true),
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

  Widget _buildRegistrationForm(BuildContext context, {required bool isTablet}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputField(
            controller: _nameController,
            hintText: 'Name',
            icon: Icons.person,
            isPassword: false,
            validator: validateName,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          _buildInputField(
            controller: _emailController,
            hintText: 'Email',
            icon: Icons.email,
            isPassword: false,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16),
          _buildInputField(
            controller: _phoneController,
            hintText: 'Phone Number',
            icon: Icons.phone,
            isPassword: false,
            validator: validatePhone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: isTablet ? 450 : 280,
              height: 55,
              child: AnimatedPressButton(
                onPressed: _handleSubmit,
                backgroundColor: Color(0xFF0656A0),
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
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
    controller: controller,
    decoration: InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey[300]),
    prefixIcon: Icon(icon, color: Color(0xFF0656A0)),
    filled: true,
    fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      ),
      body: isTablet
          ? _buildTabletLayout(context)
          : _buildPhoneLayout(context),
    );
  }
}

// Animated Button Widget Implementation
class AnimatedPressButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AnimatedPressButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
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
      duration: const Duration(milliseconds: 100),
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
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? const Color(0xFF0656A0),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, _scaleAnimation.value * 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}