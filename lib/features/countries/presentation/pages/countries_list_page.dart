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
import '../widgets/offline_indicator.dart';
import 'country_detail_page.dart';

class CountriesListPage extends StatelessWidget {
  const CountriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, navigationState) {
        if (navigationState is NavigateToDetail) {
          // Handle navigation - only UI logic, no business logic
          final countriesBloc = context.read<CountriesBloc>();
          final navigationBloc = context.read<NavigationBloc>();

          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: countriesBloc),
                      BlocProvider.value(value: navigationBloc),
                    ],
                    child: CountryDetailPage(name: navigationState.countryName),
                  ),
                ),
              )
              .then((_) {
                // Schedule return navigation - business logic moved to NavigationBloc
                navigationBloc.add(const ScheduleReturnNavigation());
              });
        } else if (navigationState is DataLoadingScheduled) {
          // Handle scheduled data loading - triggered by NavigationBloc
          context.read<CountriesBloc>().add(
            LoadCountryDetail(navigationState.countryName),
          );
        } else if (navigationState is ReturnNavigationScheduled) {
          // Handle scheduled return navigation - triggered by NavigationBloc
          context.read<NavigationBloc>().add(const NavigateBack());
        } else if (navigationState is NavigateBackToCountries) {
          // Restore countries list when navigating back
          context.read<CountriesBloc>().add(ReturnToCountriesList());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Countries Explorer',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () {
                context.read<CountriesBloc>().add(RefreshCountries());
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, const Color(0xFFF8FAFC)],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<CountriesBloc, CountriesState>(
              builder: (context, state) {
                if ((state is CountriesLoaded && state.isFromCache) ||
                    (state is CountryDetailLoaded &&
                        state.countries.isNotEmpty)) {
                  return const OfflineIndicator(
                    isOffline: true,
                    message: 'Showing cached data',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocListener<CountriesBloc, CountriesState>(
                listener: (context, state) {
                  if (state is CountriesError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: theme.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Retry',
                          textColor: theme.colorScheme.onError,
                          onPressed: () {
                            context.read<CountriesBloc>().add(LoadCountries());
                          },
                        ),
                      ),
                    );
                  }
                },
                child: BlocBuilder<CountriesBloc, CountriesState>(
                  builder: (context, state) {
                    if (state is CountriesLoading && state.countries.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.1),
                                    const Color(
                                      0xFF8B5CF6,
                                    ).withValues(alpha: 0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: const Color(0xFF6366F1),
                                backgroundColor: const Color(0xFFE2E8F0),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Loading countries...',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fetching data from around the world',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is CountriesLoaded ||
                        state is CountryDetailLoaded) {
                      // Handle both CountriesLoaded and CountryDetailLoaded states
                      final countries = state is CountriesLoaded
                          ? state.countries
                          : (state as CountryDetailLoaded).countries;
                      return RefreshIndicator(
                        color: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.surface,
                        strokeWidth: 2.5,
                        onRefresh: () async {
                          context.read<CountriesBloc>().add(RefreshCountries());
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.public_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${countries.length} countries',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              sliver: SliverList.separated(
                                itemCount: countries.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final country = countries[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.defaultPadding,
                                      vertical: AppConstants.cardMargin,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.largeRadius,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.shadowWithOpacity,
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                        BoxShadow(
                                          color:
                                              AppColors.shadowLightWithOpacity,
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                      leading: Hero(
                                        tag: 'flag-${country.name}',
                                        flightShuttleBuilder:
                                            (
                                              flightContext,
                                              animation,
                                              flightDirection,
                                              fromHeroContext,
                                              toHeroContext,
                                            ) {
                                              return Material(
                                                color: Colors.transparent,
                                                child: ScaleTransition(
                                                  scale: animation,
                                                  child: Container(
                                                    width: 120,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppConstants
                                                                .flagBorderRadius,
                                                          ),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: AppColors
                                                            .flagGradient,
                                                      ),
                                                      border: Border.all(
                                                        color: AppColors.border,
                                                        width: 1.5,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors
                                                              .shadowLightWithOpacity,
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                            0,
                                                            1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        country.flagEmoji,
                                                        style: const TextStyle(
                                                          fontSize: 48,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: 56,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: theme.dividerColor,
                                                width: 0.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                country.flagEmoji,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        country.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            Icons.location_city_rounded,
                                            size: 14,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              country.capital,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: theme
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.6),
                                      ),
                                      onTap: () {
                                        // Use NavigationBloc for navigation logic
                                        context.read<NavigationBloc>().add(
                                          NavigateToCountryDetail(country.name),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is CountriesError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFEF2F2),
                                      const Color(0xFFFEE2E2),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFDC2626,
                                      ).withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: const Color(0xFFDC2626),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Oops! Something went wrong',
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
                                    LoadCountries(),
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
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
