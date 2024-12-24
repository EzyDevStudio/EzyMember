import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'AboutPage.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final TextEditingController _referralController = TextEditingController();
  static const Color themeColor = Color(0xFF0656A0);
  final String myReferralCode = "USER123";
  bool _isSubmitting = false;

  // Methods for responsive sizing
  double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  double getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return baseSize * 1.3; // 30% larger for tablets
    }
    return baseSize;
  }

  double getResponsivePadding(BuildContext context, double basePadding) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return basePadding * 1.5;
    }
    return basePadding;
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: myReferralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Referral code copied to clipboard'),
        backgroundColor: themeColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _shareReferralCode() async {
    try {
      await Share.share(
        'Join me on our app! Use my referral code: $myReferralCode to get special rewards! 🎁',
        subject: 'Check out this amazing app!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to share. Please try again.'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _submitReferralCode() async {
    if (_referralController.text.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Referral code submitted successfully!'),
          backgroundColor: themeColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final basePadding = getResponsivePadding(context, 24.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        backgroundColor: themeColor,
        titleWidget: Text(
          'Referral Program',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isTablet) {
            // Tablet Layout
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 700, // Maximum width for tablet layout
                  ),
                  child: buildContent(context, isTablet, basePadding),
                ),
              ),
            );
          } else {
            // Phone Layout
            return SingleChildScrollView(
              child: buildContent(context, isTablet, basePadding),
            );
          }
        },
      ),
    );
  }

  Widget buildContent(BuildContext context, bool isTablet, double basePadding) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isTablet ? 40 : 30),
              bottomRight: Radius.circular(isTablet ? 40 : 30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              basePadding,
              basePadding * 0.8,
              basePadding,
              basePadding * 1.6,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: isTablet ? 40 : 30,
                  ),
                ),
                SizedBox(width: isTablet ? 24 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invite Friends & Earn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        'Get special rewards for every friend who joins',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: getResponsiveFontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, isTablet ? -35 : -25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: basePadding),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(basePadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Referral Code',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 30 : 20,
                      vertical: isTablet ? 24 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            myReferralCode,
                            style: TextStyle(
                              fontSize: getResponsiveFontSize(context, 24),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: themeColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _copyToClipboard,
                              icon: Icon(
                                Icons.copy_rounded,
                                size: isTablet ? 28 : 24,
                              ),
                              color: themeColor,
                              tooltip: 'Copy code',
                            ),
                            Container(
                              height: isTablet ? 32 : 24,
                              width: 1,
                              color: Colors.grey.withOpacity(0.3),
                              margin: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                            ),
                            IconButton(
                              onPressed: _shareReferralCode,
                              icon: Icon(
                                Icons.share_rounded,
                                size: isTablet ? 28 : 24,
                              ),
                              color: themeColor,
                              tooltip: 'Share code',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 48 : 32),
                  Text(
                    'Enter Friend\'s Code',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  TextField(
                    controller: _referralController,
                    style: TextStyle(fontSize: getResponsiveFontSize(context, 16)),
                    decoration: InputDecoration(
                      hintText: 'Enter referral code',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: getResponsiveFontSize(context, 15),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                        borderSide: const BorderSide(
                          color: themeColor,
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person_add_rounded,
                        color: themeColor,
                        size: isTablet ? 28 : 24,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 20 : 16,
                        horizontal: isTablet ? 24 : 16,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 32 : 24),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 64 : 56,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReferralCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                        ),
                        elevation: 1,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 20 : 16,
                        ),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                        height: isTablet ? 24 : 20,
                        width: isTablet ? 24 : 20,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Submit Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}