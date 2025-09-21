import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Coat of arms image widget with fallback handling
///
/// Provides a robust image loading experience with proper error handling,
/// loading states, and fallback options when images fail to load.
class CoatOfArmsImage extends StatefulWidget {
  /// URL of the coat of arms image
  final String? imageUrl;

  /// Width of the image container
  final double? width;

  /// Height of the image container
  final double? height;

  /// Border radius for the image
  final double borderRadius;

  const CoatOfArmsImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 16.0,
  });

  @override
  State<CoatOfArmsImage> createState() => _CoatOfArmsImageState();
}

class _CoatOfArmsImageState extends State<CoatOfArmsImage> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If no URL provided, show placeholder
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildPlaceholder(theme);
    }

    return Container(
      width: widget.width != null && widget.width!.isFinite
          ? widget.width
          : null,
      height: widget.height != null && widget.height!.isFinite
          ? widget.height
          : 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowWithOpacity,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: _hasError
            ? _buildErrorWidget(theme)
            : Image.network(
                widget.imageUrl!,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    color: AppColors.surfaceVariant,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Loading coat of arms...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Set error state and rebuild
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _hasError = true;
                      });
                    }
                  });

                  return _buildErrorWidget(theme);
                },
                // Performance optimizations
                cacheWidth: widget.width != null && widget.width!.isFinite
                    ? widget.width!.toInt()
                    : null,
                cacheHeight: (widget.height ?? 160).isFinite
                    ? (widget.height ?? 160).toInt()
                    : 160,
                filterQuality: FilterQuality.medium,
              ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      width: widget.width != null && widget.width!.isFinite
          ? widget.width
          : null,
      height: widget.height != null && widget.height!.isFinite
          ? widget.height
          : 160,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: 8),
          Text(
            'No coat of arms available',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _hasError = false;
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
