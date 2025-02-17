import 'package:ezymember/Company_profile.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flip_card/flip_card.dart';

import 'HomePage.dart';

class MembershipCards_page extends StatefulWidget {
  const MembershipCards_page({super.key});

  @override
  State<MembershipCards_page> createState() => _MembershipCards_pageState();
}

class _MembershipCards_pageState extends State<MembershipCards_page> {
  // Class level variables
  late double containerWidth;
  late double padding;
  late double spacing;
  final List<FlipCardController> flipCardControllers = [];

  // Sample data for multiple cards
  final List<Map<String, dynamic>> cardData = [
    {
      'memberId': 'MEM-2024-1234',
      'type': 'GOLD MEMBER',
      'points': 2500,
      'accountId': '1234567890',
      'status': 'Active',
      'renewalDate': '31 Dec 2024',
      'expiryDate': '31 Dec 2025',
      'gradient': const [
        Colors.yellow,
        Colors.yellow,
        Colors.yellow,
      ],
    },
    {
      'memberId': 'MEM-2024-5678',
      'type': 'PLATINUM MEMBER',
      'points': 5000,
      'accountId': '5678901234',
      'status': 'Active',
      'renewalDate': '30 Jun 2024',
      'expiryDate': '30 Jun 2025',
      'gradient': const [
        Colors.white,
        Colors.white,
        Colors.white,
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each card
    for (var i = 0; i < cardData.length; i++) {
      flipCardControllers.add(FlipCardController());
    }

    // Add hint animation after 1 second for the first card
    Future.delayed(const Duration(seconds: 1), () {
      flipCardControllers[0].hint(
        duration: const Duration(milliseconds: 800),
        total: const Duration(milliseconds: 100),
      );
    });
  }

  Widget _buildMembershipCard(
      BuildContext context, Map<String, dynamic> data, FlipCardController controller, bool isTablet) {
    final cardWidth = isTablet ? 600.0 : 350.0;
    final cardHeight = isTablet ? 300.0 : 200.0;
    final barcodeWidth = cardWidth - (padding * 4);

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: cardWidth,
          maxHeight: cardHeight,
        ),
        margin: EdgeInsets.symmetric(
          vertical: spacing * 0.5,
        ),
        child: FlipCard(
          controller: controller,
          direction: FlipDirection.HORIZONTAL,
          front: Stack(
            children: [
              // Base card with user's gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: data['gradient'],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              // Contrast overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              // Content
              Container(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: isTablet ? 60 : 35,
                          height: isTablet ? 60 : 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(isTablet ? 30 : 20),
                          ),
                          child: Center(
                            child: Text(
                              'LOGO',
                              style: TextStyle(
                                color: const Color(0xFF0656A0),
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 15 : 10,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 8 : 10,
                            vertical: isTablet ? 4 : 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.withOpacity(0.5)),
                          ),
                          child: Text(
                            data['status'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 8 : 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['memberId'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isTablet ? 16 : 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.stars,
                                  color: const Color(0xFFFFD700),
                                  size: isTablet ? 14 : 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  data['type'],
                                  style: TextStyle(
                                    color: const Color(0xFFFFD700),
                                    fontSize: isTablet ? 12 : 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data['points'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 20 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'POINTS',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: isTablet ? 12 : 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 8 : 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.event,
                                    color: Colors.white.withOpacity(0.7),
                                    size: isTablet ? 12 : 10,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Renewal: ${data['renewalDate']}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: isTablet ? 12 : 8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    color: Colors.white.withOpacity(0.7),
                                    size: isTablet ? 12 : 10,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Expires: ${data['expiryDate']}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: isTablet ? 12 : 8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _showQRDialog(context, data['accountId'], isTablet),
                              icon: Icon(
                                Icons.qr_code,
                                color: Colors.white.withOpacity(0.9),
                                size: isTablet ? 16 : 14,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: isTablet ? 30 : 35,
                                minHeight: isTablet ? 30 : 35,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Company_profile(
                                      companyData: {
                                        'companyName': 'Company Name',
                                        'description': 'Company Description',
                                        'rating': '4.5',
                                        'category': data['type'],
                                        'users': 1000,
                                        'location': 'Location',
                                        'foundedYear': '2020'
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white.withOpacity(0.9),
                                size: isTablet ? 16 : 14,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: isTablet ? 30 : 35,
                                minHeight: isTablet ? 30 : 35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          back: Stack(
            children: [
              // Base gradient container
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: data['gradient'],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              // Contrast overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              // Content
              Container(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Membership Barcode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 10),
                    Container(
                      padding: EdgeInsets.all(isTablet ? 8 : 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: data['accountId'],
                            drawText: false,
                            color: const Color(0xFF0656A0),
                            width: barcodeWidth,
                            height: isTablet ? 40 : 50,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['accountId'],
                            style: TextStyle(
                              fontSize: isTablet ? 10 : 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0656A0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 10),
                    Text(
                      'Tap card to flip',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: isTablet ? 8 : 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQRDialog(BuildContext context, String accountId, bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: accountId,
                  version: QrVersions.auto,
                  size: isTablet ? 300 : 200,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF0656A0),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF0656A0),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Account ID: $accountId',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0656A0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    containerWidth = isTablet ? 600.0 : 500.0;
    padding = isTablet ? 30.0 : 20.0;
    spacing = isTablet ? 30.0 : 20.0;

    final double headerHeight = isTablet ? 550.0 : 370.0;
    final double titleFontSize = isTablet ? 28.0 : 16.0;
    final double iconSize = isTablet ? 30.0 : 24.0;
    final double avatarRadius = isTablet ? 35.0 : 16.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: headerHeight,
                minHeight: 300,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0656A0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: avatarRadius * 1.2,
                              color: const Color(0xFF0656A0),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: spacing * 0.5),

                      // Barcode Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_week_rounded,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'My Barcode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? spacing * 0.3 : spacing * 0.1),

                      // Barcode section
                      Center(
                        child: Column(
                          children: [
                            // Barcode Container with Animation
                            AnimatedGradientBorder(
                              borderSize: 2,
                              glowSize: 10,
                              gradientColors: const [
                                Colors.transparent,
                                Color(0xFFFFD700),
                                Color(0xFFFFC125),
                                Color(0xFFFFD700),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: containerWidth,
                                padding: EdgeInsets.all(padding * 0.5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: isTablet ? 80 : 50,
                                      child: BarcodeWidget(
                                        barcode: Barcode.code128(),
                                        data: cardData[0]['accountId'],
                                        drawText: false,
                                        color: const Color(0xFF0656A0),
                                        width: containerWidth - (padding * 1),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cardData[0]['accountId'],
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: const Color(0xFF0656A0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // QR Code Button
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextButton.icon(
                                onPressed: () => _showQRDialog(
                                    context, cardData[0]['accountId'], isTablet),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'View QR Code',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
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
              ),
            ),

            // My Cards Title Section
            Padding(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                top: spacing,
                bottom: spacing * 0.5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card,
                    size: iconSize,
                    color: const Color(0xFF0656A0),
                  ),
                  SizedBox(width: spacing * 0.5),
                  Text(
                    'My Cards',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0656A0),
                    ),
                  ),
                ],
              ),
            ),

            // Cards List View
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cardData.length,
              itemBuilder: (context, index) {
                return _buildMembershipCard(
                  context,
                  cardData[index],
                  flipCardControllers[index],
                  isTablet,
                );
              },
            ),

            // White space at bottom
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}