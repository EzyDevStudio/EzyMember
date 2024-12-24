import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'CustomAppBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _resetController;
  late AnimationController _saveController;
  late AnimationController _cancelController;
  late AnimationController _generateController;

  late Animation<double> _resetAnimation;
  late Animation<double> _saveAnimation;
  late Animation<double> _cancelAnimation;
  late Animation<double> _generateAnimation;


  File? _imageFile;
  String? _avatarString;
  bool _useRandomAvatar = true;
  List<String> _randomSeeds = [];

  String _name = 'ahmed';
  final String _email = 'ahmed@demo.com';
  final String _phoneNumber = '01111111111';
  String _age = '2000-01-01';
  String _address1 = '123 Main St';
  String _address2 = 'Suite 456';
  String _address3 = 'City Name';
  String _address4 = 'Country Name';
  String _zipCode = '12345';
  String _state = 'Johor';

  late String _originalName;
  late String _originalAge;
  late String _originalAddress1;
  late String _originalAddress2;
  late String _originalAddress3;
  late String _originalAddress4;
  late String _originalZipCode;
  late String _originalState;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final List<String> _states = [
    'Johor', 'Kedah', 'Kelantan', 'Malacca', 'Negeri Sembilan',
    'Pahang', 'Penang', 'Perak', 'Perlis', 'Sabah', 'Sarawak',
    'Selangor', 'Terengganu', 'Kuala Lumpur', 'Labuan', 'Putrajaya'
  ];

  @override
  void initState() {
    super.initState();
    _generateNewAvatars();
    _saveOriginalState();

    _resetController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _saveController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _cancelController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _generateController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _resetAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeInOut),
    );
    _saveAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveController, curve: Curves.easeInOut),
    );
    _cancelAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _cancelController, curve: Curves.easeInOut),
    );
    _generateAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _generateController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    _saveController.dispose();
    _cancelController.dispose();
    _generateController.dispose();
    super.dispose();
  }


  Future<void> _animateButtonPress(AnimationController controller) async {
    await controller.forward();
    await controller.reverse();
  }

  Future<void> _handleResetPress() async {
    await _animateButtonPress(_resetController);
    _resetToOriginalState();
  }

  Future<void> _handleSavePress() async {
    await _animateButtonPress(_saveController);
    _saveOriginalState();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Profile saved')));
  }

  Future<void> _handleCancelPress() async {
    await _animateButtonPress(_cancelController);
    Navigator.of(context).pop();
  }

  Future<void> _handleGeneratePress(StateSetter setDialogState) async {
    await _animateButtonPress(_generateController);
    setDialogState(() {
      _generateNewAvatars();
    });
  }

  void _saveOriginalState() {
    _originalName = _name;
    _originalAge = _age;
    _originalAddress1 = _address1;
    _originalAddress2 = _address2;
    _originalAddress3 = _address3;
    _originalAddress4 = _address4;
    _originalZipCode = _zipCode;
    _originalState = _state;
  }

  void _resetToOriginalState() {
    setState(() {
      _name = _originalName;
      _age = _originalAge;
      _address1 = _originalAddress1;
      _address2 = _originalAddress2;
      _address3 = _originalAddress3;
      _address4 = _originalAddress4;
      _zipCode = _originalZipCode;
      _state = _originalState;
      _imageFile = null;
      _useRandomAvatar = true;
      _avatarString = null;
    });
  }

  void _generateNewAvatars() {
    setState(() {
      _randomSeeds = List.generate(
        10,
            (_) => DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(1000000).toString(),
      );
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _useRandomAvatar = false;
      });
    }
  }

  void _showStatePicker() {
    int selectedIndex = _states.indexOf(_state);
    final isTablet = MediaQuery.of(context).size.width > 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isTablet ? 14 : 13,
                      ),
                    ),
                  ),
                  Text(
                    'Select State',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0656A0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _state = _states[selectedIndex];
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF0656A0),
                        fontSize: isTablet ? 14 : 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: CupertinoPicker(
                    itemExtent: isTablet ? 40 : 32,
                    magnification: 1.2,
                    squeeze: 1.0,
                    useMagnifier: true,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedIndex,
                    ),
                    onSelectedItemChanged: (int index) {
                      selectedIndex = index;
                    },
                    children: _states.map((String state) {
                      return Center(
                        child: Text(
                          state,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker() {
    DateTime initialDate = DateTime.parse(_age);
    DateTime minimumDate = DateTime(1900);
    DateTime maximumDate = DateTime.now();
    final isTablet = MediaQuery.of(context).size.width > 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isTablet ? 14 : 13,
                      ),
                    ),
                  ),
                  Text(
                    'Select Date of Birth',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0656A0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _age = _dateFormat.format(initialDate);
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF0656A0),
                        fontSize: isTablet ? 14 : 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    onDateTimeChanged: (DateTime newDate) {
                      initialDate = newDate;
                    },
                    dateOrder: DatePickerDateOrder.ymd,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _editField(String field) {
    if (field == 'age') {
      _showDatePicker();
      return;
    }

    final isTablet = MediaQuery.of(context).size.width > 600;
    TextEditingController controller = TextEditingController();
    String title = '';
    TextInputType keyboardType = TextInputType.text;

    switch (field) {
      case 'name':
        controller.text = _name;
        title = 'Edit Name';
        break;
      case 'address1':
        controller.text = _address1;
        title = 'Edit Address 1';
        break;
      case 'address2':
        controller.text = _address2;
        title = 'Edit Address 2';
        break;
      case 'address3':
        controller.text = _address3;
        title = 'Edit Address 3';
        break;
      case 'address4':
        controller.text = _address4;
        title = 'Edit Address 4';
        break;
      case 'zipCode':
        controller.text = _zipCode;
        title = 'Edit Zip Code';
        keyboardType = TextInputType.number;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('SAVE'),
              onPressed: () {
                setState(() {
                  switch (field) {
                    case 'name':
                      _name = controller.text;
                      break;
                    case 'address1':
                      _address1 = controller.text;
                      break;
                    case 'address2':
                      _address2 = controller.text;
                      break;
                    case 'address3':
                      _address3 = controller.text;
                      break;
                    case 'address4':
                      _address4 = controller.text;
                      break;
                    case 'zipCode':
                      _zipCode = controller.text;
                      break;
                  }
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }


  Widget _buildProfileField(String label, String value, String field,
      {bool isEditable = true}) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 14,
              vertical: isTablet ? 15 : 11,
            ),
            constraints: BoxConstraints(
              minHeight: isTablet ? 40 : 36,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 13,
                      color: isEditable ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ),
                if (isEditable)
                  SizedBox(
                    width: isTablet ? 32 : 28,
                    height: isTablet ? 32 : 28,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Color(0xFF0656A0),
                        size: isTablet ? 18 : 16,
                      ),
                      onPressed: () => _editField(field),
                      splashRadius: isTablet ? 20 : 16,
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: -6,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              color: Colors.white,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0656A0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateField() {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 14,
              vertical: isTablet ? 8 : 6,
            ),
            constraints: BoxConstraints(
              minHeight: isTablet ? 40 : 36,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: InkWell(
              onTap: _showStatePicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _state,
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: isTablet ? 32 : 28,
                    height: isTablet ? 32 : 28,
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: isTablet ? 14 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -6,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              color: Colors.white,
              child: Text(
                'State',
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0656A0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOptions() {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final double avatarRadius = isTablet ? 150 : 60;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                child: ClipOval(
                  child: _useRandomAvatar
                      ? RandomAvatar(
                    _avatarString ?? 'default',
                    height: avatarRadius * 2,
                    width: avatarRadius * 2,
                  )
                      : _imageFile != null
                      ? Image.file(
                    _imageFile!,
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.person, size: avatarRadius),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: isTablet ? 35 : 20,
                  backgroundColor: Color(0xFF0656A0),
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: isTablet ? 30 : 18,
                    ),
                    onSelected: (String choice) {
                      if (choice == 'gallery') {
                        _pickImage();
                      } else if (choice == 'avatar') {
                        _showAvatarSelectionDialog();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'gallery',
                        child: ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choose Photo'),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'avatar',
                        child: ListTile(
                          leading: Icon(Icons.face),
                          title: Text('Choose Avatar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            'Click the edit button to choose a profile picture',
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final containerWidth = isTablet
        ? (MediaQuery.of(context).size.width * 0.5) * 0.9
        : MediaQuery.of(context).size.width * 0.9;

    return Column(
      children: [
        Container(
          width: containerWidth,
          margin: EdgeInsets.only(bottom: 8, left: 12),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Details',
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0656A0),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Feel free to edit your profile details at any time to keep your information up-to-date!',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        Container(
          width: containerWidth,
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _buildProfileField('Name', _name, 'name'),
              _buildProfileField('Email', _email, 'email', isEditable: false),
              _buildProfileField(
                  'Phone Number', _phoneNumber, 'phoneNumber',
                  isEditable: false),
              _buildProfileField('Date of Birth', _age, 'age'),
              _buildProfileField('Address 1', _address1, 'address1'),
              _buildProfileField('Address 2', _address2, 'address2'),
              _buildProfileField('Address 3', _address3, 'address3'),
              _buildProfileField('Address 4', _address4, 'address4'),
              _buildProfileField('Zip Code', _zipCode, 'zipCode'),
              _buildStateField(),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: containerWidth,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _resetAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _resetAnimation.value,
                    child: ElevatedButton(
                      onPressed: _handleResetPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 14,
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AnimatedBuilder(
                  animation: _saveAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _saveAnimation.value,
                    child: ElevatedButton(
                      onPressed: _handleSavePress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0656A0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 14,
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: Center(child: _buildAvatarOptions()),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildUserInfo(),
                      SizedBox(height: 24),
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

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          SizedBox(height: 160, child: _buildAvatarOptions()),
          const SizedBox(height: 24),
          _buildUserInfo(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  void _showAvatarSelectionDialog() {
    final isTablet = MediaQuery.of(context).size.width > 600;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  maxWidth:
                  MediaQuery.of(context).size.width * (isTablet ? 0.6 : 0.9),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: Text(
                        'Choose an Avatar',
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 24 : 16),
                        child: GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 4 : 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: isTablet ? 16 : 10,
                            mainAxisSpacing: isTablet ? 16 : 10,
                          ),
                          shrinkWrap: true,
                          itemCount: _randomSeeds.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _avatarString = _randomSeeds[index];
                                  _useRandomAvatar = true;
                                  _imageFile = null; // Clear the image file
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF0656A0),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(isTablet ? 12 : 8),
                                child: RandomAvatar(
                                  _randomSeeds[index],
                                  height: isTablet ? 80 : 60,
                                  width: isTablet ? 80 : 60,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _cancelAnimation,
                              builder: (context, child) => Transform.scale(
                                scale: _cancelAnimation.value,
                                child: TextButton(
                                  onPressed: _handleCancelPress,
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTablet ? 16 : 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          SizedBox(width: 16),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _generateAnimation,
                              builder: (context, child) => Transform.scale(
                                scale: _generateAnimation.value,
                                child: TextButton(
                                  onPressed: () =>
                                      _handleGeneratePress(setDialogState),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF0656A0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text(
                                    'Generate New Avatars', // Fixed typo here
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTablet ? 16 : 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Color(0xFF0656A0),
        onBackPressed: () => Navigator.pop(context),
        useLogo: false,
        titleText: 'My Profile',
      ),
      body: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
    );
  }
}