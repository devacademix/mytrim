import 'package:flutter/material.dart';
import 'package:owner/app/util/theme.dart';

/// Skeleton Loader Widgets
/// Provides reusable skeleton loading animations for better UX
/// 
/// Usage:
/// ```dart
/// // List skeleton
/// SkeletonLoader.list(itemCount: 5)
/// 
/// // Card skeleton
/// SkeletonLoader.card()
/// 
/// // Appointment skeleton
/// SkeletonLoader.appointment()
/// 
/// // Product skeleton
/// SkeletonLoader.product()
/// ```
class SkeletonLoader {
  /// Generic list skeleton loader
  static Widget list({
    int itemCount = 5,
    Widget Function(int index)? itemBuilder,
    EdgeInsets? padding,
  }) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder?.call(index) ?? card();
      },
    );
  }

  /// Generic card skeleton
  static Widget card({
    double? height,
    EdgeInsets? margin,
  }) {
    return Container(
      height: height ?? 100,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(width: double.infinity, height: 20),
            const SizedBox(height: 10),
            _shimmerBox(width: 200, height: 16),
            const Spacer(),
            _shimmerBox(width: 100, height: 14),
          ],
        ),
      ),
    );
  }

  /// Appointment card skeleton
  static Widget appointment() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _shimmerCircle(size: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: double.infinity, height: 18),
                    const SizedBox(height: 8),
                    _shimmerBox(width: 150, height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _shimmerBox(width: double.infinity, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _shimmerBox(width: double.infinity, height: 14)),
              const SizedBox(width: 20),
              Expanded(child: _shimmerBox(width: double.infinity, height: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _shimmerBox(width: double.infinity, height: 14)),
              const SizedBox(width: 20),
              _shimmerBox(width: 80, height: 24, borderRadius: 12),
            ],
          ),
        ],
      ),
    );
  }

  /// Product card skeleton
  static Widget product() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: double.infinity,
            height: 200,
            borderRadius: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: double.infinity, height: 18),
                const SizedBox(height: 8),
                _shimmerBox(width: 150, height: 14),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(width: 80, height: 20),
                    _shimmerBox(width: 60, height: 30, borderRadius: 15),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Service card skeleton
  static Widget service() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _shimmerBox(width: 80, height: 80, borderRadius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: double.infinity, height: 18),
                const SizedBox(height: 8),
                _shimmerBox(width: 120, height: 14),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(width: 80, height: 16),
                    _shimmerBox(width: 50, height: 24, borderRadius: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Order/History card skeleton
  static Widget order() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 120, height: 16),
              _shimmerBox(width: 70, height: 20, borderRadius: 10),
            ],
          ),
          const SizedBox(height: 12),
          _shimmerBox(width: double.infinity, height: 1),
          const SizedBox(height: 12),
          _shimmerBox(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          _shimmerBox(width: 180, height: 14),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 100, height: 14),
              _shimmerBox(width: 80, height: 18),
            ],
          ),
        ],
      ),
    );
  }

  /// Profile skeleton
  static Widget profile() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _shimmerCircle(size: 100),
          const SizedBox(height: 16),
          _shimmerBox(width: 150, height: 24),
          const SizedBox(height: 8),
          _shimmerBox(width: 200, height: 16),
          const SizedBox(height: 24),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _shimmerBox(width: double.infinity, height: 50, borderRadius: 10),
            ),
          ),
        ],
      ),
    );
  }

  /// Grid skeleton (for product/service grids)
  static Widget grid({
    int itemCount = 6,
    int crossAxisCount = 2,
    Widget Function(int index)? itemBuilder,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder?.call(index) ?? _gridItem();
      },
    );
  }

  static Widget _gridItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _shimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 4),
                _shimmerBox(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer box
  static Widget _shimmerBox({
    required double width,
    required double height,
    double borderRadius = 5,
  }) {
    return _ShimmerWidget(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Shimmer circle
  static Widget _shimmerCircle({required double size}) {
    return _ShimmerWidget(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Text shimmer
  static Widget text({
    double width = 100,
    double height = 16,
  }) {
    return _shimmerBox(width: width, height: height, borderRadius: 4);
  }

  /// Button shimmer
  static Widget button({
    double width = double.infinity,
    double height = 50,
  }) {
    return _shimmerBox(width: width, height: height, borderRadius: 25);
  }
}

/// Shimmer animation widget
class _ShimmerWidget extends StatefulWidget {
  final Widget child;

  const _ShimmerWidget({required this.child});

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              begin: Alignment(-1.0 + _controller.value * 2, 0.0),
              end: Alignment(1.0 + _controller.value * 2, 0.0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Loading State Widget
/// Shows skeleton or content based on loading state
class LoadingStateWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget skeleton;

  const LoadingStateWidget({
    Key? key,
    required this.isLoading,
    required this.child,
    required this.skeleton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading ? skeleton : child,
    );
  }
}

/// Empty State Widget
/// Shows when list is empty after loading
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onRetry,
    this.retryButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'bold',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'regular',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  retryButtonText ?? 'Retry',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'medium',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error State Widget
/// Shows when an error occurs
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const ErrorStateWidget({
    Key? key,
    this.title = 'Something went wrong',
    this.message = 'Please try again later',
    this.onRetry,
    this.retryButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'bold',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'regular',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  retryButtonText ?? 'Retry',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'medium',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
