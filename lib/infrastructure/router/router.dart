import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Home route - Top Products page
    AutoRoute(page: TopProductsRoute.page, path: '/', initial: true),

    // Product Details route
    AutoRoute(page: ProductDetailsRoute.page, path: '/product/:productId'),
  ];
}

// Page classes for auto_route generation
@RoutePage()
class TopProductsPage extends StatelessWidget {
  const TopProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Top Products Page - Coming Soon')));
  }
}

@RoutePage()
class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, @pathParam required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(child: Text('Product Details for ID: $productId')),
    );
  }
}
