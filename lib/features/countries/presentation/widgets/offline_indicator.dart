import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Offline indicator widget with improved visibility
///
/// Shows a clear, visible indicator when the app is offline
/// with proper contrast and sizing for better user experience.
class OfflineIndicator extends StatelessWidget {
  /// Whether the app is currently offline
  final bool isOffline;

  /// Custom message to display (optional)
  final String? message;

  const OfflineIndicator({super.key, required this.isOffline, this.message});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.errorWithOpacity,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Enhanced icon container with better visibility
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorWithOpacity,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 20, // Increased from 16 to 20
              color: Colors.white, // White icon for better contrast
            ),
          ),
          const SizedBox(width: 12),
          // Enhanced text with better contrast
          Expanded(
            child: Text(
              message ?? 'You are offline. Showing cached data.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          // Enhanced offline badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorWithOpacity,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'OFFLINE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
