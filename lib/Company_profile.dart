import 'package:flutter/material.dart';
import 'dart:async';

// Custom AppBar Import
import 'package:ezymember/CustomAppBar.dart';
import 'package:ezymember/ProductDetailsPage.dart';



// Models
class Product {
  final String id;
  final String name;
  final String price;
  final String discountPrice;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    this.description = '',
  });
}

// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

enum DeviceType {
  phone,
  tablet,
}

class Company_profile extends StatefulWidget {
  final Map<String, dynamic> companyData;

  const Company_profile({super.key, required this.companyData});

  @override
  _Company_profileState createState() => _Company_profileState();
}

class _Company_profileState extends State<Company_profile> {
  bool _isExpanded = false;
  late Duration _timeUntilEnd;
  Timer? _timer;
  final Color themeColor = const Color(0xFF0656A0);

  // Sample products data
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Premium Coffee Maker',
      price: '\$299.99',
      discountPrice: '\$249.99',
      imageUrl: 'coffee_maker.jpg',
      description: 'High-end coffee maker with advanced brewing features',
    ),
    Product(
      id: '2',
      name: 'Smart Watch Pro',
      price: '\$199.99',
      discountPrice: '\$159.99',
      imageUrl: 'smart_watch.jpg',
      description: 'Advanced smartwatch with health monitoring',
    ),
    Product(
      id: '3',
      name: 'Wireless Earbuds',
      price: '\$149.99',
      discountPrice: '\$119.99',
      imageUrl: 'earbuds.jpg',
      description: 'Premium wireless earbuds with noise cancellation',
    ),
    Product(
      id: '4',
      name: 'Laptop Stand',
      price: '\$79.99',
      discountPrice: '\$59.99',
      imageUrl: 'laptop_stand.jpg',
      description: 'Ergonomic laptop stand with adjustable height',
    ),
    Product(
      id: '5',
      name: 'Mechanical Keyboard',
      price: '\$129.99',
      discountPrice: '\$99.99',
      imageUrl: 'keyboard.jpg',
      description: 'Professional mechanical keyboard with RGB lighting',
    ),
    Product(
      id: '6',
      name: 'Gaming Mouse',
      price: '\$89.99',
      discountPrice: '\$69.99',
      imageUrl: 'mouse.jpg',
      description: 'High-precision gaming mouse with customizable buttons',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timeUntilEnd = Duration(hours: 48);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeUntilEnd.inSeconds > 0) {
          _timeUntilEnd = _timeUntilEnd - Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  DeviceType _getDeviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= ResponsiveBreakpoints.tablet) {
      return DeviceType.tablet;
    }
    return DeviceType.phone;
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= ResponsiveBreakpoints.tablet) {
      return EdgeInsets.symmetric(horizontal: width * 0.1);
    }
    return EdgeInsets.symmetric(horizontal: 16);
  }

  double _getResponsiveSpacing(BuildContext context) {
    return _getDeviceType(context) == DeviceType.tablet ? 24.0 : 16.0;
  }

  @override
  Widget build(BuildContext context) {
    _getDeviceType(context);
    final responsivePadding = _getResponsivePadding(context);
    final spacing = _getResponsiveSpacing(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        backgroundColor: themeColor,
        showBackButton: true,
        useLogo: true,
        logoAssetPath: 'assets/imin_display_logo.png',
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: responsivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing),
              _buildResponsiveLayout(context),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final isTablet = deviceType == DeviceType.tablet;

    if (isTablet) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildCompanyOverview(),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildDescription(),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildStats(),
                    SizedBox(height: 16),
                    _buildBenefits(),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(), // Empty container for layout balance
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSpecialOfferSection(),
          SizedBox(height: 16),
          _buildResponsivePosterContainers(context),
        ],
      );
    } else {
      return Column(
        children: [
          _buildCompanyOverview(),
          SizedBox(height: 16),
          _buildDescription(),
          SizedBox(height: 16),
          _buildStats(),
          SizedBox(height: 16),
          _buildBenefits(),
          SizedBox(height: 16),
          _buildSpecialOfferSection(),
          SizedBox(height: 16),
          _buildResponsivePosterContainers(context),
        ],
      );
    }
  }

  Widget _buildCompanyOverview() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.business, color: themeColor, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.companyData['companyName']?.toUpperCase() ?? 'COMPANY NAME',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.companyData['category'] ?? 'UNCATEGORIZED',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orange, size: 20),
              SizedBox(width: 4),
              Text(
                '${widget.companyData['rating'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    String description = widget.companyData['description']?.toUpperCase() ?? 'Description not provided.';
    String displayedDescription = _isExpanded || description.length <= 100
        ? description
        : '${description.substring(0, 100)}...';

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            displayedDescription,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
          if (description.length > 100)
            TextButton(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: themeColor,
              ),
              child: Text(
                _isExpanded ? 'SHOW LESS' : 'READ MORE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.people_outline,
            '${widget.companyData['users'] ?? 0}',
            'USERS',
          ),
          _buildStatItem(
            Icons.location_on_outlined,
            widget.companyData['location'] ?? 'Unknown',
            'LOCATION',
          ),
          _buildStatItem(
            Icons.calendar_today_outlined,
            widget.companyData['foundedYear'] ?? 'N/A',
            'FOUNDED',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: themeColor, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefits() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MEMBERSHIP BENEFITS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBenefitItem(Icons.local_offer_outlined, 'Discounts'),
              _buildBenefitItem(Icons.card_giftcard_outlined, 'Rewards'),
              _buildBenefitItem(Icons.support_agent_outlined, '24/7 Support'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: themeColor, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOfferSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getDeviceType(context) == DeviceType.tablet ? 3 : 2;
        final childAspectRatio = _getDeviceType(context) == DeviceType.tablet ? 1.1 : 0.75;

        return Container(
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPECIAL OFFER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildCountdownTimer(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) => _buildProductCard(products[index]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    double originalPrice = double.parse(product.price.replaceAll('\$', ''));
    double discountPrice = double.parse(product.discountPrice.replaceAll('\$', ''));
    int discountPercentage = ((originalPrice - discountPrice) / originalPrice * 100).round();

    // Get device type for responsive sizing
    final isTablet = _getDeviceType(context) == DeviceType.tablet;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              themeColor: themeColor,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image container with gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.grey[100]!,
                          Colors.grey[50]!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey[400],
                        size: 32,
                      ),
                    ),
                  ),
                  // Responsive discount badge
                  Positioned(
                    top: isTablet ? 8 : 3,
                    left: isTablet ? 8 : 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 3,
                        vertical: isTablet ? 4 : 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: isTablet ? 4 : 2,
                            offset: Offset(0, isTablet ? 2 : 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            color: Colors.white,
                            size: isTablet ? 12 : 10,
                          ),
                          SizedBox(width: isTablet ? 4 : 2),
                          Text(
                            '$discountPercentage% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 12 : 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Hover effect overlay
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      splashColor: themeColor.withOpacity(0.1),
                      highlightColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.discountPrice,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: themeColor,
                          letterSpacing: -0.1,
                        ),
                      ),
                      Text(
                        product.price,
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildResponsivePosterContainers(BuildContext context) {
    final isTablet = _getDeviceType(context) == DeviceType.tablet;

    if (isTablet) {
      return Row(
        children: [
          Expanded(
            child: _buildSinglePosterContainer(),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSinglePosterContainer(),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildSinglePosterContainer(),
          SizedBox(height: 24),
          _buildSinglePosterContainer(),
        ],
      );
    }
  }

  Widget _buildSinglePosterContainer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic height based on device type
        final isTablet = _getDeviceType(context) == DeviceType.tablet;
        final containerHeight = isTablet ? 300.0 : 200.0; // Increased height for tablet

        return InkWell(
          onTap: () {
            // Add your image picker logic here
          },
          child: Container(
            height: containerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeColor.withOpacity(0.7),
                  themeColor.withOpacity(0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 8),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(8, 0),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  offset: Offset(-4, -4),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
              border: Border(
                right: BorderSide(color: themeColor.withOpacity(0.5), width: 2),
                bottom: BorderSide(color: themeColor.withOpacity(0.5), width: 2),
                top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                left: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
              ),
            ),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.05)
                ..rotateY(-0.05),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountdownTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeUnit(_timeUntilEnd.inHours.remainder(24), 'HOURS'),
        _buildTimeSeparator(),
        _buildTimeUnit(_timeUntilEnd.inMinutes.remainder(60), 'MIN'),
        _buildTimeSeparator(),
        _buildTimeUnit(_timeUntilEnd.inSeconds.remainder(60), 'SEC'),
      ],
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              color: themeColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: themeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Main app class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final companyData = {
      'companyName': 'Tech Solutions Inc',
      'category': 'Technology',
      'rating': '4.8',
      'description': 'Leading provider of innovative technology solutions for businesses and consumers. Specializing in software development, cloud computing, and digital transformation.',
      'users': '15000',
      'location': 'New York',
      'foundedYear': '2010',
    };

    return MaterialApp(
      title: 'Company Profile',
      theme: ThemeData(
        primaryColor: Color(0xFF0656A0),
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: Company_profile(companyData: companyData),
    );
  }
}