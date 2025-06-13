import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';
import 'package:trade_asia/infrastructure/service_locator/service_locator.dart';
import 'package:trade_asia/infrastructure/components/error_state_widgets.dart';
import 'package:trade_asia/infrastructure/router/router.gr.dart';
import 'package:trade_asia/infrastructure/services/connectivity_service.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/presentation/cubit/top_products_cubit.dart';
import 'package:trade_asia/modules/product/presentation/widgets/product_card.dart';
import 'package:trade_asia/modules/product/presentation/widgets/product_skeleton.dart';

@RoutePage()
class TopProductsPage extends StatefulWidget {
  const TopProductsPage({super.key});

  @override
  State<TopProductsPage> createState() => _TopProductsPageState();
}

class _TopProductsPageState extends State<TopProductsPage> {
  late final TopProductsCubit _cubit;
  late final TextEditingController _searchController;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TopProductsCubit>();
    _searchController = TextEditingController();
    _initConnectivity();
    _cubit.loadData();
  }

  void _initConnectivity() async {
    try {
      final connectivityService = getIt<ConnectivityService>();
      final isConnected = await connectivityService.checkConnectivity();
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }

      connectivityService.isConnected.listen((isConnected) {
        if (mounted) {
          setState(() {
            _isConnected = isConnected;
          });
        }
      });
    } catch (e) {
      // If connectivity service is not available, assume connected
      _isConnected = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: ConnectivityIndicator(
          isConnected: _isConnected,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              _buildSearchSection(context),
              BlocBuilder<TopProductsCubit, CubitState<List<Product>>>(
                builder: (context, state) {
                  return switch (state) {
                    CubitLoadingState() => _buildSkeletonGrid(context),
                    CubitSuccessState() => _buildProductsGrid(context, state.data, state.isRefreshing),
                    CubitErrorState() => _buildErrorSection(context, state),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF17234D),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF17234D), Color(0xFF123C69), Color(0xFF0A5A8A)],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(child: CustomPaint(painter: ChemicalPatternPainter())),
              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TRADEASIA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'TOP PRODUCTS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Discover our premium chemical products sourced from trusted suppliers worldwide.',
                        style: TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7E9), width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: const TextStyle(color: Color(0xFF87888A), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF17234D), size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (value) {
                    _cubit.searchProducts(value);
                  },
                ),
              ),
            ),
            if (_cubit.isSearchActive) ...[
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: const Color(0xFF17234D), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _cubit.clearSearch();
                  },
                  icon: const Icon(Icons.clear, color: Colors.white, size: 20),
                  tooltip: 'Clear search',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ProductSkeleton(),
          childCount: 6, // Show 6 skeleton items
        ),
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context, List<Product> products, bool isRefreshing) {
    if (products.isEmpty) {
      final isSearching = _cubit.isSearchActive;
      return SliverFillRemaining(
        child: EmptyStateWidget(
          title: isSearching ? 'No Products Found' : 'No Products Available',
          message:
              isSearching
                  ? 'No products match your search "${_cubit.currentSearchQuery}". Try different keywords.'
                  : 'We couldn\'t find any products at the moment. Please try again later.',
          icon: isSearching ? Icons.search_off : Icons.inventory_2_outlined,
        ),
      );
    }

    // Responsive grid based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // 3 columns for tablets, 2 for phones
    final childAspectRatio = screenWidth > 600 ? 0.8 : 0.72; // Adjust aspect ratio for different screens

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0), // Reduced horizontal padding for mobile
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12, // Reduced spacing for mobile
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () {
              context.router.push(ProductDetailsRoute(productId: product.id.toString()));
            },
            onInquiry: () {
              _showInquiryDialog(context, product);
            },
            onAddToCart: () {
              _showAddToCartSnackBar(context, product);
            },
          );
        }, childCount: products.length),
      ),
    );
  }

  Widget _buildErrorSection(BuildContext context, CubitErrorState<List<Product>> state) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Error Loading Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 8),
              Text(
                state.exception.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: state.onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123C69),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInquiryDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Send Inquiry', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF17234D))),
            content: Text(
              'Would you like to send an inquiry for ${product.productName}?',
              style: const TextStyle(color: Color(0xFF87888A)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF87888A))),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessSnackBar(context, 'Inquiry sent successfully!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123C69),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  void _showAddToCartSnackBar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        backgroundColor: const Color(0xFF123C69),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class ChemicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final spacing = 60.0;

    // Draw hexagonal chemical structure pattern
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing * 0.75) {
        final offsetX = (y / (spacing * 0.75)).round() % 2 == 0 ? 0.0 : spacing * 0.5;
        _drawHexagon(canvas, paint, Offset(x + offsetX, y), 15.0);
      }
    }

    // Draw some chemical bonds (lines connecting hexagons)
    for (double x = spacing; x < size.width; x += spacing * 2) {
      for (double y = spacing; y < size.height; y += spacing * 1.5) {
        canvas.drawLine(Offset(x, y), Offset(x + spacing * 0.8, y + spacing * 0.3), paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (3.14159 / 180);
      final x = center.dx + radius * (angle == 0 ? 1 : (angle == 3.14159 ? -1 : (angle < 3.14159 ? 0.5 : -0.5)));
      final y =
          center.dy + radius * (angle == 1.5708 ? -1 : (angle == 4.7124 ? 1 : (angle < 3.14159 ? -0.866 : 0.866)));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
