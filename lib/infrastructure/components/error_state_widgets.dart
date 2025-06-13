import 'package:flutter/material.dart';
import 'package:trade_asia/infrastructure/constants/app_theme.dart';
import 'package:trade_asia/infrastructure/components/loading_widgets.dart';

class ErrorStateWidget extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onRetry;
  final bool isLoading;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.buttonText,
    this.onRetry,
    this.isLoading = false,
  });

  @override
  State<ErrorStateWidget> createState() => _ErrorStateWidgetState();
}

class _ErrorStateWidgetState extends State<ErrorStateWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error Icon with pulse animation
                    PulseAnimation(
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingXL),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(widget.icon, size: 64, color: AppTheme.errorRed),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXXL),

                    // Error Title
                    Text(
                      widget.title,
                      style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingM),

                    // Error Message
                    Text(
                      widget.message,
                      style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXXL),

                    // Retry Button
                    if (widget.onRetry != null) _buildRetryButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isLoading ? null : widget.onRetry,
        icon:
            widget.isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Icon(Icons.refresh),
        label: Text(widget.buttonText ?? 'Try Again'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingL, horizontal: AppTheme.spacingXXL),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isLoading;

  const NetworkErrorWidget({super.key, this.onRetry, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off_rounded,
      buttonText: 'Retry',
      onRetry: onRetry,
      isLoading: isLoading,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isLoading;

  const ServerErrorWidget({super.key, this.onRetry, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      icon: Icons.dns_outlined,
      buttonText: 'Try Again',
      onRetry: onRetry,
      isLoading: isLoading,
    );
  }
}

class EmptyStateWidget extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Empty state illustration
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingXXL),
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, size: 64, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: AppTheme.spacingXXL),

                    // Empty state title
                    Text(
                      widget.title,
                      style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingM),

                    // Empty state message
                    Text(
                      widget.message,
                      style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXXL),

                    // Action button (if provided)
                    if (widget.onAction != null)
                      OutlinedButton.icon(
                        onPressed: widget.onAction,
                        icon: const Icon(Icons.refresh),
                        label: Text(widget.actionText ?? 'Refresh'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryBlue,
                          side: const BorderSide(color: AppTheme.primaryBlue),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingM,
                            horizontal: AppTheme.spacingXL,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OfflineIndicator extends StatefulWidget {
  final bool isConnected;

  const OfflineIndicator({super.key, required this.isConnected});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    if (!widget.isConnected) {
      _slideController.forward();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OfflineIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected != oldWidget.isConnected) {
      if (widget.isConnected) {
        _slideController.reverse();
        _pulseController.stop();
      } else {
        _slideController.forward();
        _pulseController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isConnected) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM, horizontal: AppTheme.spacingL),
              decoration: const BoxDecoration(
                color: AppTheme.errorRed,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, color: Colors.white, size: 20),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'No internet connection',
                    style: AppTheme.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ConnectivityIndicator extends StatelessWidget {
  final bool isConnected;
  final Widget child;

  const ConnectivityIndicator({super.key, required this.isConnected, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(children: [OfflineIndicator(isConnected: isConnected), Expanded(child: child)]);
  }
}
