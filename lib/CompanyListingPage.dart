import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ezymember/CustomPageRoute.dart';
import 'package:ezymember/ScaleAnimation.dart';
import 'CustomAppBar.dart';
import 'company_profile.dart';

class CompanyListingPage extends StatefulWidget {
  const CompanyListingPage({Key? key}) : super(key: key);

  @override
  State<CompanyListingPage> createState() => _CompanyListingPageState();
}

class _CompanyListingPageState extends State<CompanyListingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'All States';

  final List<String> locations = [
    'All States',
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Perak',
    'Perlis',
    'Pulau Pinang',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Wilayah Persekutuan Kuala Lumpur',
    'Wilayah Persekutuan Putrajaya',
    'Wilayah Persekutuan Labuan',
  ];

  final List<Map<String, dynamic>> companies = [
    {
      'name': 'Tech Solutions Sdn Bhd',
      'location': 'Selangor',
      'description':
      'IT Solutions Provider specializing in custom software development, cloud solutions, and digital transformation services. We help businesses leverage technology to achieve their goals.',
      'logo': 'assets/logo.jpg',
      'companyName': 'Tech Solutions Sdn Bhd',
      'rating': '4.8',
      'category': 'Technology',
      'users': 1500,
      'foundedYear': '2010',
    },
    {
      'name': 'Global Industries Bhd',
      'location': 'Kuala Lumpur',
      'description':
      'Leading manufacturer of industrial equipment and solutions. Our commitment to quality and innovation has made us a trusted partner for businesses worldwide.',
      'logo': 'assets/logo.jpg',
      'companyName': 'Global Industries Bhd',
      'rating': '4.5',
      'category': 'Manufacturing',
      'users': 2000,
      'foundedYear': '2005',
    },
    {
      'name': 'Johor Electronics',
      'location': 'Johor',
      'description':
      'Premier electronics component manufacturer serving the ASEAN region. Specializing in high-quality electronic components for various industries.',
      'logo': 'assets/logo.jpg',
      'companyName': 'Johor Electronics',
      'rating': '4.3',
      'category': 'Electronics',
      'users': 1200,
      'foundedYear': '2012',
    },
    {
      'name': 'Penang Systems',
      'location': 'Pulau Pinang',
      'description':
      'Innovative software development company creating cutting-edge solutions for businesses. Our expertise spans web, mobile, and enterprise applications.',
      'logo': 'assets/logo.jpg',
      'companyName': 'Penang Systems',
      'rating': '4.7',
      'category': 'Software',
      'users': 800,
      'foundedYear': '2015',
    },
    {
      'name': 'Sarawak Digital',
      'location': 'Sarawak',
      'description':
      'Digital transformation consultancy helping businesses embrace the digital age. Our services include digital strategy, implementation, and training.',
      'logo': 'assets/logo.jpg',
      'companyName': 'Sarawak Digital',
      'rating': '4.4',
      'category': 'Digital Services',
      'users': 600,
      'foundedYear': '2018',
    },
  ];

  late List<Map<String, dynamic>> filteredCompanies;

  @override
  void initState() {
    super.initState();
    filteredCompanies = companies;
  }

  void _filterCompanies(String query) {
    setState(() {
      filteredCompanies = companies.where((company) {
        final nameMatch =
        company['name']!.toLowerCase().contains(query.toLowerCase());
        final locationMatch = _selectedLocation == 'All States' ||
            company['location'] == _selectedLocation;
        return nameMatch && locationMatch;
      }).toList();
    });
  }

  void _clearAll() {
    setState(() {
      _searchController.clear();
      _selectedLocation = 'All States';
      _filterCompanies('');
    });
  }

  void _showLocationPicker() {
    String tempLocation = _selectedLocation;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF0656A0),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Text(
                    'Select State',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedLocation = tempLocation;
                        _filterCompanies(_searchController.text);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF0656A0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem: locations.indexOf(_selectedLocation),
                ),
                children: locations.map((location) {
                  return Center(
                    child: Text(
                      location,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onSelectedItemChanged: (index) {
                  tempLocation = locations[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0656A0);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 24.0 : 16.0;
    final gridCrossAxisCount = size.width > 900 ? 3 : (size.width > 600 ? 2 : 1);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        titleWidget: Text(
          'Companies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
        backgroundColor: primaryColor,
        actions: [
          if (_searchController.text.isNotEmpty || _selectedLocation != 'All States')
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAll,
              tooltip: 'Clear all filters',
            ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: primaryColor,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(padding),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      if (isTablet)
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildSearchField(),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildLocationSelector(),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildSearchField(),
                            SizedBox(height: padding),
                            _buildLocationSelector(),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: isTablet
                ? GridView.builder(
              padding: EdgeInsets.all(padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount,
                childAspectRatio: 1.5,
                crossAxisSpacing: padding,
                mainAxisSpacing: padding,
              ),
              itemCount: filteredCompanies.length,
              itemBuilder: (context, index) => _buildCompanyCard(
                filteredCompanies[index],
                isTablet: true,
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(padding),
              itemCount: filteredCompanies.length,
              itemBuilder: (context, index) => _buildCompanyCard(
                filteredCompanies[index],
                isTablet: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterCompanies,
        decoration: InputDecoration(
          hintText: 'Search companies...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF0656A0)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _filterCompanies('');
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showLocationPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedLocation,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.location_on, color: Color(0xFF0656A0)),
                ],
              ),
            ),
          ),
        ),
        if (_selectedLocation != 'All States')
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () {
                setState(() {
                  _selectedLocation = 'All States';
                  _filterCompanies(_searchController.text);
                });
              },
              tooltip: 'Clear location filter',
            ),
          ),
      ],
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company, {required bool isTablet}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompactScreen = screenWidth <= 600;
    final compactLayout = screenWidth <= 768; // For screens like in the screenshot

    return ScaleAnimation(
      onTap: () {
        context.pushCustomRoute(
          child: Company_profile(companyData: company),
          duration: 300,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(compactLayout ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyLogo(company, size: compactLayout ? 50 : 60),
                  SizedBox(width: compactLayout ? 12 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: compactLayout ? 14 : 16,
                            color: const Color(0xFF0656A0),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        _buildCompactMetadata(company, compactLayout),
                      ],
                    ),
                  ),
                ],
              ),
              if (!compactLayout) const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(top: compactLayout ? 8 : 4),
                child: Text(
                  company['description']!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: compactLayout ? 12 : 14,
                  ),
                  maxLines: compactLayout ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactMetadata(Map<String, dynamic> company, bool compactLayout) {
    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: compactLayout ? 12 : 14,
    );

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on,
                size: compactLayout ? 14 : 16,
                color: Colors.grey[600]
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                company['location']!,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star,
                size: compactLayout ? 14 : 16,
                color: Colors.orange
            ),
            const SizedBox(width: 2),
            Text(
              company['rating']!,
              style: textStyle,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people,
                size: compactLayout ? 14 : 16,
                color: Colors.grey[600]
            ),
            const SizedBox(width: 2),
            Text(
              '${company['users']}',
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompanyLogo(Map<String, dynamic> company, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          company['logo']!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[100],
              child: Icon(
                Icons.business,
                color: Colors.grey[400],
                size: size * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompanyMetadata(Map<String, dynamic> company) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Row(
      children: [
        Icon(Icons.location_on, size: isTablet ? 18 : 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            company['location']!,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTablet ? 15 : 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.star, size: isTablet ? 18 : 16, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          company['rating']!,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isTablet ? 15 : 14,
          ),
        ),
        if (isTablet) ...[
          const SizedBox(width: 12),
          Icon(Icons.people, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '${company['users']} users',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 15,
            ),
          ),
        ],
      ],
    );
  }


  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No companies found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or location filters',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Optional: Add these extension methods for responsive sizing
extension ResponsiveSize on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.width > 600;
  bool get isDesktop => MediaQuery.of(this).size.width > 900;

  double get deviceWidth => MediaQuery.of(this).size.width;
  double get deviceHeight => MediaQuery.of(this).size.height;

  double get standardPadding => isTablet ? 24.0 : 16.0;
  double get logoSize => isTablet ? 80.0 : 60.0;

  int get gridColumns => isDesktop ? 3 : (isTablet ? 2 : 1);
}