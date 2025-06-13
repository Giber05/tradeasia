import 'package:flutter/material.dart';
import 'package:trade_asia/infrastructure/constants/app_theme.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({super.key, required this.child, this.isLoading = true});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
              stops: [_animation.value - 1, _animation.value, _animation.value + 1],
              transform: GradientRotation(0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const LoadingSpinner({super.key, this.size = 24.0, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? AppTheme.primaryBlue),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppTheme.spacingL),
          Text(message!, style: AppTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({super.key, required this.width, required this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusS),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({super.key, required this.width, this.height = 16.0});

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: height, borderRadius: BorderRadius.circular(AppTheme.radiusS / 2));
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Card(
        elevation: AppTheme.elevationS,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusL)),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              const SkeletonBox(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Title skeleton
              const SkeletonText(width: double.infinity, height: 18),
              const SizedBox(height: AppTheme.spacingS),
              const SkeletonText(width: 150, height: 14),
              const SizedBox(height: AppTheme.spacingM),

              // Info rows skeleton
              Row(
                children: [
                  const SkeletonText(width: 80, height: 12),
                  const SizedBox(width: AppTheme.spacingS),
                  const Expanded(child: SkeletonText(width: 100, height: 12)),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
              Row(
                children: [
                  const SkeletonText(width: 80, height: 12),
                  const SizedBox(width: AppTheme.spacingS),
                  const Expanded(child: SkeletonText(width: 120, height: 12)),
                ],
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Button skeleton
              Row(
                children: [
                  Expanded(
                    child: SkeletonBox(
                      width: double.infinity,
                      height: 40,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  SkeletonBox(width: 40, height: 40, borderRadius: BorderRadius.circular(AppTheme.radiusS)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPageSkeleton extends StatelessWidget {
  const DetailPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          // Header image skeleton
          const SkeletonBox(width: double.infinity, height: 300),
          const SizedBox(height: AppTheme.spacingL),

          // Content cards skeleton
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacingXL),
              children: [
                // Title card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonText(width: double.infinity, height: 24),
                        const SizedBox(height: AppTheme.spacingS),
                        const SkeletonText(width: 200, height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),

                // Info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                          child: Row(
                            children: [
                              const SkeletonText(width: 100, height: 14),
                              const SizedBox(width: AppTheme.spacingL),
                              const Expanded(child: SkeletonText(width: 150, height: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),

                // Description card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      children: [
                        const SkeletonText(width: double.infinity, height: 16),
                        const SizedBox(height: AppTheme.spacingS),
                        const SkeletonText(width: double.infinity, height: 16),
                        const SizedBox(height: AppTheme.spacingS),
                        const SkeletonText(width: 250, height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({super.key, required this.child, this.duration = const Duration(milliseconds: 1000)});

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: widget.child);
      },
    );
  }
}
