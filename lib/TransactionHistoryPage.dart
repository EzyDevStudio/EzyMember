import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class ResponsiveBreakpoints {
  static const double mobileSmall = 320;
  static const double mobileMedium = 375;
  static const double mobileLarge = 414;
  static const double tablet = 768;
  static const double laptop = 1024;
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;
  String selectedFilter = 'last7Days'; // Default filter
  DateTime? _startDate;
  DateTime? _endDate;

  // Custom color scheme
  final ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF0656A0),
    secondary: Color(0xFF0656A0),
    surface: Colors.white,
    background: Color(0xFFF8FAFC),
    error: Color(0xFFDC2626),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF1F2937),
    onBackground: Color(0xFF64748B),
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // Status colors
  final Color successColor = const Color(0xFF059669);
  final Color errorColor = const Color(0xFFDC2626);

  // Card shadow
  final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF1F2937).withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Sample transaction data
  final List<Map<String, dynamic>> allTransactions = [
    {
      'storeName': 'Store Alpha',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'points': 500,
      'action': 'earn',
      'counterNo': 'C001',
      'transactionId': '#TRX123456',
      'cashierName': 'John Doe'
    },
    {
      'storeName': 'Store Beta',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'points': 200,
      'action': 'redeem',
      'counterNo': 'C003',
      'transactionId': '#TRX123457',
      'cashierName': 'Jane Smith'
    },
    {
      'storeName': 'Store Gamma',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'points': 750,
      'action': 'earn',
      'counterNo': 'C002',
      'transactionId': '#TRX123458',
      'cashierName': 'Mike Johnson'
    },
    {
      'storeName': 'Store Delta',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'points': 300,
      'action': 'earn',
      'counterNo': 'C004',
      'transactionId': '#TRX123459',
      'cashierName': 'Sarah Wilson'
    },
    {
      'storeName': 'Store Epsilon',
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'points': 1000,
      'action': 'earn',
      'counterNo': 'C005',
      'transactionId': '#TRX123460',
      'cashierName': 'David Brown'
    },
  ];

  // Responsive sizing helper
  double getResponsiveSize(BuildContext context, double mobile, double tablet) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= ResponsiveBreakpoints.tablet) {
      return tablet;
    }
    return mobile;
  }

  // Responsive padding helper
  EdgeInsets getResponsivePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= ResponsiveBreakpoints.tablet) {
      return const EdgeInsets.all(24.0);
    } else if (screenWidth >= ResponsiveBreakpoints.mobileLarge) {
      return const EdgeInsets.all(16.0);
    }
    return const EdgeInsets.all(12.0);
  }

  List<Map<String, dynamic>> get filteredTransactions {
    final now = DateTime.now();
    switch (selectedFilter) {
      case 'last7Days':
        return allTransactions.where((transaction) {
          final transactionDate = transaction['date'] as DateTime;
          return now.difference(transactionDate).inDays <= 7;
        }).toList();
      case 'thisMonth':
        return allTransactions.where((transaction) {
          final transactionDate = transaction['date'] as DateTime;
          return transactionDate.year == now.year &&
              transactionDate.month == now.month;
        }).toList();
      case 'lastMonth':
        DateTime lastMonth = DateTime(now.year, now.month - 1);
        return allTransactions.where((transaction) {
          final transactionDate = transaction['date'] as DateTime;
          return transactionDate.year == lastMonth.year &&
              transactionDate.month == lastMonth.month;
        }).toList();
      case 'custom':
        if (_startDate != null && _endDate != null) {
          return allTransactions.where((transaction) {
            final transactionDate = transaction['date'] as DateTime;
            return transactionDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                transactionDate.isBefore(_endDate!.add(const Duration(days: 1)));
          }).toList();
        }
        return allTransactions;
      default:
        return allTransactions;
    }
  }

  Map<String, dynamic> get summaryStats {
    int earnedPoints = 0;
    int redeemedPoints = 0;

    for (var transaction in filteredTransactions) {
      if (transaction['action'] == 'earn') {
        earnedPoints += transaction['points'] as int;
      } else {
        redeemedPoints += transaction['points'] as int;
      }
    }

    return {
      'earned': earnedPoints,
      'redeemed': redeemedPoints,
      'balance': earnedPoints - redeemedPoints,
      'earnedTrend': _calculateTrend(earnedPoints),
      'redeemedTrend': _calculateTrend(redeemedPoints),
      'balanceTrend': _calculateTrend(earnedPoints - redeemedPoints),
    };
  }

  String _calculateTrend(int currentValue) {
    final trend = (currentValue * 0.1).toStringAsFixed(1);
    return currentValue >= 0 ? '+$trend%' : '$trend%';
  }

  String _getFilterTitle() {
    switch (selectedFilter) {
      case 'last7Days':
        return 'Last 7 Days';
      case 'thisMonth':
        return 'This Month';
      case 'lastMonth':
        return 'Last Month';
      case 'custom':
        if (_startDate != null && _endDate != null) {
          return '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}';
        }
        return 'Custom Range';
      default:
        return 'Last 7 Days';
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_showElevation) {
      setState(() => _showElevation = true);
    } else if (_scrollController.offset <= 0 && _showElevation) {
      setState(() => _showElevation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: _buildResponsiveAppBar(context),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeaderSection(context),
          _buildTransactionsTitle(context),
          _buildTransactionsList(context),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildResponsiveAppBar(BuildContext context) {
    double titleFontSize = getResponsiveSize(context, 20, 24);
    double subtitleFontSize = getResponsiveSize(context, 12, 14);

    return AppBar(
      elevation: _showElevation ? 2 : 0,
      backgroundColor: colorScheme.primary,
      toolbarHeight: getResponsiveSize(context, 56, 72),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: getResponsiveSize(context, 24, 28),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
          ),
          Text(
            'Last updated: ${DateFormat('MMM dd, yyyy - HH:mm').format(DateTime.now())}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: subtitleFontSize,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: getResponsiveSize(context, 8, 12),
            vertical: getResponsiveSize(context, 8, 12),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
              size: getResponsiveSize(context, 24, 28),
            ),
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                selectedFilter = 'last7Days';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(getResponsiveSize(context, 24, 32)),
            bottomRight: Radius.circular(getResponsiveSize(context, 24, 32)),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: getResponsivePadding(context),
              child: _buildResponsiveSummaryCard(context),
            ),
            _buildResponsiveQuickFilters(context),
            SizedBox(height: getResponsiveSize(context, 16, 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveSummaryCard(BuildContext context) {
    final stats = summaryStats;
    final bool isTablet = MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
          boxShadow: cardShadow,
        ),
        child: Padding(
          padding: getResponsivePadding(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getResponsiveSize(context, 16, 24),
                        vertical: getResponsiveSize(context, 8, 12),
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: colorScheme.primary,
                            size: getResponsiveSize(context, 18, 22),
                          ),
                          SizedBox(width: getResponsiveSize(context, 8, 12)),
                          Flexible(
                            child: Text(
                              _getFilterTitle(),
                              style: TextStyle(
                                fontSize: getResponsiveSize(context, 16, 18),
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildTrendIndicator(
                    context,
                    double.parse(stats['balanceTrend'].replaceAll(RegExp(r'[^0-9.-]'), '')),
                  ),
                ],
              ),
              SizedBox(height: getResponsiveSize(context, 24, 32)),
              Wrap(
                spacing: getResponsiveSize(context, 16, 24),
                runSpacing: getResponsiveSize(context, 16, 24),
                alignment: WrapAlignment.spaceAround,
                children: [
                  _buildResponsiveSummaryItem(
                    context,
                    'Earned',
                    stats['earned'].toString(),
                    Icons.arrow_upward,
                    successColor,
                    stats['earnedTrend'],
                  ),
                  if (!isTablet) _buildVerticalDivider(context),
                  _buildResponsiveSummaryItem(
                    context,
                    'Redeemed',
                    stats['redeemed'].toString(),
                    Icons.arrow_downward,
                    errorColor,
                    stats['redeemedTrend'],
                  ),
                  if (!isTablet) _buildVerticalDivider(context),
                  _buildResponsiveSummaryItem(
                    context,
                    'Balance',
                    stats['balance'].toString(),
                    Icons.account_balance_wallet,
                    colorScheme.secondary,
                    stats['balanceTrend'],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveQuickFilters(BuildContext context) {
    return Container(
      height: getResponsiveSize(context, 40, 48),
      margin: EdgeInsets.symmetric(
        vertical: getResponsiveSize(context, 8, 12),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: getResponsiveSize(context, 16, 24),
        ),
        children: [
          _buildResponsiveFilterChip(context, 'Last 7 Days', 'last7Days'),
          _buildResponsiveFilterChip(context, 'This Month', 'thisMonth'),
          _buildResponsiveFilterChip(context, 'Last Month', 'lastMonth'),
          _buildResponsiveDateRangeButton(context),
        ],
      ),
    );
  }

  Widget _buildResponsiveFilterChip(BuildContext context, String label, String value) {
    bool isSelected = selectedFilter == value;

    return Container(
      margin: EdgeInsets.only(right: getResponsiveSize(context, 8, 12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedFilter = value;
              _startDate = null;
              _endDate = null;
            });
          },
          borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveSize(context, 16, 24),
              vertical: getResponsiveSize(context, 8, 12),
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? colorScheme.primary : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: getResponsiveSize(context, 13, 15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveDateRangeButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(right: getResponsiveSize(context, 8, 12)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showIOSStyleDateRangePicker(context),
              borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSize(context, 16, 24),
                  vertical: getResponsiveSize(context, 8, 12),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0656A0).withOpacity(0.9),
                      const Color(0xFF0872B9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Colors.white,
                      size: getResponsiveSize(context, 16, 20),
                    ),
                    SizedBox(width: getResponsiveSize(context, 6, 8)),
                    Text(
                      'Date Range',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getResponsiveSize(context, 13, 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_startDate != null || _endDate != null)
          Container(
            margin: EdgeInsets.only(right: getResponsiveSize(context, 8, 12)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                    selectedFilter = 'last7Days';
                  });
                },
                borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getResponsiveSize(context, 12, 16),
                    vertical: getResponsiveSize(context, 8, 12),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: getResponsiveSize(context, 16, 20),
                      ),
                      SizedBox(width: getResponsiveSize(context, 4, 6)),
                      Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getResponsiveSize(context, 13, 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showIOSStyleDateRangePicker(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width >= ResponsiveBreakpoints.tablet;
    final double dialogWidth = isTablet ? 500.0 : screenSize.width * 0.9;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Create local state variables to track the dates within the modal
        DateTime? localStartDate = _startDate;
        DateTime? localEndDate = _endDate;

        return StatefulBuilder(  // Wrap with StatefulBuilder to manage local state
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(getResponsiveSize(context, 20, 24)),
                  topRight: Radius.circular(getResponsiveSize(context, 20, 24)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getResponsiveSize(context, 16, 24),
                      vertical: getResponsiveSize(context, 8, 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: getResponsiveSize(context, 16, 18),
                            ),
                          ),
                        ),
                        Text(
                          'Select Date Range',
                          style: TextStyle(
                            fontSize: getResponsiveSize(context, 18, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (localStartDate != null && localEndDate != null) {
                              // Update the parent widget's state
                              this.setState(() {
                                _startDate = localStartDate;
                                _endDate = localEndDate;
                                selectedFilter = 'custom';
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: const Color(0xFF0656A0),
                              fontSize: getResponsiveSize(context, 16, 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Date Selection Area
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(getResponsiveSize(context, 16, 24)),
                      child: Column(
                        children: [
                          _buildIOSStyleDateField(
                            context,
                            'Start Date',
                            localStartDate,
                                (date) {
                              setState(() {
                                localStartDate = date;
                                if (localEndDate != null && localEndDate!.isBefore(localStartDate!)) {
                                  localEndDate = date;
                                }
                              });
                            },
                          ),
                          SizedBox(height: getResponsiveSize(context, 16, 24)),
                          _buildIOSStyleDateField(
                            context,
                            'End Date',
                            localEndDate,
                                (date) {
                              setState(() {
                                localEndDate = date;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIOSStyleDateField(
      BuildContext context,
      String label,
      DateTime? value,
      Function(DateTime?) onDateSelected,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(getResponsiveSize(context, 12, 16)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(getResponsiveSize(context, 12, 16)),
          onTap: () async {
            DateTime? selectedDate = value ?? DateTime.now();
            final DateTime? date = await showCupertinoModalPopup<DateTime>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 300,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.grey[100],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            CupertinoButton(
                              child: const Text('Done'),
                              onPressed: () => Navigator.pop(context, selectedDate),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: selectedDate,
                          maximumDate: DateTime.now(),
                          minimumDate: DateTime(2020),
                          onDateTimeChanged: (DateTime newDate) {
                            selectedDate = newDate;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            if (date != null) {
              onDateSelected(date);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveSize(context, 16, 20),
              vertical: getResponsiveSize(context, 12, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: getResponsiveSize(context, 13, 14),
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value != null
                            ? DateFormat('MMM dd, yyyy').format(value)
                            : 'Select date',
                        style: TextStyle(
                          fontSize: getResponsiveSize(context, 15, 16),
                          fontWeight: FontWeight.w600,
                          color: value != null
                              ? const Color(0xFF0656A0)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.calendar,
                      color: const Color(0xFF0656A0),
                      size: getResponsiveSize(context, 20, 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveSummaryItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      String trend,
      ) {
    return Container(
      width: getResponsiveSize(context, 100, 160),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(getResponsiveSize(context, 12, 16)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(getResponsiveSize(context, 16, 20)),
            ),
            child: Icon(
              icon,
              color: color,
              size: getResponsiveSize(context, 24, 32),
            ),
          ),
          SizedBox(height: getResponsiveSize(context, 12, 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: getResponsiveSize(context, 24, 32),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: getResponsiveSize(context, 14, 16),
              color: colorScheme.onBackground,
            ),
          ),
          SizedBox(height: getResponsiveSize(context, 4, 6)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveSize(context, 8, 12),
              vertical: getResponsiveSize(context, 2, 4),
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trend,
              style: TextStyle(
                fontSize: getResponsiveSize(context, 12, 14),
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveDateField(
      BuildContext context,
      String label,
      DateTime? value,
      Function(DateTime?) onDateSelected,
      ) {
    final bool isTablet = MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;
    final double fieldWidth = isTablet ? 200.0 : double.infinity;

    return Container(
      width: fieldWidth,
      child: InkWell(
        onTap: () async {
          final date = await _selectDate(context, value);
          onDateSelected(date);
        },
        child: Container(
          padding: EdgeInsets.all(getResponsiveSize(context, 12, 16)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(getResponsiveSize(context, 12, 16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: getResponsiveSize(context, 12, 14),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: getResponsiveSize(context, 4, 6)),
              Text(
                value != null
                    ? DateFormat('MMM dd, yyyy').format(value)
                    : 'Select date',
                style: TextStyle(
                  fontSize: getResponsiveSize(context, 14, 16),
                  fontWeight: FontWeight.w500,
                  color: value != null
                      ? const Color(0xFF0656A0)
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF0656A0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  Widget _buildTransactionsList(BuildContext context) {
    if (filteredTransactions.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long,
                size: getResponsiveSize(context, 64, 80),
                color: Colors.grey[300],
              ),
              SizedBox(height: getResponsiveSize(context, 16, 24)),
              Text(
                'No transactions found',
                style: TextStyle(
                  fontSize: getResponsiveSize(context, 16, 20),
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: getResponsiveSize(context, 8, 12)),
              Text(
                'Try adjusting your filters',
                style: TextStyle(
                  fontSize: getResponsiveSize(context, 14, 16),
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => _buildResponsiveTransactionCard(
          context,
          filteredTransactions[index],
        ),
        childCount: filteredTransactions.length,
      ),
    );
  }
  Widget _buildResponsiveTransactionCard(BuildContext context, Map<String, dynamic> transaction) {
    final bool isEarn = transaction['action'] == 'earn';
    final Color actionColor = isEarn ? successColor : errorColor;
    final bool isTablet = MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveSize(context, 16, 24),
        vertical: getResponsiveSize(context, 8, 12),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
            color: Colors.white,
            boxShadow: cardShadow,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(getResponsiveSize(context, 16, 24)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(getResponsiveSize(context, 12, 16)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              actionColor.withOpacity(0.1),
                              actionColor.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(getResponsiveSize(context, 16, 20)),
                        ),
                        child: Icon(
                          isEarn ? Icons.add_circle : Icons.remove_circle,
                          color: actionColor,
                          size: getResponsiveSize(context, 24, 32),
                        ),
                      ),
                      SizedBox(width: getResponsiveSize(context, 16, 24)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    transaction['storeName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: getResponsiveSize(context, 16, 18),
                                      color: colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getResponsiveSize(context, 12, 16),
                                    vertical: getResponsiveSize(context, 4, 6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: actionColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${isEarn ? '+' : '-'}${transaction['points']} pts',
                                    style: TextStyle(
                                      color: actionColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getResponsiveSize(context, 14, 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: getResponsiveSize(context, 8, 12)),
                            Wrap(
                              spacing: getResponsiveSize(context, 8, 12),
                              runSpacing: getResponsiveSize(context, 8, 12),
                              children: [
                                _buildTransactionTag(
                                  context,
                                  Icons.point_of_sale,
                                  'Counter ${transaction['counterNo']}',
                                  colorScheme.primary,
                                ),
                                _buildTransactionTag(
                                  context,
                                  Icons.tag,
                                  transaction['transactionId'],
                                  colorScheme.secondary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getResponsiveSize(context, 12, 16),
                    ),
                    child: const Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(getResponsiveSize(context, 6, 8)),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(getResponsiveSize(context, 8, 10)),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: getResponsiveSize(context, 14, 16),
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: getResponsiveSize(context, 8, 12)),
                            Flexible(
                              child: Text(
                                transaction['cashierName'],
                                style: TextStyle(
                                  color: colorScheme.onBackground,
                                  fontSize: getResponsiveSize(context, 12, 14),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getResponsiveSize(context, 8, 12),
                            vertical: getResponsiveSize(context, 4, 6),
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(getResponsiveSize(context, 8, 10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: getResponsiveSize(context, 12, 14),
                                color: colorScheme.secondary,
                              ),
                              SizedBox(width: getResponsiveSize(context, 4, 6)),
                              Flexible(
                                child: Text(
                                  DateFormat('MMM dd, yyyy - HH:mm').format(transaction['date']),
                                  style: TextStyle(
                                    color: colorScheme.onBackground,
                                    fontSize: getResponsiveSize(context, 12, 14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTag(
      BuildContext context,
      IconData icon,
      String label,
      Color color,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveSize(context, 8, 12),
        vertical: getResponsiveSize(context, 4, 6),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(getResponsiveSize(context, 8, 10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: getResponsiveSize(context, 12, 14),
            color: color,
          ),
          SizedBox(width: getResponsiveSize(context, 4, 6)),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: getResponsiveSize(context, 12, 14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(BuildContext context, double percentage) {
    final bool isPositive = percentage >= 0;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveSize(context, 12, 16),
        vertical: getResponsiveSize(context, 6, 8),
      ),
      decoration: BoxDecoration(
        color: isPositive
            ? successColor.withOpacity(0.1)
            : errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(getResponsiveSize(context, 20, 24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? successColor : errorColor,
            size: getResponsiveSize(context, 16, 20),
          ),
          SizedBox(width: getResponsiveSize(context, 4, 6)),
          Text(
            '${isPositive ? '+' : ''}$percentage%',
            style: TextStyle(
              color: isPositive ? successColor : errorColor,
              fontWeight: FontWeight.bold,
              fontSize: getResponsiveSize(context, 13, 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      height: getResponsiveSize(context, 60, 80),
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[300]!.withOpacity(0),
            Colors.grey[300]!,
            Colors.grey[300]!.withOpacity(0),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTitle(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(getResponsiveSize(context, 16, 24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: getResponsiveSize(context, 18, 22),
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Row(
              children: [
                Text(
                  '${filteredTransactions.length} transactions',
                  style: TextStyle(
                    color: colorScheme.onBackground,
                    fontSize: getResponsiveSize(context, 14, 16),
                  ),
                ),
                SizedBox(width: getResponsiveSize(context, 8, 12)),
                Icon(
                  Icons.sort,
                  size: getResponsiveSize(context, 20, 24),
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}