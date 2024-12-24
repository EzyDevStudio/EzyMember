import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'HomePage.dart';
import 'ForgotPasswordPage.dart';

class LoginApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://ezymember.ezymember.com.my/api';

  Future<Map<String, dynamic>> login(String input, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/ezymember123/login',
        data: {
          'email': input,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginApiService = LoginApiService();
  bool _isPasswordVisible = false;
  bool _isValidating = false;
  bool _isLoading = false;
  bool _isPhoneLogin = false;
  String _completePhoneNumber = '';
  static const Color themeColor = Color(0xFF0656A0);

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value);
  }

  String? validateEmail(String? value) {
    if (!_isValidating) return null;

    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (!_isValidating) return null;

    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _showErrorAlert(String message) {
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isValidating = false;
              });
            },
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
          'Login successful!',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
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

  Future<void> _handleLogin() async {
    setState(() {
      _isValidating = true;
      _isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final input = _isPhoneLogin ? _completePhoneNumber : _emailController.text;
        final response = await _loginApiService.login(
          input,
          _passwordController.text,
        );

        _showSuccessAlert();
        print('Login successful: $response');
      } catch (e) {
        _showErrorAlert(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      String? error = _getFirstValidationError();
      if (error != null) {
        _showErrorAlert(error);
      }
    }
  }

  String? _getFirstValidationError() {
    if (_isPhoneLogin) {
      if (_completePhoneNumber.isEmpty) {
        return 'Phone number is required';
      }
    } else {
      final emailError = validateEmail(_emailController.text);
      if (emailError != null) return emailError;
    }

    final password = validatePassword(_passwordController.text);
    if (password != null) return password;

    return null;
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
                  'Login',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
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
                'We are excited to have you back! Please take a moment to fill in your details and log in to your account.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: _buildLoginForm(context, isTablet: false),
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
              'assets/Login.png',
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
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      const Text(
                        'We are excited to have you back! Please take a moment to fill in your details and log in to your account.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildLoginForm(context, isTablet: true),
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

  Widget _buildLoginForm(BuildContext context, {required bool isTablet}) {
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
                selected: !_isPhoneLogin,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _isPhoneLogin = false;
                      _phoneController.clear();
                      _completePhoneNumber = '';
                    });
                  }
                },
                selectedColor: themeColor,
                labelStyle: TextStyle(
                  color: !_isPhoneLogin ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(width: 16),
              ChoiceChip(
                label: Text('Phone'),
                selected: _isPhoneLogin,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _isPhoneLogin = true;
                      _emailController.clear();
                    });
                  }
                },
                selectedColor: themeColor,
                labelStyle: TextStyle(
                  color: _isPhoneLogin ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildLoginInputField(),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock,
            isPassword: !_isPasswordVisible,
            validator: validatePassword,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: themeColor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 12,
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: isTablet ? 450 : 280,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Login',
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
                "Don't have an account? ",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to registration page
                  print('Register button pressed');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Register',
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

  Widget _buildLoginInputField() {
    if (_isPhoneLogin) {
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
        child: IntlPhoneField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            // Custom counter widget to show current length out of 10
            counter: Text(
              '${_phoneController.text.length}/10',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          initialCountryCode: 'MY',
          disableLengthCheck: true,
          onChanged: (phone) {
            // Limit to 10 digits
            if (phone.number.length > 10) {
              String truncated = phone.number.substring(0, 10);
              _phoneController.value = TextEditingValue(
                text: truncated,
                selection: TextSelection.collapsed(offset: truncated.length),
              );
            }
            setState(() {
              _completePhoneNumber = phone.completeNumber;
            });
          },
          validator: (phone) {
            if (!_isValidating) return null;
            if (phone == null || phone.number.isEmpty) {
              return 'Phone number is required';
            }
            if (phone.number.length != 10) {
              return 'Phone number must be exactly 10 digits';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      );
    } else {
      return _buildInputField(
        controller: _emailController,
        hintText: 'Email',
        icon: Icons.email,
        isPassword: false,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
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
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            // This ensures error text is included within the border
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ),
        child: TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: themeColor, size: 22),
            suffixIcon: suffixIcon,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            // Remove the default error border
            errorMaxLines: null,
            // Include error text within the container
            isDense: true,
          ),
          obscureText: isPassword,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
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
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context)
            : _buildPhoneLayout(context),
      ),
    );
  }
}