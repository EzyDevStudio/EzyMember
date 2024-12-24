import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import 'PromoTimer.dart';

// Utility class for responsive sizing
class ResponsiveSize {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // Further reduced base sizes for tablets
  static double baseSpacing(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.015 : 0.04);
  }

  static double basePadding(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.012 : 0.03);
  }

  // Significantly reduced font sizes for tablets
  static double h1(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.028 : 0.06);
  }

  static double h2(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.024 : 0.05);
  }

  static double h3(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.02 : 0.04);
  }

  static double body(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.016 : 0.035);
  }

  static double caption(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.014 : 0.03);
  }

  // Reduced icon sizes for tablets
  static double icon(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.025 : 0.06);
  }

  static double smallIcon(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.02 : 0.04);
  }

  // Reduced avatar size for tablets
  static double avatar(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.06 : 0.12);
  }

  // Updated constraints for tablets
  static double maxWidth(double value) => value.clamp(0, 800.0);
  static double maxFontSize(double value) {
    return value.clamp(12, 24.0); // Further reduced maximum font size
  }
  static double maxIconSize(double value) {
    return value.clamp(16, 32.0); // Further reduced maximum icon size
  }
  static double maxAvatarSize(double value) {
    return value.clamp(40, 64.0); // Further reduced maximum avatar size
  }
}

class PromotionDetailsPage extends StatefulWidget {
  final Map<String, String> promotion;
  final bool isTablet;

  const PromotionDetailsPage({
    Key? key,
    required this.promotion,
    required this.isTablet,
  }) : super(key: key);

  @override
  State<PromotionDetailsPage> createState() => _PromotionDetailsPageState();
}

class _PromotionDetailsPageState extends State<PromotionDetailsPage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorTween;
  bool _isAppBarTransparent = true;
  final Color brandColor = const Color(0xFF0656A0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _colorTween = ColorTween(
      begin: Colors.transparent,
      end: brandColor,
    ).animate(_colorAnimationController);

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.offset > ResponsiveSize.screenHeight(context) * 0.1 && _isAppBarTransparent) {
      setState(() => _isAppBarTransparent = false);
      _colorAnimationController.forward();
    } else if (_scrollController.offset <= ResponsiveSize.screenHeight(context) * 0.1 && !_isAppBarTransparent) {
      setState(() => _isAppBarTransparent = true);
      _colorAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double padding = ResponsiveSize.basePadding(context);
        final bool isLargeScreen = constraints.maxWidth > 600;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSliverAppBar(),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.maxWidth(padding),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPromotionHeader(isLargeScreen),
                          _buildTimerSection(isLargeScreen),
                          _buildDescriptionSection(isLargeScreen),
                          _buildTermsSection(isLargeScreen),
                          _buildLocationSection(isLargeScreen),
                          SizedBox(
                            height: ResponsiveSize.screenHeight(context) * 0.15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildFloatingAppBar(),
              _buildBottomButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: ResponsiveSize.screenHeight(context) * 0.4,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'promo-${widget.promotion['title']}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.promotion['image']!,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingAppBar() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = kToolbarHeight + statusBarHeight;

    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) {
        return Container(
          height: appBarHeight,
          decoration: BoxDecoration(
            color: _colorTween.value,
          ),
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: ResponsiveSize.maxIconSize(
                    ResponsiveSize.smallIcon(context),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: ResponsiveSize.maxIconSize(
                    ResponsiveSize.smallIcon(context),
                  ),
                ),
                onPressed: () => Share.share('Check out this amazing offer!'),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: ResponsiveSize.maxIconSize(
                    ResponsiveSize.smallIcon(context),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromotionHeader(bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.promotion['title']!,
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(
                isLargeScreen ? ResponsiveSize.h1(context) : ResponsiveSize.h2(context),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.baseSpacing(context) * 0.5),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.baseSpacing(context) * 0.5,
                  vertical: ResponsiveSize.baseSpacing(context) * 0.25,
                ),
                decoration: BoxDecoration(
                  color: brandColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LIMITED TIME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveSize.maxFontSize(
                      ResponsiveSize.caption(context),
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveSize.baseSpacing(context) * 0.5),
              Text(
                'Verified Offer',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: ResponsiveSize.maxFontSize(
                    ResponsiveSize.body(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection(bool isLargeScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.baseSpacing(context),
      ),
      padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: brandColor,
            size: ResponsiveSize.maxIconSize(ResponsiveSize.icon(context)),
          ),
          SizedBox(width: ResponsiveSize.baseSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Expires In',
                  style: TextStyle(
                    fontSize: ResponsiveSize.maxFontSize(
                      ResponsiveSize.caption(context),
                    ),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: ResponsiveSize.baseSpacing(context) * 0.25),
                PromoTimer(
                  endTime: widget.promotion['time']!,
                  fontSize: ResponsiveSize.maxFontSize(
                    ResponsiveSize.body(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Offer',
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(
                isLargeScreen ? ResponsiveSize.h2(context) : ResponsiveSize.h3(context),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.baseSpacing(context)),
          Text(
            widget.promotion['description']!,
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(
                ResponsiveSize.body(context),
              ),
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(
                isLargeScreen ? ResponsiveSize.h2(context) : ResponsiveSize.h3(context),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.baseSpacing(context)),
          _buildTermItem('Valid until ${DateFormat('dd MMM yyyy').format(DateTime.now().add(const Duration(days: 7)))}'),
          _buildTermItem('Cannot be combined with other offers'),
          _buildTermItem('Valid for all payment methods'),
          _buildTermItem('Subject to availability'),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.baseSpacing(context) * 0.25,
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: ResponsiveSize.maxIconSize(ResponsiveSize.smallIcon(context)),
            color: brandColor,
          ),
          SizedBox(width: ResponsiveSize.baseSpacing(context) * 0.5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveSize.maxFontSize(
                  ResponsiveSize.body(context),
                ),
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Offered By',
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(
                isLargeScreen ? ResponsiveSize.h2(context) : ResponsiveSize.h3(context),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.baseSpacing(context)),
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveSize.maxAvatarSize(
                  ResponsiveSize.avatar(context),
                ) / 2,
                backgroundImage: AssetImage(
                  widget.promotion['companyLogo'] ?? widget.promotion['image']!,
                ),
              ),
              SizedBox(width: ResponsiveSize.baseSpacing(context)),
              Text(
                widget.promotion['company'] ?? 'Company Name',
                style: TextStyle(
                  fontSize: ResponsiveSize.maxFontSize(
                    ResponsiveSize.body(context),
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context)),
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveSize.maxWidth(
                ResponsiveSize.screenWidth(context) * 0.9,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.baseSpacing(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Redeem Offer',
                style: TextStyle(
                  fontSize: ResponsiveSize.maxFontSize(
                    ResponsiveSize.h3(context),
                  ),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}