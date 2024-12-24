import 'package:flutter/material.dart';
import 'package:ezymember/CustomAppBar.dart';
import 'package:ezymember/ScaleAnimation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ezymember/HomePage.dart';
import 'dart:io';

import 'Main_profile.dart';

class Working_Profile extends StatelessWidget {
  const Working_Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const CompanyProfilePage();
  }
}

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final Map<String, dynamic> companyInfo = {
    'name': 'Your Company Name',
    'email': 'company@example.com',
    'contact_number': '+60 12-345-6789',
    'roc': 'ROC123456',
    'address1': 'Address Line 1',
    'address2': 'Address Line 2',
    'address3': 'Address Line 3',
    'city': 'City Name',
    'state': 'State Name',
    'postcode': '12345',
    'client_id': 'CLT123456789',
    'client_secret': 'SEC987654321',
    'tin': 'TIN123456789',
    'sst_registration': 'SST123456789',
    'tax_registration': 'TAX123456789',
  };

  late Map<String, dynamic> originalInfo;
  late Map<String, bool> editingFields;
  final Color themeColor = const Color(0xFF0656A0);
  final Color lightThemeColor = const Color(0xFFE8F1F9);

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    originalInfo = Map.from(companyInfo);
    editingFields = Map.from(companyInfo.map((key, value) => MapEntry(key, false)));
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  void _showImagePickerOptions() {
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTablet ? 25 : 20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isTablet ? 24 : 16),
              Text(
                'Choose Profile Picture',
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isTablet ? 24 : 16),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: isTablet ? 8 : 4,
                ),
                leading: Icon(
                  Icons.photo_library,
                  size: isTablet ? 28 : 24,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: isTablet ? 8 : 4,
                ),
                leading: Icon(
                  Icons.delete,
                  size: isTablet ? 28 : 24,
                ),
                title: Text(
                  'Remove Current Picture',
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                ),
                onTap: () {
                  setState(() {
                    _imageFile = null;
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: isTablet ? 24 : 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final double padding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Color(0xFF0656A0),
        titleWidget: Text(
          'Working Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                _buildHeader(screenSize),
            SizedBox(height: isTablet ? 32 : 24),
            _buildForm(screenSize),
            SizedBox(height: isTablet ? 32 : 24),
            _buildButtons(screenSize),
            SizedBox(height: isTablet ? 32 : 24),
            ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    final bool isTablet = screenSize.width > 600;
    final double imageSize = isTablet ? 120.0 : 90.0;
    final double iconSize = isTablet ? 60.0 : 45.0;
    final double fontSize = isTablet ? 32.0 : 26.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [themeColor, themeColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: screenSize.width < 400 ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _imageFile != null
                      ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                    width: imageSize,
                    height: imageSize,
                  )
                      : Icon(
                    Icons.business,
                    size: iconSize,
                    color: themeColor,
                  ),
                ),
              ),
              Positioned(
                right: -8,
                bottom: -8,
                child: Container(
                  width: isTablet ? 40 : 32,
                  height: isTablet ? 40 : 32,
                  decoration: BoxDecoration(
                    color: themeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showImagePickerOptions,
                      borderRadius: BorderRadius.circular(20),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: isTablet ? 20 : 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: screenSize.width < 400 ? 0 : 20),
          Expanded(
            child: Text(
              companyInfo['name'],
              textAlign: screenSize.width < 400 ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(Size screenSize) {
    final bool isTablet = screenSize.width > 600;
    final double padding = isTablet ? 24.0 : 16.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: lightThemeColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isTablet ? 20 : 15),
                topRight: Radius.circular(isTablet ? 20 : 15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.business_center, color: themeColor, size: isTablet ? 24 : 20),
                SizedBox(width: isTablet ? 15 : 10),
                Text(
                  'Company Details',
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Basic Information', isTablet),
                _buildEditableField('Company Name', 'name', Icons.business, isTablet),
                _buildEditableField('Email', 'email', Icons.email, isTablet),
                _buildEditableField('Contact Number', 'contact_number', Icons.phone, isTablet),
                _buildEditableField('ROC', 'roc', Icons.numbers, isTablet),

                SizedBox(height: isTablet ? 28 : 20),
                _buildSectionTitle('Address Information', isTablet),
                _buildEditableField('Address Line 1', 'address1', Icons.location_on, isTablet),
                _buildEditableField('Address Line 2', 'address2', Icons.location_on, isTablet),
                _buildEditableField('Address Line 3', 'address3', Icons.location_on, isTablet),
                _buildEditableField('City', 'city', Icons.location_city, isTablet),
                _buildEditableField('State', 'state', Icons.map, isTablet),
                _buildEditableField('Postcode', 'postcode', Icons.mail, isTablet),

                SizedBox(height: isTablet ? 28 : 20),
                _buildSectionTitle('Registration Information', isTablet),
                _buildEditableField('TIN', 'tin', Icons.assignment, isTablet),
                _buildEditableField('SST Registration', 'sst_registration', Icons.assignment_turned_in, isTablet),
                _buildEditableField('Tax Registration', 'tax_registration', Icons.receipt_long, isTablet),

                SizedBox(height: isTablet ? 28 : 20),
                _buildSectionTitle('E-INVOICE', isTablet),
                _buildNonEditableField('Client ID', 'client_id', Icons.verified_user, isTablet),
                _buildNonEditableField('Client Secret', 'client_secret', Icons.security, isTablet),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w600,
          color: themeColor,
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String field, IconData icon, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 24 : 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: themeColor, size: isTablet ? 24 : 20),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: _buildEditableText(field, isTablet)),
                    IconButton(
                      icon: Icon(
                        editingFields[field]! ? Icons.check_circle : Icons.edit,
                        size: isTablet ? 24 : 20,
                        color: themeColor,
                      ),
                      padding: EdgeInsets.all(isTablet ? 12 : 8),
                      constraints: BoxConstraints(
                        minWidth: isTablet ? 48 : 40,
                        minHeight: isTablet ? 48 : 40,
                      ),
                      onPressed: () {
                        setState(() {
                          editingFields[field] = !editingFields[field]!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonEditableField(String label, String field, IconData icon, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 24 : 16),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: isTablet ? 24 : 20),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  companyInfo[field] ?? '',
                  style: TextStyle(
                    fontSize: isTablet ? 17 : 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableText(String field, bool isTablet) {
    final isEditingThis = editingFields[field]!;

    if (isEditingThis) {
      return TextFormField(
        initialValue: companyInfo[field],
        style: TextStyle(
          fontSize: isTablet ? 17 : 15,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: isTablet ? 12 : 8,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: themeColor, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {
            companyInfo[field] = value;
          });
        },
      );
    }
    return Text(
      companyInfo[field] ?? '',
      style: TextStyle(
        fontSize: isTablet ? 17 : 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildButtons(Size screenSize) {
    final bool isTablet = screenSize.width > 600;
    final double buttonHeight = isTablet ? 56 : 48;
    final double fontSize = isTablet ? 16 : 14;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: ScaleAnimation(
              onTap: () {
                setState(() {
                  companyInfo.clear();
                  companyInfo.addAll(originalInfo);
                  editingFields.clear();
                  companyInfo.keys.forEach((key) => editingFields[key] = false);
                  _imageFile = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Form has been reset',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                  ),
                  minimumSize: Size.fromHeight(buttonHeight),
                  elevation: 4,
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ScaleAnimation(
              onTap: () {
                setState(() {
                  originalInfo = Map.from(companyInfo);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Changes saved successfully!',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    backgroundColor: themeColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                  ),
                  minimumSize: Size.fromHeight(buttonHeight),
                  elevation: 4,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}