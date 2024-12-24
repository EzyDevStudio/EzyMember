import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final Color themeColor;

  const ProductDetailsPage({
    Key? key,
    required this.themeColor,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  // Hardcoded product data
  final String productId = "PRD001";
  final String productName = "Premium Coffee Maker";
  final String originalPrice = "\$299.99";
  final String discountPrice = "\$249.99";
  final String description = "Experience the perfect brew with our Premium Coffee Maker. This professional-grade coffee machine delivers exceptional taste and aroma with every cup. Features include precise temperature control, programmable settings, and a sleek modern design that complements any kitchen décor.";

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
    if (_scrollController.offset > 200 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 200 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProductDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: widget.themeColor,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: _showAppBarTitle
            ? Text(
          productName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        )
            : null,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Product image placeholder
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[200]!,
                    Colors.grey[50]!,
                  ],
                ),
              ),
              child: Icon(
                Icons.coffee_maker,
                size: 120,
                color: Colors.grey[400],
              ),
            ),
            // Gradient overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 160,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Product information overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        discountPrice,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        originalPrice,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough,
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

  Widget _buildProductDetails() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discount badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red[100]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_offer_outlined, size: 16, color: Colors.red[700]),
                  SizedBox(width: 4),
                  Text(
                    "17% OFF",
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Product ID: $productId",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}