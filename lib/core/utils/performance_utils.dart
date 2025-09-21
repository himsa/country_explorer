import 'dart:async';
import 'package:flutter/material.dart';

/// Performance utilities for optimizing app performance
///
/// Provides helper functions and widgets for better performance
/// and smoother user experience.
class PerformanceUtils {
  // Private constructor to prevent instantiation
  PerformanceUtils._();

  /// Creates a debounced function that delays execution
  /// until after wait time has elapsed since last invocation
  static Function debounce(
    Function func, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => func());
    };
  }

  /// Creates a throttled function that limits execution
  /// to once per specified time period
  static Function throttle(
    Function func, {
    Duration limit = const Duration(milliseconds: 100),
  }) {
    bool isThrottled = false;

    return () {
      if (isThrottled) return;

      isThrottled = true;
      func();

      Timer(limit, () {
        isThrottled = false;
      });
    };
  }

  /// Optimized list view builder for large datasets
  static Widget optimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      // Performance optimizations
      cacheExtent: 200.0, // Cache 200 pixels worth of children
      addAutomaticKeepAlives: false, // Don't keep children alive
      addRepaintBoundaries: true, // Add repaint boundaries
      addSemanticIndexes: false, // Don't add semantic indexes
    );
  }

  /// Optimized grid view builder for large datasets
  static Widget optimizedGridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required int crossAxisCount,
    double childAspectRatio = 1.0,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return GridView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      // Performance optimizations
      cacheExtent: 200.0,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
    );
  }

  /// Creates a lazy loading widget that only builds when visible
  static Widget lazyBuilder({
    required Widget Function() builder,
    Widget? placeholder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > 0) {
          return builder();
        }
        return placeholder ?? const SizedBox.shrink();
      },
    );
  }

  /// Memory-efficient image loading
  static Widget optimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? const CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Icon(Icons.error);
      },
      // Performance optimizations
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      filterQuality: FilterQuality.medium,
    );
  }
}
