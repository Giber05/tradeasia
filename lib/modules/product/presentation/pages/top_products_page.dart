import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';
import 'package:trade_asia/infrastructure/components/error_state_widgets.dart';
import 'package:trade_asia/infrastructure/router/router.gr.dart';
import 'package:trade_asia/infrastructure/service_locator/service_locator.dart';
import 'package:trade_asia/infrastructure/services/connectivity_service.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/presentation/cubit/top_products_cubit.dart';
import 'package:trade_asia/modules/product/presentation/widgets/product_card.dart';
import 'package:trade_asia/modules/product/presentation/widgets/product_skeleton.dart';

@RoutePage()
class TopProductsPage extends StatelessWidget {
  const TopProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<TopProductsCubit>()..loadData(), child: const TopProductsView());
  }
}

class TopProductsView extends StatefulWidget {
  const TopProductsView({super.key});

  @override
  State<TopProductsView> createState() => _TopProductsViewState();
}

class _TopProductsViewState extends State<TopProductsView> {
  late final ConnectivityService _connectivityService;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivityService = getIt<ConnectivityService>();
    _initConnectivity();
  }

  void _initConnectivity() {
    _connectivityService.checkConnectivity().then((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });

    _connectivityService.isConnected.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: ConnectivityIndicator(
        isConnected: _isConnected,
        child: CustomScrollView(
          slivers: [
            // Modern App Bar with Hero Section
            _buildSliverAppBar(context),

            // Search Bar
            _buildSearchSection(context),

            // Products Grid
            BlocBuilder<TopProductsCubit, CubitState<List<Product>>>(
              builder: (context, state) {
                return switch (state) {
                  CubitLoadingState() => SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) => const ProductSkeleton(), childCount: 6),
                    ),
                  ),
                  CubitSuccessState(data: final products) => _buildProductsGrid(context, products, state.isRefreshing),
                  CubitErrorState(exception: final exception, onRetry: final onRetry) => SliverFillRemaining(
                    child: ErrorStateWidget(
                      title: 'Something went wrong',
                      message: exception.message,
                      onRetry: onRetry,
                    ),
                  ),
                };
              },
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.router.maybePop(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Shopping cart action
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF1BA2CA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1BA2CA), Color(0xFF177AA4), Color(0xFF144D79), Color(0xFF123C69)],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Opacity(opacity: 0.1, child: CustomPaint(painter: ChemicalPatternPainter(), child: Container())),
              ),

              // Content
              Positioned(
                left: 20,
                right: 20,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Top Products',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We are dedicated to delivering the best service to our customers by offering required quality chemical products',
                      style: TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildSearchSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(color: Color(0xFF87888A), fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF17234D), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (value) {
              // Implement search functionality
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context, List<Product> products, bool isRefreshing) {
    if (products.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyStateWidget(
          title: 'No Products Found',
          message: 'We couldn\'t find any products at the moment. Please try again later.',
          icon: Icons.inventory_2_outlined,
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
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
