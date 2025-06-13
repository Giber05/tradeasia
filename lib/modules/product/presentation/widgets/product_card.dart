import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:trade_asia/infrastructure/components/network_image_widget.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onInquiry;
  final VoidCallback? onAddToCart;

  const ProductCard({super.key, required this.product, this.onTap, this.onInquiry, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2; // Account for padding and spacing

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(12), // Reduced padding for mobile
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Important: prevents overflow
            children: [
              // Product Image with fixed aspect ratio
              _buildProductImage(context, cardWidth),
              const SizedBox(height: 8),

              // Product Name with HTML support
              _buildProductName(context),
              const SizedBox(height: 8),

              // Chemical Information
              _buildChemicalInfo(context),
              const SizedBox(height: 12),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, double cardWidth) {
    return SizedBox(
      width: double.infinity,
      height: 100, // Fixed height to prevent overflow
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ProductImageWidget(
          imageUrl: product.productImage,
          height: 100,
          width: cardWidth - 24, // Account for card padding
        ),
      ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    final theme = Theme.of(context);

    // Check if the product name contains HTML tags
    if (product.productName.contains('<') && product.productName.contains('>')) {
      return Html(
        data: product.productName,
        style: {
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF17234D),
            lineHeight: const LineHeight(1.3),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        },
      );
    } else {
      return Text(
        product.productName,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF17234D),
          height: 1.3,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildChemicalInfo(BuildContext context) {
    return Column(
      children: [
        if (product.casNumber.isNotEmpty) _buildInfoRow(context, 'CAS:', product.casNumber),
        if (product.casNumber.isNotEmpty && product.hsCode.isNotEmpty) const SizedBox(height: 4),
        if (product.hsCode.isNotEmpty) _buildInfoRow(context, 'HS Code:', product.hsCode),
        if ((product.casNumber.isNotEmpty || product.hsCode.isNotEmpty) && product.formula.isNotEmpty)
          const SizedBox(height: 4),
        if (product.formula.isNotEmpty) _buildInfoRow(context, 'Formula:', product.formula),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60, // Fixed width for label to prevent overflow
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF17234D),
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(child: _buildValueText(context, value)),
      ],
    );
  }

  Widget _buildValueText(BuildContext context, String value) {
    final theme = Theme.of(context);

    // Check if the value contains HTML tags
    if (value.contains('<') && value.contains('>')) {
      return Html(
        data: value,
        style: {
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(10),
            color: const Color(0xFF87888A),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        },
      );
    } else {
      return Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF87888A), fontSize: 10),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Send Inquiry Button
        Expanded(
          child: SizedBox(
            height: 32, // Fixed height to prevent overflow
            child: ElevatedButton(
              onPressed: onInquiry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123C69),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              child: const FittedBox(fit: BoxFit.scaleDown, child: Text('Inquiry', style: TextStyle(fontSize: 10))),
            ),
          ),
        ),
        const SizedBox(width: 6),

        // Add to Cart Button
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE5E7E9), width: 1),
          ),
          child: IconButton(
            onPressed: onAddToCart,
            icon: const Icon(Icons.shopping_cart_outlined, size: 14, color: Color(0xFF123C69)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}
