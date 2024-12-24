import 'package:flutter/material.dart';

import 'AboutPage.dart';

const Color themeColor = Color(0xFF0656A0);

class ResponsiveBreakpoints {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 32.0;
    return 40.0;
  }
}

class ResponsiveSizes {
  static double getFontSize(BuildContext context, double baseSize) {
    if (ResponsiveBreakpoints.isMobile(context)) return baseSize;
    if (ResponsiveBreakpoints.isTablet(context)) return baseSize * 1.2;
    return baseSize * 1.4;
  }

  static double getIconSize(BuildContext context, double baseSize) {
    if (ResponsiveBreakpoints.isMobile(context)) return baseSize;
    if (ResponsiveBreakpoints.isTablet(context)) return baseSize * 1.2;
    return baseSize * 1.4;
  }
}

class CreditPage extends StatefulWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  bool _isAmountVisible = true;

  void _toggleAmountVisibility() {
    setState(() {
      _isAmountVisible = !_isAmountVisible;
    });
  }

  void _showTopUpDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: ResponsiveBreakpoints.isMobile(context) ? 0.75 : 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: TopUpSheet(scrollController: scrollController),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveBreakpoints.getPadding(context);
    final isTabletOrLarger = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
      backgroundColor: themeColor,
      titleWidget: Text(
        'My Credits',
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveBreakpoints.isTablet(context) ? 24 : 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              color: themeColor,
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSizes.getFontSize(context, 16),
                            ),
                          ),
                          SizedBox(width: padding * 0.4),
                          IconButton(
                            icon: Icon(
                              _isAmountVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                              size: ResponsiveSizes.getIconSize(context, 20),
                            ),
                            onPressed: _toggleAmountVisibility,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _showTopUpDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: themeColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 0.8,
                            vertical: padding * 0.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: ResponsiveSizes.getIconSize(context, 16),
                            ),
                            SizedBox(width: padding * 0.2),
                            Text(
                              'Top Up',
                              style: TextStyle(
                                fontSize:
                                ResponsiveSizes.getFontSize(context, 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding * 0.4),
                  AnimatedCrossFade(
                    firstChild: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '2,458.50',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSizes.getFontSize(context, 32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: padding * 0.2),
                        Text(
                          'RM',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveSizes.getFontSize(context, 20),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    secondChild: Text(
                      '••••••',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveSizes.getFontSize(context, 32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    crossFadeState: _isAmountVisible
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 200),
                  ),
                  SizedBox(height: padding),
                ],
              ),
            ),

            // Payment Options
            Padding(
              padding: EdgeInsets.all(padding),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: padding,
                    runSpacing: padding,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      _buildOptionButton(
                        context: context,
                        icon: Icons.qr_code_scanner,
                        label: 'Scan',
                        onTap: () {},
                        width: isTabletOrLarger
                            ? constraints.maxWidth / 4
                            : constraints.maxWidth / 3.5,
                      ),
                      _buildOptionButton(
                        context: context,
                        icon: Icons.payment,
                        label: 'Pay',
                        onTap: () {},
                        width: isTabletOrLarger
                            ? constraints.maxWidth / 4
                            : constraints.maxWidth / 3.5,
                      ),
                      _buildOptionButton(
                        context: context,
                        icon: Icons.swap_horiz,
                        label: 'Transfer',
                        onTap: () {},
                        width: isTabletOrLarger
                            ? constraints.maxWidth / 4
                            : constraints.maxWidth / 3.5,
                      ),
                    ],
                  );
                },
              ),
            ),

            // Transaction History
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: ResponsiveSizes.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: padding * 0.8),
                  _buildTransactionItem(
                    context,
                    'Top up Successful',
                    'Nov 15, 2024',
                    '+250.00',
                    Icons.arrow_downward,
                    Colors.green,
                  ),
                  _buildTransactionItem(
                    context,
                    'Payment received',
                    'Nov 14, 2024',
                    '+75.50',
                    Icons.arrow_downward,
                    Colors.green,
                  ),
                  _buildTransactionItem(
                    context,
                    'Top up deducted',
                    'Nov 13, 2024',
                    '-120.00',
                    Icons.arrow_upward,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    final padding = ResponsiveBreakpoints.getPadding(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.all(padding * 0.8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: ResponsiveSizes.getIconSize(context, 32),
              color: themeColor,
            ),
            SizedBox(height: padding * 0.4),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveSizes.getFontSize(context, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context,
      String title,
      String date,
      String amount,
      IconData icon,
      Color iconColor,
      ) {
    final padding = ResponsiveBreakpoints.getPadding(context);
    final isPositive = amount.startsWith('+');

    return Container(
      margin: EdgeInsets.only(bottom: padding * 0.6),
      padding: EdgeInsets.all(padding * 0.8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(padding * 0.4),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: ResponsiveSizes.getIconSize(context, 20),
            ),
          ),
          SizedBox(width: padding * 0.8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveSizes.getFontSize(context, 16),
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveSizes.getFontSize(context, 14),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveSizes.getFontSize(context, 16),
                ),
              ),
              SizedBox(width: padding * 0.1),
              Text(
                'RM',
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveSizes.getFontSize(context, 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopUpSheet extends StatelessWidget {
  final ScrollController scrollController;

  TopUpSheet({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final List<double> quickAmounts = [10, 20, 50, 100, 200, 500];
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveBreakpoints.getPadding(context);
    final isTabletOrLarger = MediaQuery.of(context).size.width >= 600;

    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Up Wallet',
                  style: TextStyle(
                    fontSize: ResponsiveSizes.getFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveSizes.getIconSize(context, 24),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: padding),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: ResponsiveSizes.getFontSize(context, 16),
              ),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                suffixText: 'RM',
                suffixStyle: TextStyle(
                  fontSize: ResponsiveSizes.getFontSize(context, 16),
                  color: themeColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.all(padding * 0.8),
              ),
            ),
            SizedBox(height: padding),
            Text(
              'Quick Amounts',
              style: TextStyle(
                fontSize: ResponsiveSizes.getFontSize(context, 16),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: padding * 0.6),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = isTabletOrLarger
                    ? (constraints.maxWidth - padding * 3) / 4
                    : (constraints.maxWidth - padding * 2) / 3;
                return Wrap(
                  spacing: padding * 0.4,
                  runSpacing: padding * 0.4,
                  children: quickAmounts.map((amount) => GestureDetector(
                    onTap: () {
                      _amountController.text = amount.toString();
                    },
                    child: Container(
                      width: itemWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: padding * 0.8,
                        vertical: padding * 0.4,
                      ),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            amount.toString(),
                            style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveSizes.getFontSize(context, 14),
                            ),
                          ),
                          SizedBox(width: padding * 0.2),
                          Text(
                            'RM',
                            style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveSizes.getFontSize(context, 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
            SizedBox(height: padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement top up logic here
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: EdgeInsets.symmetric(
                    vertical: padding * 0.8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm Top Up',
                  style: TextStyle(
                    fontSize: ResponsiveSizes.getFontSize(context, 16),
                  ),
                ),
              ),
            ),
            // Add extra padding for bottom safe area
            SizedBox(height: padding + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}