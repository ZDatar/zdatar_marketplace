import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/dataset_card.dart';
import '../widgets/marketplace_filters.dart';
import '../providers/marketplace_providers.dart';

class MarketplacePage extends ConsumerStatefulWidget {
  const MarketplacePage({super.key});

  @override
  ConsumerState<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends ConsumerState<MarketplacePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(marketplaceNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final marketplaceState = ref.watch(marketplaceNotifierProvider);

    return Container(
      color: theme.colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar - Filters
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebarHeader(theme),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: MarketplaceFiltersWidget(),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, theme, marketplaceState.datasets.length),
                Expanded(
                  child: _buildDatasetGrid(context, theme, marketplaceState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Refine your search to find the perfect dataset',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeData theme, int datasetCount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildSearchBar(theme),
          ),
          const SizedBox(width: 24),
          Text(
            '$datasetCount datasets found',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 24),
          _buildSortDropdown(theme),
          const SizedBox(width: 16),
          _buildViewModeToggle(theme),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        onChanged: (value) {
          ref.read(marketplaceFiltersProvider.notifier).updateSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Search datasets...',
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSortDropdown(ThemeData theme) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOption>(
          value: ref.watch(marketplaceFiltersProvider).sortOption,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: SortOption.values.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(_getSortLabel(option)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(marketplaceFiltersProvider.notifier).updateSort(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildViewModeToggle(ThemeData theme) {
    final viewMode = ref.watch(viewModeProvider);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewModeButton(
              theme, Icons.grid_view, ViewMode.grid, viewMode == ViewMode.grid),
          _buildViewModeButton(
              theme, Icons.view_list, ViewMode.list, viewMode == ViewMode.list),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
      ThemeData theme, IconData icon, ViewMode mode, bool isSelected) {
    return InkWell(
      onTap: () => ref.read(viewModeProvider.notifier).state = mode,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildDatasetGrid(
      BuildContext context, ThemeData theme, MarketplaceState state) {
    final viewMode = ref.watch(viewModeProvider);

    if (state.isLoading && state.datasets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Error loading datasets',
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(marketplaceNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.datasets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dataset_outlined,
                size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No datasets found', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: viewMode == ViewMode.grid
          ? _buildGridView(state)
          : _buildListView(state),
    );
  }

  Widget _buildGridView(MarketplaceState state) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: state.datasets.length + (state.isLoading ? 3 : 0),
      itemBuilder: (context, index) {
        if (index >= state.datasets.length) {
          return const Card(child: Center(child: CircularProgressIndicator()));
        }
        return DatasetCard(dataset: state.datasets[index]);
      },
    );
  }

  Widget _buildListView(MarketplaceState state) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: state.datasets.length + (state.isLoading ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index >= state.datasets.length) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return DatasetCard(dataset: state.datasets[index], isListView: true);
      },
    );
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.newest:
        return 'Newest';
      case SortOption.oldest:
        return 'Oldest';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.mostPopular:
        return 'Most Popular';
      case SortOption.highestRated:
        return 'Highest Rated';
    }
  }
}
