import 'package:ezymember/AboutPage.dart';
import 'package:ezymember/CustomPageRoute.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezymember/PromoTimer.dart';
import 'CompanyListingPage.dart';
import 'Company_profile.dart';
import 'CreditPage.dart';
import 'LoginPage.dart';
import 'Main_profile.dart';
import 'MembershipCards_page.dart';
import 'ProfilePage.dart';
import 'PromotionDetailsPage.dart';
import 'ReferralPage.dart';
import 'TransactionHistoryPage.dart';
import 'Vouchers_Page.dart';
import 'Working_Profile.dart';

class ResponsiveSize {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static double baseSpacing(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.015 : 0.04);
  }

  static double basePadding(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.012 : 0.03);
  }

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

  static double icon(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.025 : 0.06);
  }

  static double smallIcon(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.02 : 0.04);
  }

  static double avatar(BuildContext context) {
    final isTablet = screenWidth(context) > 600;
    return screenWidth(context) * (isTablet ? 0.06 : 0.12);
  }

  static double maxWidth(double value) => value.clamp(0, 800.0);
  static double maxFontSize(double value) => value.clamp(12, 24.0);
  static double maxIconSize(double value) => value.clamp(16, 32.0);
  static double maxAvatarSize(double value) => value.clamp(40, 64.0);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final Color brandColor = const Color(0xFF0656A0);
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _promoTimer;
  Timer? _sliderTimer;

  final PageController _pageController = PageController();
  final PageController _promoOffersController = PageController(viewportFraction: 0.85);
  int _currentPromoPage = 0;
  int _currentPromoOffer = 0;

  final List<Map<String, String>> promoSlides = [
    {
      'image': 'assets/promo1.png',
      'title': 'Welcome to EzyMember',
      'subtitle': 'Discover amazing deals',
    },
    {
      'image': 'assets/promo2.png',
      'title': 'Exclusive Offers',
      'subtitle': 'Save more with our partners',
    },
    {
      'image': 'assets/promo3.png',
      'title': 'Premium Benefits',
      'subtitle': 'Unlock special rewards',
    },
  ];

  final List<Map<String, dynamic>> businessCategories = [
    {'icon': Icons.shopping_bag, 'label': 'RETAIL'},
    {'icon': Icons.restaurant, 'label': 'FOOD'},
    {'icon': Icons.local_hospital, 'label': 'HEALTH CARE'},
    {'icon': Icons.shopping_cart, 'label': 'GROCERY'},
    {'icon': Icons.sports_basketball, 'label': 'SPORTS'},
    {'icon': Icons.movie, 'label': 'FUN'},
    {'icon': Icons.hotel, 'label': 'HOTELS'},
    {'icon': Icons.more_horiz, 'label': 'SHOW MORE'},
  ];

  final List<Map<String, String>> promoOffers = [
    {
      'title': 'Weekend Sale!',
      'description': '50% off on all items',
      'time': '48:00:00',
      'image': 'assets/promo_offer1.png',
    },
    {
      'title': 'Flash Deal',
      'description': 'Buy 1 Get 1 Free',
      'time': '24:00:00',
      'image': 'assets/promo_offer2.png',
    },
    {
      'title': 'Members Day',
      'description': 'Extra 20% for members',
      'time': '72:00:00',
      'image': 'assets/promo_offer3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startPromoSlider();
    Future.delayed(const Duration(milliseconds: 500), _showPromoDialog);
  }

  void _setupAnimation() {
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  void _startPromoSlider() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPromoPage < promoSlides.length - 1) {
        _currentPromoPage++;
      } else {
        _currentPromoPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPromoPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      if (_currentPromoOffer < promoOffers.length - 1) {
        _currentPromoOffer++;
      } else {
        _currentPromoOffer = 0;
      }

      if (_promoOffersController.hasClients) {
        _promoOffersController.animateToPage(
          _currentPromoOffer,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  void _showPromoDialog() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('promoPopupShown') ?? false;

    if (!hasShown && mounted) {
      await prefs.setBool('promoPopupShown', true);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage('assets/promo_popup.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Special Offer!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: brandColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Get 20% off on your first purchase!\nLimited time offer.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Claim Offer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -10,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _sliderTimer?.cancel();
    _pageController.dispose();
    _promoOffersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPromoSlider(context),
            SizedBox(height: ResponsiveSize.baseSpacing(context) * 2),
            _buildCategoriesSection(context),
            _buildPromoOffersCarousel(context),
            _buildSuggestedCompanies(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(ResponsiveSize.screenHeight(context) * 0.08),
      child: AppBar(
        backgroundColor: brandColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: ResponsiveSize.maxIconSize(ResponsiveSize.icon(context)),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Image.asset(
          'assets/imin_display_logo.png',
          color: Colors.white,
          height: 70,
          width: 70,
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: ResponsiveSize.screenWidth(context) *
          (ResponsiveSize.screenWidth(context) > 600 ? 0.3 : 0.7),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              height: 120,
              decoration: BoxDecoration(color: brandColor),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveSize.maxAvatarSize(ResponsiveSize.avatar(context)),
                    backgroundImage: const AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Ahmed',
                    style: TextStyle(
                      fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.body(context)),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.credit_card,
              'My Cards',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MembershipCards_page()),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.card_giftcard,
              'Vouchers',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VouchersPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.account_balance_wallet,
              'My Credits',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreditPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.business,
              'Companies',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CompanyListingPage()),
              ),
            ),
            const Divider(),
            _buildDrawerItem(
              context,
              Icons.person,
              'Profile',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.work,
              'Working Profile',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Working_Profile()),
              ),
            ),
            const Divider(),
            _buildDrawerItem(
              context,
              Icons.history,
              'History',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.share,
              'Credit Referral Program',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReferralPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.settings,
              'Settings',
                  () {},
            ),
            const Divider(),
            _buildDrawerItem(
              context,
              Icons.info_outline,
              'About Us',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
                size: ResponsiveSize.maxIconSize(ResponsiveSize.smallIcon(context)),
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.body(context)),
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: brandColor,
        size: ResponsiveSize.maxIconSize(ResponsiveSize.smallIcon(context)),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.body(context))
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildPromoSlider(BuildContext context) {
    final double promoHeight = ResponsiveSize.screenWidth(context) > 600
        ? ResponsiveSize.screenHeight(context) * 0.65
        : ResponsiveSize.screenHeight(context) * 0.35;

    return Container(
      height: promoHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) => setState(() => _currentPromoPage = page),
            itemCount: promoSlides.length,
            itemBuilder: (context, index) => _buildPromoSlide(context, index),
          ),
          _buildPromoIndicators(context),
        ],
      ),
    );
  }

  Widget _buildPromoSlide(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(promoSlides[index]['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveSize.basePadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                promoSlides[index]['title']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.h1(context)),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveSize.baseSpacing(context)),
              Text(
                promoSlides[index]['subtitle']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.body(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPromoIndicators(BuildContext context) {
    return Positioned(
      bottom: ResponsiveSize.baseSpacing(context),
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          promoSlides.length,
              (index) => Container(
            margin: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.baseSpacing(context) * 0.25
            ),
            width: ResponsiveSize.baseSpacing(context) * 0.5,
            height: ResponsiveSize.baseSpacing(context) * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPromoPage == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    const int gridCrossAxisCount = 4;
    final bool isTablet = ResponsiveSize.screenWidth(context) > 600;

    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.basePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.h2(context)),
              fontWeight: FontWeight.bold,
              color: brandColor,
            ),
          ),
          SizedBox(height: ResponsiveSize.baseSpacing(context)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: gridCrossAxisCount,
            mainAxisSpacing: isTablet
                ? ResponsiveSize.baseSpacing(context) * 0.05
                : ResponsiveSize.baseSpacing(context) * 0.1,
            crossAxisSpacing: ResponsiveSize.baseSpacing(context),
            childAspectRatio: isTablet ? 2.0 : 1.0,
            children: businessCategories
                .map((category) => _buildCategoryItem(context, category))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Map<String, dynamic> category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveSize.basePadding(context)),
          decoration: BoxDecoration(
            color: brandColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
                ResponsiveSize.baseSpacing(context)
            ),
          ),
          child: Icon(
            category['icon'],
            color: brandColor,
            size: ResponsiveSize.maxIconSize(ResponsiveSize.smallIcon(context)),
          ),
        ),
        SizedBox(height: ResponsiveSize.baseSpacing(context) * 0.5),
        Text(
          category['label'],
          style: TextStyle(
            fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.caption(context)),
            fontWeight: FontWeight.w500,
            color: brandColor.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPromoOffersCarousel(BuildContext context) {
    final double carouselHeight = ResponsiveSize.screenWidth(context) > 600
        ? ResponsiveSize.screenHeight(context) * 0.6
        : ResponsiveSize.screenHeight(context) * 0.3;

    return Container(
      height: carouselHeight,
      child: PageView.builder(
        controller: _promoOffersController,
        onPageChanged: (int page) {
          setState(() => _currentPromoOffer = page);
        },
        itemCount: promoOffers.length,
        itemBuilder: (context, index) => _buildPromoOfferCard(context, index),
      ),
    );
  }

  Widget _buildPromoOfferCard(BuildContext context, int index) {
    final bool isTablet = ResponsiveSize.screenWidth(context) > 600;
    final double horizontalPadding = isTablet
        ? ResponsiveSize.basePadding(context) * 2
        : ResponsiveSize.basePadding(context);
    final double cardWidth = isTablet
        ? ResponsiveSize.screenWidth(context) * 0.65
        : ResponsiveSize.screenWidth(context) * 0.85;

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromotionDetailsPage(
                promotion: promoOffers[index],
                isTablet: isTablet,
              ),
            ),
          );
        },
        child: Hero(
          tag: 'promo-${promoOffers[index]['title']}',
          child: SizedBox(
            width: cardWidth,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: ResponsiveSize.basePadding(context),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveSize.baseSpacing(context)),
                gradient: LinearGradient(
                  colors: [brandColor, brandColor.withOpacity(0.8)],
                ),
                image: DecorationImage(
                  image: AssetImage(promoOffers[index]['image']!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(ResponsiveSize.basePadding(context) * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          promoOffers[index]['title']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.h2(context)),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.baseSpacing(context)),
                        Text(
                          promoOffers[index]['description']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.body(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: ResponsiveSize.baseSpacing(context),
                    right: ResponsiveSize.baseSpacing(context),
                    child: PromoTimer(
                      endTime: promoOffers[index]['time']!,
                      fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.caption(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedCompanies(BuildContext context) {
    final double cardWidth = ResponsiveSize.screenWidth(context) *
        (ResponsiveSize.screenWidth(context) > 600 ? 0.25 : 0.4);

    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.basePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested Companies',
            style: TextStyle(
              fontSize: ResponsiveSize.maxFontSize(ResponsiveSize.h2(context)),
              fontWeight: FontWeight.bold,
              color: brandColor,
            ),
          ),
          SizedBox(height: ResponsiveSize.baseSpacing(context)),
          SizedBox(
            height: ResponsiveSize.screenHeight(context) * 0.30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => _buildCompanyCard(context, index, cardWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, int index, double cardWidth) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final primaryColor = Theme.of(context).primaryColor;

    Widget contactInfoItem(IconData icon, String text) {
      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveSize.baseSpacing(context) * 0.25),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context) * 0.15),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveSize.baseSpacing(context) * 0.3),
              ),
              child: Icon(
                icon,
                size: ResponsiveSize.body(context) * 0.7,
                color: primaryColor,
              ),
            ),
            SizedBox(width: ResponsiveSize.baseSpacing(context) * 0.25),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: ResponsiveSize.body(context) * 0.85,
                  color: primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Create company data map
    final companyData = {
      'companyName': 'Very Long Company Name ${index + 1} That Might Need Multiple Lines To Display Properly',
      'location': 'Johor',
      'rating': '4.5',
      'category': 'Technology',
      'description': 'This is a sample company description.',
      'users': '1000',
      'foundedYear': '2020',
    };

    Widget contactInfo = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isTablet ? CrossAxisAlignment.start : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: ResponsiveSize.baseSpacing(context) * 0.4),
          width: double.infinity,
          child: Text(
            companyData['companyName']!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveSize.body(context) * 1.1,
              color: Colors.grey[900],
              letterSpacing: 0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: isTablet ? double.infinity : ResponsiveSize.screenWidth(context) * 0.7,
          ),
          child: contactInfoItem(Icons.location_on_outlined, companyData['location']!),
        ),
      ],
    );

    Widget companyLogo = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveSize.baseSpacing(context)),
        border: Border.all(color: Colors.grey.shade100),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsets.all(ResponsiveSize.baseSpacing(context) * 0.4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveSize.baseSpacing(context) * 0.5),
        child: Image.asset(
          'assets/logo.jpg',
          height: ResponsiveSize.screenHeight(context) * (isTablet ? 0.11 : 0.13),
          width: isTablet ? ResponsiveSize.screenWidth(context) * 0.14 : double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        context.pushCustomRoute(
          child: Company_profile(companyData: companyData),
          duration: 300,
        );
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: ResponsiveSize.basePadding(context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveSize.baseSpacing(context)),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveSize.basePadding(context) * 0.7),
          child: isTablet
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: contactInfo,
              ),
              SizedBox(width: ResponsiveSize.baseSpacing(context) * 0.4),
              Expanded(
                flex: 2,
                child: companyLogo,
              ),
            ],
          )
              : SizedBox(
            height: ResponsiveSize.screenHeight(context) * 0.28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                companyLogo,
                SizedBox(height: ResponsiveSize.baseSpacing(context) * 0.5),
                Expanded(
                  child: contactInfo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}