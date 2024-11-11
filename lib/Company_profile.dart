import 'package:flutter/material.dart';
import 'dart:async';

class Company_profile extends StatefulWidget {
  final Map<String, dynamic> companyData;

  Company_profile({required this.companyData});

  @override
  _Company_profileState createState() => _Company_profileState();
}

class _Company_profileState extends State<Company_profile> {
  double _headerHeight = 200.0;
  bool _isExpanded = false;
  Duration _timeUntilEnd = Duration(hours: 48);
  Timer? _timer;

  // Define adjustable sizes
  late double profileImageSize;
  late double fontSizeLarge;
  late double fontSizeSmall;
  late double fontSizeDescription;
  late double fontSizeDescriptionText;
  late double iconSize;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    _setResponsiveSizes();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyData['companyName'] ?? 'Company Profile'),
        backgroundColor: const Color(0xFF0656A0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildProfileInfo(),
            _buildCompanyDescription(),
            _buildCompanyInfo(),
            _buildMembershipBenefits(),
            _buildPromotions(),
          ],
        ),
      ),
    );
  }

  void _setResponsiveSizes() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      profileImageSize = 40.0;
      fontSizeLarge = 18.0;
      fontSizeSmall = 12.0;
      fontSizeDescription = 13.0;
      fontSizeDescriptionText = 11.0;
      iconSize = 20.0;
    } else {
      profileImageSize = 70.0;
      fontSizeLarge = 30.0;
      fontSizeSmall = 14.0;
      fontSizeDescription = 17.0;
      fontSizeDescriptionText = 14.0;
      iconSize = 24.0;
    }
  }

  void _toggleHeaderHeight() {
    setState(() {
      _headerHeight = _headerHeight == 200.0 ? 300.0 : 200.0;
    });
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: _toggleHeaderHeight,
      child: Container(
        height: _headerHeight,
        color: const Color(0xFF0656A0),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.companyData['companyName']?.toUpperCase() ?? 'COMPANY NAME',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: profileImageSize / 2,
            backgroundColor: const Color(0xFF0656A0),
            child: Icon(Icons.business, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.companyData['companyName']?.toUpperCase() ?? 'COMPANY NAME',
                  style: TextStyle(
                    fontSize: fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0656A0),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: iconSize),
                    SizedBox(width: 4),
                    Text(
                      '${widget.companyData['rating'] ?? 'N/A'} • ${widget.companyData['category'] ?? 'UNCATEGORIZED'}',
                      style: TextStyle(
                        fontSize: fontSizeSmall,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0656A0),
                      ),
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

  Widget _buildCompanyDescription() {
    String description = widget.companyData['description']?.toUpperCase() ?? 'Description not provided.';
    String displayedDescription = _isExpanded || description.length <= 100
        ? description
        : '${description.substring(0, 100)}...';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMPANY DESCRIPTION',
            style: TextStyle(
              fontSize: fontSizeDescription,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0656A0),
            ),
          ),
          SizedBox(height: 8),
          Text(
            displayedDescription,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: fontSizeDescriptionText,
            ),
          ),
          if (description.length > 100)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  _isExpanded ? 'SHOW LESS' : 'READ MORE',
                  style: TextStyle(
                    color: const Color(0xFF0656A0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(Icons.group, '${widget.companyData['users'] ?? 0} Users'),
          _buildInfoItem(Icons.location_on, widget.companyData['location'] ?? 'Unknown'),
          _buildInfoItem(Icons.access_time, 'Since ${widget.companyData['foundedYear'] ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0656A0), size: iconSize),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSizeSmall,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0656A0),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMembershipBenefits() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MEMBERSHIP BENEFITS',
            style: TextStyle(
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0656A0),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBenefitItem(Icons.local_offer, 'Discounts'),
              _buildBenefitItem(Icons.card_giftcard, 'Rewards'),
              _buildBenefitItem(Icons.support, '24/7 Support'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0656A0), size: iconSize),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSizeSmall,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0656A0),
          ),
        ),
      ],
    );
  }

  Widget _buildPromotions() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROMOTIONS',
            style: TextStyle(
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0656A0),
            ),
          ),
          SizedBox(height: 16),
          _buildPromotionCard(
            'SPECIAL OFFER',
            _buildCountdownTimer(),
            const Color(0xFF0656A0),
          ),
          SizedBox(height: 16),
          _buildPromotionCard(
            'GET 20% OFF ON YOUR FIRST PURCHASE',
            Icon(Icons.card_giftcard, color: Colors.white, size: iconSize * 2),
            Colors.orange,
          ),
          SizedBox(height: 16),
          _buildPromotionCard(
            'FREE SHIPPING ON ORDERS OVER \$50',
            Icon(Icons.local_shipping, color: Colors.white, size: iconSize * 2),
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(String title, Widget content, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildCountdownTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeUnit(_timeUntilEnd.inHours.remainder(24), 'HOURS'),
        _buildTimeSeparator(),
        _buildTimeUnit(_timeUntilEnd.inMinutes.remainder(60), 'MINUTES'),
        _buildTimeSeparator(),
        _buildTimeUnit(_timeUntilEnd.inSeconds.remainder(60), 'SECONDS'),
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
              color: const Color(0xFF0656A0),
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF0656A0),
              fontSize: fontSizeSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSizeLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}