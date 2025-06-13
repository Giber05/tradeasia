import 'package:flutter/material.dart';
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

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with skeleton loader
              _buildProductImage(context),
              const SizedBox(height: 12),

              // Product Name
              Text(
                product.productName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF17234D),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Chemical Information
              _buildChemicalInfo(context),
              const SizedBox(height: 16),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return ProductImageWidget(imageUrl: product.productImage, height: 120);
  }

  Widget _buildChemicalInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(context, 'CAS Number:', product.casNumber.isNotEmpty ? product.casNumber : '-'),
        const SizedBox(height: 6),
        _buildInfoRow(context, 'HS Code:', product.hsCode.isNotEmpty ? product.hsCode : '-'),
        if (product.formula.isNotEmpty) ...[
          const SizedBox(height: 6),
          _buildInfoRow(context, 'Formula:', product.formula),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF17234D),
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          flex: 3,
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF87888A), fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Send Inquiry Button
        Expanded(
          child: ElevatedButton(
            onPressed: onInquiry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF123C69),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Send Inquiry', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ),
        const SizedBox(width: 8),

        // Add to Cart Button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7E9), width: 1),
          ),
          child: IconButton(
            onPressed: onAddToCart,
            icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: Color(0xFF123C69)),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
      ],
    );
  }
}
