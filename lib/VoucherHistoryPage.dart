import 'package:flutter/material.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'Vouchers_Page.dart';

class VoucherHistoryPage extends StatefulWidget {
  const VoucherHistoryPage({super.key});

  @override
  State<VoucherHistoryPage> createState() => _VoucherHistoryPageState();
}

class _VoucherHistoryPageState extends State<VoucherHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const Color themeColor = Color(0xFF0656A0);

  // Controllers and filter states
  Set<String> _selectedCompanies = {};
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectStartDate() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.white,
        child: IOSStyleDatePicker(
          initialDate: _startDate,
          onDateSelected: (date) {
            setState(() {
              _startDate = date;
              if (_endDate == null || _endDate!.isBefore(date)) {
                _endDate = date;
              }
            });
          },
        ),
      ),
    );
  }

  void _selectEndDate() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.white,
        child: IOSStyleDatePicker(
          initialDate: _endDate ?? _startDate,
          onDateSelected: (date) {
            setState(() {
              _endDate = date;
            });
          },
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCompanies.clear();
      _startDate = null;
      _endDate = null;
    });
  }

  void _showCompanyFilter() {
    showDialog(
      context: context,
      builder: (context) => CompanySearchDialog(
        onClose: () => Navigator.pop(context),
        selectedCompanies: _selectedCompanies,
        onCompaniesSelected: (companies) {
          setState(() {
            _selectedCompanies = companies;
          });
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    required bool isActive,
    Widget? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? themeColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(bool isTablet) {
    String startDateText = _startDate != null
        ? DateFormat('MMM d, y').format(_startDate!)
        : 'Start Date';

    String endDateText = _endDate != null
        ? DateFormat('MMM d, y').format(_endDate!)
        : 'End Date';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 8,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: _selectedCompanies.isEmpty
                        ? 'Select Companies'
                        : '${_selectedCompanies.length} Companies',
                    onTap: _showCompanyFilter,
                    isActive: _selectedCompanies.isNotEmpty,
                    icon: Icon(
                      Icons.business,
                      size: 16,
                      color: _selectedCompanies.isNotEmpty ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildFilterChip(
                    label: startDateText,
                    onTap: _selectStartDate,
                    isActive: _startDate != null,
                    icon: Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: _startDate != null ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildFilterChip(
                    label: endDateText,
                    onTap: _selectEndDate,
                    isActive: _endDate != null,
                    icon: Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: _endDate != null ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (_selectedCompanies.isNotEmpty ||
                      _startDate != null ||
                      _endDate != null) ...[
                    SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Clear All',
                      onTap: _clearFilters,
                      isActive: false,
                      icon: Icon(
                        Icons.clear,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _filterVouchers(
      List<Map<String, String>> vouchers,
      bool isRedeemed,
      ) {
    return vouchers.where((voucher) {
      // Company filter
      if (_selectedCompanies.isNotEmpty &&
          !_selectedCompanies.contains(voucher['companyName'])) {
        return false;
      }

      // Date filter
      if (_startDate != null && _endDate != null) {
        final dateStr = isRedeemed
            ? voucher['redeemedDate']!
            : voucher['expiredDate']!;
        final date = DateFormat('dd MMM yyyy').parse(dateStr);
        if (date.isBefore(_startDate!) || date.isAfter(_endDate!)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Widget _buildVoucherList({
    required List<Map<String, String>> vouchers,
    required bool isRedeemed,
    required bool isTablet,
    required double maxWidth,
  }) {
    if (vouchers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isRedeemed ? Icons.check_circle_outline : Icons.timer_off_outlined,
              size: isTablet ? 64 : 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No ${isRedeemed ? 'redeemed' : 'expired'} vouchers',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final voucher = vouchers[index];
        return Align(
          alignment: Alignment.center,
          child: Container(
            width: isTablet ? maxWidth * 0.5 : maxWidth - 35,
            margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            isRedeemed ? Icons.check_circle : Icons.timer_off,
                            size: isTablet ? 20 : 16,
                            color: isRedeemed ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'From ${voucher['companyName']!}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            isRedeemed
                                ? 'Redeemed on ${voucher['redeemedDate']}'
                                : 'Expired on ${voucher['expiredDate']}',
                            style: TextStyle(
                              color: isRedeemed ? Colors.green : Colors.red,
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: isTablet ? 150 : 135,
                      child: CustomCouponCard(
                        discount: voucher['discount']!,
                        code: voucher['code']!,
                        validTill: isRedeemed
                            ? 'Redeemed on ${voucher['redeemedDate']}'
                            : 'Expired on ${voucher['expiredDate']}',
                        onCopyPressed: null,
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Positioned(
                        right: 40.0,
                        bottom: 30.0,
                        child: Image.asset(
                          isRedeemed ? 'assets/redeemed.png' : 'assets/expired.png',
                          width: isTablet ? 80 : 50,
                          height: isTablet ? 80 : 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;
      final isTablet = maxWidth > 600;

      final List<Map<String, String>> redeemedVouchers = [
        {
          'companyName': 'Nike',
          'discount': '23%',
          'code': 'FREESALES',
          'redeemedDate': '15 Jan 2024',
        },
        {
          'companyName': 'Adidas',
          'discount': '15%',
          'code': 'ADIDAYS',
          'redeemedDate': '10 Jan 2024',
        },
      ];

      final List<Map<String, String>> expiredVouchers = [
        {
          'companyName': 'Puma',
          'discount': '30%',
          'code': 'PUMA30',
          'expiredDate': '01 Jan 2024',
        },
        {
          'companyName': 'Reebok',
          'discount': '25%',
          'code': 'REEBOK25',
          'expiredDate': '31 Dec 2023',
        },
      ];

      return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 0,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
    onPressed: () => Navigator.pop(context),
    ),
    title: Text(
    'Voucher History',
    style: TextStyle(
    color: Colors.white,
    fontSize: isTablet ? 24 : 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    centerTitle: true,
    bottom: PreferredSize(
    preferredSize: Size.fromHeight(isTablet ? 80 : 65),
    child: Column(
    children: [
    Container(
    margin: EdgeInsets.symmetric(
    horizontal: isTablet ? 24 : 16,
    vertical: isTablet ? 12 : 8,
    ),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
    ),
    child: TabBar(
    controller: _tabController,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    ),
    labelColor: themeColor,
    unselectedLabelColor: Colors.white,
    labelStyle: TextStyle(
    fontSize: isTablet ? 16 : 14,
    fontWeight: FontWeight.bold,
    ),
    padding: EdgeInsets.all(4),
    tabs: [
    Tab(
    height: isTablet ? 46 : 36,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.check_circle_outline, size: isTablet ? 24 : 20),
    SizedBox(width: 8),
    Text('Redeemed'),
    ],
    ),
    ),
    Tab(
    height: isTablet ? 46 : 36,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.timer_off_outlined, size: isTablet ? 24 : 20),
    SizedBox(width: 8),
    Text('Expired'),
    ],
    ),
    )],
    ),
    ),
      Container(height: 1, color: themeColor),
    ],
    ),
    ),
          ),
        body: Column(
          children: [
            _buildFiltersSection(isTablet),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVoucherList(
                    vouchers: _filterVouchers(redeemedVouchers, true),
                    isRedeemed: true,
                    isTablet: isTablet,
                    maxWidth: maxWidth,
                  ),
                  _buildVoucherList(
                    vouchers: _filterVouchers(expiredVouchers, false),
                    isRedeemed: false,
                    isTablet: isTablet,
                    maxWidth: maxWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}