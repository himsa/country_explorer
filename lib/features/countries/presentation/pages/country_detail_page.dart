import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/countries_bloc.dart';
import '../bloc/countries_event.dart';
import '../bloc/countries_state.dart';
import '../../../../core/navigation/navigation_bloc.dart';
import '../../../../core/navigation/navigation_event.dart';
import '../../../../core/navigation/navigation_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/coat_of_arms_image.dart';

class CountryDetailPage extends StatefulWidget {
  final String name;
  const CountryDetailPage({super.key, required this.name});

  @override
  State<CountryDetailPage> createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  String _flagEmoji = '🏳️';

  @override
  void initState() {
    super.initState();
    // Request cached flag emoji from NavigationBloc
    context.read<NavigationBloc>().add(RequestCachedFlagEmoji(widget.name));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is FlagEmojiProvided) {
            setState(() {
              _flagEmoji = state.flagEmoji;
            });
          }
        },
        child: BlocBuilder<CountriesBloc, CountriesState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Always show hero widget immediately for animation
                _buildSliverAppBar(context, theme, _flagEmoji),
                SliverFillRemaining(
                  child: _buildContent(context, state, theme),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CountriesState state,
    ThemeData theme,
  ) {
    if (state is CountriesLoading) {
      return _buildLoadingContent(context, theme);
    } else if (state is CountryDetailLoaded) {
      return _buildLoadedContent(context, state, theme);
    } else if (state is CountriesError) {
      return _buildErrorContent(context, state, theme);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingContent(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading country details...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    CountryDetailLoaded state,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(context, 'Basic Information', [
            _buildInfoRow(
              context,
              'Capital',
              state.country.capital,
              Icons.location_city_rounded,
            ),
            _buildInfoRow(
              context,
              'Population',
              state.country.population != null
                  ? _formatNumber(state.country.population!)
                  : 'N/A',
              Icons.people_rounded,
            ),
            _buildInfoRow(
              context,
              'Area',
              state.country.area != null
                  ? '${_formatNumber(state.country.area!)} km²'
                  : 'N/A',
              Icons.area_chart_rounded,
            ),
            if (state.country.languages?.isNotEmpty == true)
              _buildInfoRow(
                context,
                'Languages',
                state.country.languages!.join(', '),
                Icons.translate_rounded,
              ),
          ]),
          const SizedBox(height: 8),
          CoatOfArmsImage(imageUrl: state.country.coatOfArmsUrl, height: 160),
        ],
      ),
    );
  }

  Widget _buildErrorContent(
    BuildContext context,
    CountriesError state,
    ThemeData theme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load country details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                context.read<CountriesBloc>().add(
                  LoadCountryDetail(widget.name),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    ThemeData theme,
    String flagEmoji,
  ) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      title: Text(
        widget.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      backgroundColor: AppColors.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      foregroundColor: AppColors.textPrimary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.backgroundGradient,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Hero(
              tag: 'flag-${widget.name}',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppConstants.flagBorderRadius,
                    ),
                    border: Border.all(color: AppColors.border, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowWithOpacity,
                        blurRadius: 12, // Increased shadow
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      flagEmoji,
                      style: const TextStyle(fontSize: 64), // Increased from 48
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
