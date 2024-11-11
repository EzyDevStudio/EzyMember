import 'package:flutter/material.dart';
import 'package:coupon_uikit/coupon_uikit.dart';

class VouchersPage extends StatefulWidget {
  const VouchersPage({super.key});

  @override
  State<VouchersPage> createState() => _VouchersPageState();
}

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
    const Color primaryColor = Color(0xffcbf3f0);
    const Color secondaryColor = Color(0xff368f8b);

    return CouponCard(
      height: 110,
      width: 100,
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
                    Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white54, height: 0),
            const Expanded(
              child: Center(
                child: Text(
                  'WINTER IS\nHERE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Coupon Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              code,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              'Valid Till - $validTill',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanySearchDialog extends StatelessWidget {
  final VoidCallback onClose;

  const CompanySearchDialog({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extended list of companies for demonstration
    final List<Map<String, dynamic>> extendedCompanies = [
      {'name': 'Nike', 'logo': 'N', 'vouchers': 3},
      {'name': 'Adidas', 'logo': 'A', 'vouchers': 4},
      {'name': 'Puma', 'logo': 'P', 'vouchers': 2},
      {'name': 'Reebok', 'logo': 'R', 'vouchers': 5},
      {'name': 'Under Armour', 'logo': 'U', 'vouchers': 3},
      {'name': 'New Balance', 'logo': 'NB', 'vouchers': 4},
      {'name': 'Asics', 'logo': 'A', 'vouchers': 2},
      {'name': 'Fila', 'logo': 'F', 'vouchers': 3},
      {'name': 'Converse', 'logo': 'C', 'vouchers': 4},
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Company',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search company',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Number of Results
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                '${extendedCompanies.length} Companies Found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Scrollable Grid
            Expanded(
              child: RawScrollbar(
                thumbVisibility: true,
                thumbColor: Colors.grey[400]!,
                radius: const Radius.circular(20),
                thickness: 5,
                child: GridView.builder(
                  padding: const EdgeInsets.only(right: 8), // Add padding for scrollbar
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.50,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: extendedCompanies.length,
                  itemBuilder: (context, index) {
                    final company = extendedCompanies[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          // Handle selection
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                company['logo'],
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              company['name'],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${company['vouchers']} Vouchers',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VouchersPageState extends State<VouchersPage> {
  static const Color themeColor = Color(0xFF0656A0);
  String? selectedCompany;

  final List<Map<String, dynamic>> companies = [
    {
      'name': 'Nike',
      'logo': 'N',
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
      'logo': 'A',
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
      'logo': 'P',
      'vouchers': [
        {
          'discount': '20%',
          'code': 'PUMASALE',
          'validTill': '25 Jan 2022',
        }
      ]
    },
  ];

  void _copyToClipboard(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coupon code $code copied!')),
    );
  }

  void _showCompanySearchDialog() {
    showDialog(
      context: context,
      builder: (context) => CompanySearchDialog(
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: themeColor,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Company',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _showCompanySearchDialog,
                  child: const Text(
                    'See More',
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                final isSelected = selectedCompany == company['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCompany = company['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? themeColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : Colors.orange[100],
                          child: Text(
                            company['logo'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.orange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          company['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available Vouchers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: selectedCompany == null
                ? Center(
              child: Text(
                'Select a company to view vouchers',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: companies
                  .firstWhere(
                      (company) => company['name'] == selectedCompany)['vouchers']
                  .length,
              itemBuilder: (context, index) {
                final voucher = companies
                    .firstWhere(
                        (company) => company['name'] == selectedCompany)['vouchers'][index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomCouponCard(
                    discount: voucher['discount'],
                    code: voucher['code'],
                    validTill: voucher['validTill'],
                    onCopyPressed: () => _copyToClipboard(voucher['code']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}