import 'package:flutter/material.dart';
import 'Vouchers_Page.dart';
import 'ProfilePage.dart';
import 'ReferralPage.dart';
import 'CreditPage.dart';
import 'TransactionHistoryPage.dart';
import 'package:ezymember/Working_Profile.dart';

class Main_profile extends StatelessWidget {
  static const Color themeColor = Color(0xFF0656A0);

  // Define image sizes here - just change these numbers
  static const double PHONE_IMAGE_SIZE = 200.0;  // Change this value for phone
  static const double TABLET_IMAGE_SIZE = 400.0; // Change this value for tablet

  const Main_profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/imin_display_logo.png',
          color: Colors.white,
          height: 20,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildTabletLayout(context);
          }
          return _buildPhoneLayout(context);
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced menu item specifically for tablet
  Widget _buildEnhancedMenuItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                icon,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            child: SizedBox(
              width: PHONE_IMAGE_SIZE,
              height: PHONE_IMAGE_SIZE,
              child: Image.asset(
                'assets/menu.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Added Menu Label Section
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.grid_view_rounded, color: themeColor, size: 16),
                ),
                const SizedBox(width: 15),
                const Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuItem(
                  icon: 'assets/Voucher.png',
                  label: 'VOUCHER',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VouchersPage()),
                  ),
                ),
                _buildMenuItem(
                  icon: 'assets/edit_info.png',
                  label: 'EDIT PROFILE',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  ),
                ),
                _buildMenuItem(
                  icon: 'assets/Working_profile.png',
                  label: 'WORKING PROFILE',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Working_Profile()),
                  ),
                ),
                _buildMenuItem(
                  icon: 'assets/credit.png',
                  label: 'CREDIT',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreditPage()),
                  ),
                ),
                _buildMenuItem(
                  icon: 'assets/Refer.png',
                  label: 'REFERRAL PROGRAM',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReferralPage()),
                  ),
                ),
                _buildMenuItem(
                  icon: 'assets/history.png',
                  label: 'HISTORY',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransactionHistoryPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        // Left side with image
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.03),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: SizedBox(
                width: TABLET_IMAGE_SIZE,
                height: TABLET_IMAGE_SIZE,
                child: Image.asset(
                  'assets/menu.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        // Right side with enhanced grid layout
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 30),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.grid_view_rounded, color: themeColor, size: 24),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'MENU',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 30,
                        childAspectRatio: 1.2,
                        children: [
                          _buildEnhancedMenuItem(
                            icon: 'assets/Voucher.png',
                            label: 'VOUCHER',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VouchersPage()),
                            ),
                          ),
                          _buildEnhancedMenuItem(
                            icon: 'assets/edit_info.png',
                            label: 'EDIT PROFILE',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            ),
                          ),
                          _buildEnhancedMenuItem(
                            icon: 'assets/Working_profile.png',
                            label: 'WORKING PROFILE',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Working_Profile()),
                            ),
                          ),
                          _buildEnhancedMenuItem(
                            icon: 'assets/credit.png',
                            label: 'CREDIT',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreditPage()),
                            ),
                          ),
                          _buildEnhancedMenuItem(
                            icon: 'assets/Refer.png',
                            label: 'REFERRAL PROGRAM',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReferralPage()),
                            ),
                          ),
                          _buildEnhancedMenuItem(
                            icon: 'assets/history.png',
                            label: 'HISTORY',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TransactionHistoryPage()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}