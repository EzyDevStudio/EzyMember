import 'package:flutter/material.dart';
import 'Vouchers_Page.dart';
import 'MembershipCards_page.dart';
import 'ProfilePage.dart';

class AnimatedIconBox extends StatefulWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final bool isTablet;

  const AnimatedIconBox({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    required this.isTablet,
  }) : super(key: key);

  @override
  State<AnimatedIconBox> createState() => _AnimatedIconBoxState();
}

class _AnimatedIconBoxState extends State<AnimatedIconBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
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
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: widget.isTablet ? null : 110,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(widget.isTablet ? 20 : 15),
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
                  widget.imagePath,
                  width: widget.isTablet ? 40 : 28,
                  height: widget.isTablet ? 40 : 28,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: widget.isTablet ? 15 : 8),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.isTablet ? 14 : 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Main_profile extends StatelessWidget {
  static const Color themeColor = Color(0xFF0656A0);

  const Main_profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0656A0),
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

  Widget _buildPhoneLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildProfilePicture(45),
                const SizedBox(height: 10),
                _buildNameText(20),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildPhoneMenuGrid(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenSize.width * 0.35,
            child: Container(
              height: screenSize.height - AppBar().preferredSize.height,
              decoration: BoxDecoration(
                color: themeColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfilePicture(70),
                  const SizedBox(height: 20),
                  _buildNameText(28),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildTabletMenuGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(double radius) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: radius - 2,
          backgroundColor: Colors.grey[100],
          child: Icon(
            Icons.person,
            size: radius,
            color: themeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNameText(double fontSize) {
    return Text(
      'name',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPhoneMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MENU',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildPhoneMenuRows(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MENU',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildMenuItems(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneMenuRows(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: AnimatedIconBox(
              imagePath: 'assets/Voucher.png',
              label: 'VOUCHER',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VouchersPage()),
              ),
              isTablet: false,
            )),
            const SizedBox(width: 20),
            Expanded(child: AnimatedIconBox(
              imagePath: 'assets/edit_info.png',
              label: 'EDIT PROFILE',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ),
              isTablet: false,
            )),
            const SizedBox(width: 20),
            Expanded(child: AnimatedIconBox(
              imagePath: 'assets/Working_profile.png',
              label: 'WORKING PROFILE',
              onTap: () {},
              isTablet: false,
            )),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: AnimatedIconBox(
              imagePath: 'assets/credit.png',
              label: 'CREDIT',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MembershipCards_page()),
              ),
              isTablet: false,
            )),
            const SizedBox(width: 20),
            Expanded(child: AnimatedIconBox(
              imagePath: 'assets/Refer.png',
              label: 'REFERRAL PROGRAM',
              onTap: () {},
              isTablet: false,
            )),
            const SizedBox(width: 20),
            Expanded(child: AnimatedIconBox(
              imagePath: 'assets/history.png',
              label: 'HISTORY',
              onTap: () {},
              isTablet: false,
            )),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      AnimatedIconBox(
        imagePath: 'assets/Voucher.png',
        label: 'VOUCHER',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VouchersPage()),
        ),
        isTablet: true,
      ),
      AnimatedIconBox(
        imagePath: 'assets/edit_info.png',
        label: 'EDIT PROFILE',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        ),
        isTablet: true,
      ),
      AnimatedIconBox(
        imagePath: 'assets/Working_profile.png',
        label: 'WORKING PROFILE',
        onTap: () {},
        isTablet: true,
      ),
      AnimatedIconBox(
        imagePath: 'assets/credit.png',
        label: 'CREDIT',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MembershipCards_page()),
        ),
        isTablet: true,
      ),
      AnimatedIconBox(
        imagePath: 'assets/Refer.png',
        label: 'REFERRAL PROGRAM',
        onTap: () {},
        isTablet: true,
      ),
      AnimatedIconBox(
        imagePath: 'assets/history.png',
        label: 'HISTORY',
        onTap: () {},
        isTablet: true,
      ),
    ];
  }
}