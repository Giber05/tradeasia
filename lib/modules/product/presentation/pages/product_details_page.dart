import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';
import 'package:trade_asia/infrastructure/components/error_state_widgets.dart' as enhanced;
import 'package:trade_asia/infrastructure/components/network_image_widget.dart';
import 'package:trade_asia/infrastructure/service_locator/service_locator.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';
import 'package:trade_asia/modules/product/presentation/cubit/product_details_cubit.dart';
import 'package:trade_asia/modules/product/presentation/widgets/product_detail_skeleton.dart';

@RoutePage()
class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, @pathParam required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductDetailsCubit>()..loadProductDetails(productId),
      child: ProductDetailsView(productId: productId),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  final String productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: BlocBuilder<ProductDetailsCubit, CubitState<ProductDetail>>(
        builder: (context, state) {
          return switch (state) {
            CubitLoadingState() => _buildLoadingState(context),
            CubitSuccessState(data: final productDetail) => _buildSuccessState(
              context,
              productDetail,
              state.isRefreshing,
            ),
            CubitErrorState(exception: final exception, onRetry: final onRetry) => _buildErrorState(
              context,
              exception.message,
              onRetry,
            ),
          };
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: _buildAppBar(context, 'Loading...'),
      body: const ProductDetailSkeleton(),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, VoidCallback onRetry) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: _buildAppBar(context, 'Error'),
      body: enhanced.ErrorStateWidget(title: 'Something went wrong', message: message, onRetry: onRetry),
    );
  }

  Widget _buildSuccessState(BuildContext context, ProductDetail productDetail, bool isRefreshing) {
    return CustomScrollView(
      slivers: [
        // Modern App Bar with Product Image
        _buildSliverAppBar(context, productDetail),

        // Product Content
        SliverToBoxAdapter(child: _buildProductContent(context, productDetail)),

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: const Color(0xFF123C69),
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(onPressed: () => context.router.maybePop(), icon: const Icon(Icons.arrow_back_ios, size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      actions: [
        IconButton(
          onPressed: () {
            // Share functionality
          },
          icon: const Icon(Icons.share_outlined, size: 20),
        ),
        IconButton(
          onPressed: () {
            // Favorite functionality
          },
          icon: const Icon(Icons.favorite_border_outlined, size: 20),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ProductDetail productDetail) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF123C69),
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => context.router.maybePop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Share functionality
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.share_outlined, size: 16, color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            // Favorite functionality
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite_border_outlined, size: 16, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Product Image
            NetworkImageWidget(
              imageUrl: productDetail.productImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductContent(BuildContext context, ProductDetail productDetail) {
    return Container(
      color: const Color(0xFFF6F6F6),
      child: Column(
        children: [
          // Product Header Card
          _buildProductHeader(context, productDetail),
          const SizedBox(height: 16),

          // Basic Information Card
          _buildBasicInfoCard(context, productDetail),
          const SizedBox(height: 16),

          // Description Card
          if (productDetail.description.isNotEmpty) _buildDescriptionCard(context, productDetail),
          const SizedBox(height: 16),

          // Application Card
          if (productDetail.application.isNotEmpty) _buildApplicationCard(context, productDetail),
          const SizedBox(height: 16),

          // Related Products Card
          if (productDetail.relatedProducts.isNotEmpty) _buildRelatedProductsCard(context, productDetail),
          const SizedBox(height: 16),

          // Action Buttons
          _buildActionButtons(context, productDetail),
        ],
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context, ProductDetail productDetail) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productDetail.productName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF17234D), height: 1.3),
          ),
          const SizedBox(height: 8),

          if (productDetail.iupacName.isNotEmpty) ...[
            Text(
              'IUPAC Name: ${productDetail.iupacName}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF87888A), height: 1.4),
            ),
            const SizedBox(height: 8),
          ],

          // Category and Industry
          Row(
            children: [
              if (productDetail.categoryName.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1BA2CA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    productDetail.categoryName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1BA2CA)),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              if (productDetail.prodindName.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF123C69).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    productDetail.prodindName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF123C69)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, ProductDetail productDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF17234D)),
          ),
          const SizedBox(height: 16),

          _buildInfoRow('CAS Number', productDetail.casNumber),
          _buildInfoRow('HS Code', productDetail.hsCode),
          if (productDetail.formula.isNotEmpty) _buildInfoRow('Formula', productDetail.formula),
          if (productDetail.commonNames.isNotEmpty) _buildInfoRow('Common Names', productDetail.commonNames),

          // Basic Info from entity
          if (productDetail.basicInfo.phyAppearName.isNotEmpty)
            _buildInfoRow('Physical Appearance', productDetail.basicInfo.phyAppearName),
          if (productDetail.basicInfo.packagingName.isNotEmpty)
            _buildInfoRow('Packaging', productDetail.basicInfo.packagingName),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF17234D)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF87888A), height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, ProductDetail productDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF17234D)),
          ),
          const SizedBox(height: 16),

          _buildHtmlOrText(productDetail.description),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, ProductDetail productDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Applications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF17234D)),
          ),
          const SizedBox(height: 16),

          _buildHtmlOrText(productDetail.application),
        ],
      ),
    );
  }

  Widget _buildHtmlOrText(String content) {
    // Check if the content contains HTML tags
    if (content.contains('<') && content.contains('>')) {
      return Html(
        data: content,
        style: {
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(14),
            color: const Color(0xFF87888A),
            lineHeight: const LineHeight(1.6),
          ),
          "p": Style(margin: Margins.only(bottom: 8)),
          "br": Style(fontSize: FontSize(14)),
        },
      );
    } else {
      return Text(content, style: const TextStyle(fontSize: 14, color: Color(0xFF87888A), height: 1.6));
    }
  }

  Widget _buildRelatedProductsCard(BuildContext context, ProductDetail productDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF17234D)),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productDetail.relatedProducts.length,
              itemBuilder: (context, index) {
                final relatedProduct = productDetail.relatedProducts[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(right: index < productDetail.relatedProducts.length - 1 ? 16 : 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relatedProduct.productName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF17234D)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CAS: ${relatedProduct.casNumber}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF87888A)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ProductDetail productDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Primary Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showInquiryDialog(context, productDetail);
                  },
                  icon: const Icon(Icons.email_outlined, size: 20),
                  label: const Text('Send Inquiry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123C69),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddToCartSnackBar(context, productDetail);
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BA2CA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Secondary Actions
          Row(
            children: [
              if (productDetail.tdsFile.isNotEmpty)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _downloadFile(context, productDetail.tdsFile, 'TDS');
                    },
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Download TDS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF123C69),
                      side: const BorderSide(color: Color(0xFF123C69)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

              if (productDetail.tdsFile.isNotEmpty && productDetail.msdsFile.isNotEmpty) const SizedBox(width: 12),

              if (productDetail.msdsFile.isNotEmpty)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _downloadFile(context, productDetail.msdsFile, 'MSDS');
                    },
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Download MSDS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF123C69),
                      side: const BorderSide(color: Color(0xFF123C69)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInquiryDialog(BuildContext context, ProductDetail productDetail) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Send Inquiry', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF17234D))),
            content: Text(
              'Would you like to send an inquiry for ${productDetail.productName}?',
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

  void _showAddToCartSnackBar(BuildContext context, ProductDetail productDetail) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${productDetail.productName} added to cart'),
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

  void _downloadFile(BuildContext context, String fileUrl, String fileType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $fileType file...'),
        backgroundColor: const Color(0xFF1BA2CA),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
