import 'package:flutter/material.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ezymember/VoucherHistoryPage.dart';

import 'AboutPage.dart';  // Import for navigation

class VouchersPage extends StatefulWidget {
  const VouchersPage({super.key});

  @override
  State<VouchersPage> createState() => _VouchersPageState();
}

// Close button widget
class CloseIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? size;

  const CloseIconButton({
    Key? key,
    required this.onPressed,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Container(
      width: isTablet ? 45 : 38,
      height: isTablet ? 45 : 38,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
          size: isTablet ? 38 : 16,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      ),
    );
  }
}

// QR Code Dialog
class QRCodeDialog extends StatelessWidget {
  final String couponCode;

  const QRCodeDialog({
    Key? key,
    required this.couponCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final scaleFactor = maxWidth > 600 ? 0.6 : 1.0;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              width: maxWidth * 0.8,
              color: Colors.grey[50],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CloseIconButton(
                        onPressed: () => Navigator.pop(context),
                        size: 24,
                      ),
                    ],
                  ),
                  QrImageView(
                    data: couponCode,
                    version: QrVersions.auto,
                    size: maxWidth * 0.5,
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
                  SizedBox(height: maxHeight * 0.03),
                  Text(
                    'Coupon Code: $couponCode',
                    style: TextStyle(
                      fontSize: maxWidth * 0.03 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0656A0),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: maxWidth * 0.03,
                        vertical: maxHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF0656A0),
                    ),
                    label: Text(
                      'Back to Vouchers',
                      style: TextStyle(
                        color: const Color(0xFF0656A0),
                        fontWeight: FontWeight.bold,
                        fontSize: maxWidth * 0.02 * scaleFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

// Custom Coupon Card
class CustomCouponCard extends StatelessWidget {
  final String discount;
  final String code;
  final String validTill;
  final VoidCallback? onCopyPressed;

  const CustomCouponCard({
    Key? key,
    required this.discount,
    required this.code,
    required this.validTill,
    this.onCopyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final isTablet = maxWidth > 600;
      final scaleFactor = isTablet ? 0.8 : 1.0;

      const Color primaryColor = Color(0xffcbf3f0);
      const Color secondaryColor = Color(0xff368f8b);

      return AnimatedTapWrapper(
        onTap: onCopyPressed,
        child: CouponCard(
          height: 150 * (isTablet ? 1.2 : 1.0),
          width: maxWidth * (isTablet ? 0.95 : 0.95),
          backgroundColor: primaryColor,
          curveAxis: Axis.vertical,
          firstChild: Container(
            decoration: const BoxDecoration(
              color: secondaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            discount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white54, height: 0),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'WINTER IS\nHERE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          secondChild: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16 * scaleFactor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Coupon Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 8 * scaleFactor),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    code,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20 * scaleFactor,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Valid Till - $validTill',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12 * scaleFactor,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// Animated Tap Wrapper
class AnimatedTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;
  final Duration duration;

  const AnimatedTapWrapper({
    Key? key,
    required this.child,
    this.onTap,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  State<AnimatedTapWrapper> createState() => _AnimatedTapWrapperState();
}

class _AnimatedTapWrapperState extends State<AnimatedTapWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

// iOS Style Date Picker
class IOSStyleDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const IOSStyleDatePicker({
    Key? key,
    this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<IOSStyleDatePicker> createState() => _IOSStyleDatePickerState();
}

class _IOSStyleDatePickerState extends State<IOSStyleDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(top: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  widget.onDateSelected(selectedDate);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              maximumDate: DateTime.now(),
              minimumYear: 2020,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VouchersPageState extends State<VouchersPage> {
  static const Color themeColor = Color(0xFF0656A0);
  Set<String> selectedCompanies = {};
  String? selectedCouponCode;

  final List<Map<String, dynamic>> companies = [
    {
      'name': 'Nike',
      'vouchers': [
        {
          'discount': '23%',
          'code': 'FREESALES',
          'validTill': '30 Jan 2022',
        }
      ]
    },
    {
      'name': 'Adidas',
      'vouchers': [
        {
          'discount': '15%',
          'code': 'ADIDAYS',
          'validTill': '28 Jan 2022',
        }
      ]
    },
    {
      'name': 'Puma',
      'vouchers': [
        {
          'discount': '20%',
          'code': 'PUMASALE',
          'validTill': '25 Jan 2022',
        }
      ]
    },
    {
      'name': 'Reebok',
      'vouchers': [
        {
          'discount': '25%',
          'code': 'REEBOKNOW',
          'validTill': '22 Jan 2022',
        }
      ]
    },
    {
      'name': 'Under Armour',
      'vouchers': [
        {
          'discount': '30%',
          'code': 'UASALE',
          'validTill': '28 Jan 2022',
        }
      ]
    },
  ];

  Widget _buildCompanyLogo({required bool isTablet}) {
    return Container(
      width: double.infinity,
      height: isTablet ? 60 : 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        'assets/logo.jpg',
        fit: BoxFit.contain,
      ),
    );
  }

  void _copyToClipboard(String code) {
    if (MediaQuery.of(context).size.width <= 600) {
      showDialog(
        context: context,
        builder: (context) => QRCodeDialog(couponCode: code),
      );
    } else {
      setState(() {
        selectedCouponCode = code;
      });
    }
  }

  void _showRedeemedVouchersDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VoucherHistoryPage()),
    );
  }

  void _showCompanySearchDialog() {
    showDialog(
      context: context,
      builder: (context) => CompanySearchDialog(
        onClose: () => Navigator.pop(context),
        selectedCompanies: selectedCompanies,
        onCompaniesSelected: (companies) {
          setState(() {
            selectedCompanies = companies;
          });
        },
      ),
    );
  }

  Widget _buildVouchersList(double maxWidth, double maxHeight, bool isTablet, double scaleFactor, double paddingScaleFactor) {
    if (selectedCompanies.isEmpty) {
      return Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Select companies to view vouchers',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: maxWidth * 0.025 * scaleFactor,
            ),
          ),
        ),
      );
    }

    List<Map<String, dynamic>> allVouchers = [];
    for (var companyName in selectedCompanies) {
      var company = companies.firstWhere((c) => c['name'] == companyName);
      var companyVouchers = List<Map<String, dynamic>>.from(company['vouchers']);
      companyVouchers.forEach((voucher) => voucher['companyName'] = companyName);
      allVouchers.addAll(companyVouchers);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: allVouchers.length,
      itemBuilder: (context, index) {
        final voucher = allVouchers[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: maxHeight * (isTablet ? 0.025 : 0.015) * scaleFactor,
            left: isTablet ? maxWidth * 0.00 : 0,
          ),
          child: Align(
            alignment: isTablet ? Alignment.centerLeft : Alignment.center,
            child: SizedBox(
              width: isTablet ? maxWidth * 0.9 : maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      'From ${voucher['companyName']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CustomCouponCard(
                    discount: voucher['discount'],
                    code: voucher['code'],
                    validTill: voucher['validTill'],
                    onCopyPressed: () => _copyToClipboard(voucher['code']),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCompanyItem(int index, double maxWidth, bool isTablet) {
    final company = companies[index];
    final isSelected = selectedCompanies.contains(company['name']);

    return Padding(
      padding: EdgeInsets.only(
        right: maxWidth * (isTablet ? 0.04 : 0.02),
        left: index == 0 ? maxWidth * (isTablet ? 0.04 : 0.02) : 0,
      ),
      child: SizedBox(
        width: isTablet ? 130 : 80,
        child: AnimatedTapWrapper(
          onTap: () {
            setState(() {
              if (selectedCompanies.contains(company['name'])) {
                selectedCompanies.remove(company['name']);
              } else {
                selectedCompanies.add(company['name']);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? themeColor : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: _buildCompanyLogo(
                      isTablet: isTablet,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    company['name'],
                    style: TextStyle(
                      color: isSelected ? themeColor : Colors.black87,
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, double maxWidth, double maxHeight, bool isTablet, double scaleFactor, double paddingScaleFactor) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(maxWidth * paddingScaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Select Company',
                    style: TextStyle(
                      fontSize: isTablet ? 23 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    AnimatedTapWrapper(
                      onTap: () {
                        setState(() {
                          selectedCompanies.clear();
                        });
                      },
                      child: TextButton(
                        onPressed: null,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                            horizontal: maxWidth * 0.02,
                            vertical: maxHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 16 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: maxWidth * 0.02),
                    AnimatedTapWrapper(
                      onTap: _showCompanySearchDialog,
                      child: TextButton(
                        onPressed: null,
                        style: TextButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: maxWidth * 0.02,
                            vertical: maxHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'See More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 16 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: isTablet ? 140 : 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  companies.length,
                      (index) => buildCompanyItem(index, maxWidth, isTablet),
                ),
              ),
            ),
          ),
          SizedBox(height: maxHeight * 0.02 * scaleFactor),
          Padding(
            padding: EdgeInsets.all(maxWidth * paddingScaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Available Vouchers',
                    style: TextStyle(
                      fontSize: isTablet ? 23 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedTapWrapper(
                  onTap: _showRedeemedVouchersDialog,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: isTablet ? 24 : 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: maxWidth,
              padding: EdgeInsets.symmetric(
                horizontal: maxWidth * paddingScaleFactor,
                vertical: maxHeight * (isTablet ? 0.03 : paddingScaleFactor),
              ),
              child: _buildVouchersList(
                maxWidth,
                maxHeight,
                isTablet,
                scaleFactor,
                paddingScaleFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightHalf(BuildContext context, double maxWidth, double maxHeight, double scaleFactor) {
    if (selectedCouponCode != null) {
      return Container(
        color: Colors.grey[50],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: selectedCouponCode!,
                version: QrVersions.auto,
                size: maxWidth * 0.6,
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
              SizedBox(height: maxHeight * 0.03),
              Text(
                'Coupon Code: $selectedCouponCode',
                style: TextStyle(
                  fontSize: maxWidth * 0.03 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0656A0),
                ),
              ),
              SizedBox(height: maxHeight * 0.02),
              AnimatedTapWrapper(
                onTap: () {
                  setState(() {
                    selectedCouponCode = null;
                  });
                },
                child: TextButton.icon(
                  onPressed: null,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(
                      horizontal: maxWidth * 0.03,
                      vertical: maxHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Back to Vouchers',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: maxWidth * 0.02 * scaleFactor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.grey[50],
        child: Center(
          child: Image.asset(
            'assets/vouchers.png',
            width: maxWidth * 0.8,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;
      final isTablet = maxWidth > 600;
      final scaleFactor = isTablet ? 0.6 : 1.0;
      final paddingScaleFactor = isTablet ? 0.02 : 0.03;

      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(
        backgroundColor: themeColor,
        titleWidget: Text(
          'Vouchers',
          style: TextStyle(
            color: Colors.white,
            fontSize: maxHeight * 0.04 * scaleFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
        body: SafeArea(
          child: Container(
            color: Colors.grey[50],
            child: isTablet
                ? Row(
              children: [
                Expanded(
                  child: _buildMainContent(
                    context,
                    maxWidth / 2,
                    maxHeight,
                    isTablet,
                    scaleFactor,
                    paddingScaleFactor,
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildRightHalf(
                    context,
                    maxWidth / 2,
                    maxHeight,
                    scaleFactor,
                  ),
                ),
              ],
            )
                : _buildMainContent(
              context,
              maxWidth,
              maxHeight,
              isTablet,
              scaleFactor,
              paddingScaleFactor,
            ),
          ),
        ),
      );
    });
  }
}

// CompanySearchDialog
class CompanySearchDialog extends StatefulWidget {
  final VoidCallback onClose;
  final Set<String> selectedCompanies;
  final Function(Set<String>) onCompaniesSelected;

  const CompanySearchDialog({
    Key? key,
    required this.onClose,
    required this.selectedCompanies,
    required this.onCompaniesSelected,
  }) : super(key: key);

  @override
  State<CompanySearchDialog> createState() => _CompanySearchDialogState();
}

class _CompanySearchDialogState extends State<CompanySearchDialog> {
  late TextEditingController _searchController;
  late Set<String> _localSelectedCompanies;
  List<Map<String, dynamic>> _filteredCompanies = [];

  final List<Map<String, dynamic>> _allCompanies = [
    {'name': 'Nike', 'vouchers': 3},
    {'name': 'Adidas', 'vouchers': 4},
    {'name': 'Puma', 'vouchers': 2},
    {'name': 'Reebok', 'vouchers': 5},
    {'name': 'Under Armour', 'vouchers': 3},
    {'name': 'New Balance', 'vouchers': 4},
    {'name': 'Asics', 'vouchers': 2},
    {'name': 'Fila', 'vouchers': 3},
    {'name': 'Converse', 'vouchers': 4},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCompanies = _allCompanies;
    _localSelectedCompanies = Set.from(widget.selectedCompanies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCompanies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCompanies = _allCompanies;
      } else {
        _filteredCompanies = _allCompanies
            .where((company) =>
            company['name'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectCompany(String companyName) {
    setState(() {
      if (_localSelectedCompanies.contains(companyName)) {
        _localSelectedCompanies.remove(companyName);
      } else {
        _localSelectedCompanies.add(companyName);
      }
      widget.onCompaniesSelected(_localSelectedCompanies);
    });
  }

  void _handleReset() {
    setState(() {
      _localSelectedCompanies.clear();
      widget.onCompaniesSelected(_localSelectedCompanies);
      _searchController.clear();
      _filteredCompanies = _allCompanies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;
      final isTablet = maxWidth > 600;
      final scaleFactor = isTablet ? 0.8 : 1.4;

      final crossAxisCount = isTablet ? 3 : 2;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(maxWidth * 0.02 * scaleFactor),
        ),
        child: Container(
          height: maxHeight * 0.8,
          width: maxWidth * (isTablet ? 0.7 : 0.9),
          padding: EdgeInsets.all(maxWidth * 0.03 * scaleFactor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Company',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      AnimatedTapWrapper(
                        onTap: _handleReset,
                        child: TextButton(
                          onPressed: null,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                              horizontal: maxWidth * 0.02,
                              vertical: maxHeight * 0.01,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: maxWidth * 0.02),
                      CloseIconButton(
                        onPressed: widget.onClose,
                        size: isTablet ? 28 : 26,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: maxHeight * 0.02 * scaleFactor),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(maxWidth * 0.015 * scaleFactor),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: maxWidth * 0.02 * scaleFactor,
                  vertical: maxHeight * 0.01 * scaleFactor,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterCompanies,
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                  decoration: InputDecoration(
                    hintText: 'Search company',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: isTablet ? 18 : 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: isTablet ? 28 : 24,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: maxHeight * 0.02 * scaleFactor),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: isTablet ? 0.85 : 0.8,
                    crossAxisSpacing: maxWidth * 0.03 * scaleFactor,
                    mainAxisSpacing: maxHeight * 0.02 * scaleFactor,
                  ),
                  itemCount: _filteredCompanies.length,
                  itemBuilder: (context, index) {
                    final company = _filteredCompanies[index];
                    final isSelected = _localSelectedCompanies.contains(company['name']);
                    return AnimatedTapWrapper(
                      onTap: () => _selectCompany(company['name']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(maxWidth * 0.02 * scaleFactor),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey[200]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: maxWidth * 0.02 * scaleFactor,
                              offset: Offset(0, maxHeight * 0.005 * scaleFactor),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/logo.jpg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    company['name'],
                                    style: TextStyle(
                                      fontSize: isTablet ? 22 : 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: maxHeight * 0.005 * scaleFactor),
                                  Text(
                                    '${company['vouchers']} Vouchers',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 18 : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}