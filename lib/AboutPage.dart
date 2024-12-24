import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About EzyMember',
      theme: ThemeData(
        primaryColor: const Color(0xFF0656A0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0656A0)),
      ),
      home: const AboutPage(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? titleWidget;
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.backgroundColor,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.titleWidget,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: elevation ?? 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      )
          : null,
      title: titleWidget ?? Image.asset(
        'assets/imin_display_logo.png',
        color: Colors.white,
        height: 20,
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  void _shareContact(String type, String contact) {
    Share.share('Contact $type: $contact', subject: 'EzyMember Support Contact');
  }

  void _shareAppInfo() {
    Share.share(
      'Check out EzyMember - Your all-in-one membership management solution! For support, contact us at support@easydevstudio.com',
      subject: 'EzyMember App Information',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: const Color(0xFF0656A0),
        titleWidget: const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareAppInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Logo & Header
            Container(
              height: 200, // Reduced height since we now have an AppBar
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0656A0),
                    Color(0xFF0656A0),
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'EzyMember',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rest of the content remains the same
            Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About EzyMember',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0656A0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'EzyMember is your complete membership management solution. Designed to simplify member tracking, engagement, and communication, our app helps organizations build stronger communities through efficient management tools.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(Icons.group, 'Member Management'),
                  _buildFeatureItem(Icons.card_membership, 'Digital Membership Cards'),
                  _buildFeatureItem(Icons.notifications_active, 'Instant Notifications'),
                  _buildFeatureItem(Icons.analytics, 'Membership Analytics'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0656A0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildContactItem(
                    Icons.email,
                    'Email Support',
                    'support@easydevstudio.com',
                        () => _shareContact('Email', 'support@easydevstudio.com'),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    Icons.phone,
                    'Technical Support',
                    '+60 7-123-4567',
                        () => _shareContact('Phone', '+60 7-123-4567'),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              color: const Color(0xFF0656A0),
              child: const Center(
                child: Text(
                  '© 2024 EzyMember. All rights reserved.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF0656A0),
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      IconData icon,
      String title,
      String detail,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF0656A0),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    detail,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.share,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}