import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trade_asia/infrastructure/constants/app_theme.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showLoadingIndicator;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.showLoadingIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    // If URL is empty or invalid, show error widget immediately
    if (imageUrl.isEmpty || !_isValidUrl(imageUrl)) {
      return _buildErrorWidget();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: _sanitizeUrl(imageUrl),
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _buildLoadingWidget(),
        errorWidget: (context, url, error) {
          debugPrint('Failed to load image: $url');
          debugPrint('Error: $error');
          return errorWidget ?? _buildErrorWidget();
        },
        httpHeaders: const {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
          'Accept-Encoding': 'gzip, deflate, br',
          'Cache-Control': 'no-cache',
        },
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: AppTheme.backgroundSecondary, borderRadius: borderRadius),
      child:
          showLoadingIndicator
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightBlue),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text('Loading...', style: AppTheme.caption.copyWith(color: AppTheme.textLight)),
                ],
              )
              : const Center(child: Icon(Icons.image_outlined, size: 32, color: AppTheme.textLight)),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: borderRadius,
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported_outlined, size: 32, color: AppTheme.textLight),
          const SizedBox(height: AppTheme.spacingXS),
          Text('No Image', style: AppTheme.caption.copyWith(color: AppTheme.textLight)),
        ],
      ),
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  String _sanitizeUrl(String url) {
    // Remove any whitespace
    url = url.trim();

    // If URL doesn't start with http/https, assume https
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    return url;
  }
}

// Specific product image widget
class ProductImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double? width;

  const ProductImageWidget({super.key, required this.imageUrl, this.height = 120, this.width});

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      imageUrl: imageUrl,
      width: width ?? double.infinity,
      height: height,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      showLoadingIndicator: true,
    );
  }
}
