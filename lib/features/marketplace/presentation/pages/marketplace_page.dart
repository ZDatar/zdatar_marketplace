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
  bool _showFilters = false;

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
      // Load more datasets
      ref.read(marketplaceNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final marketplaceState = ref.watch(marketplaceNotifierProvider);
    final filters = ref.watch(marketplaceFiltersProvider);

    return Scaffold(
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(context, theme),
          
          // Filter Panel (if shown)
          if (_showFilters) _buildFilterPanel(context, theme),
          
          // Results Count and Sort
          _buildResultsHeader(context, theme, marketplaceState.datasets.length),
          
          // Dataset Grid
          Expanded(
            child: _buildDatasetGrid(context, marketplaceState),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search datasets...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                ref.read(marketplaceFiltersProvider.notifier).updateSearch(value);
              },
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Filter Button
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            style: IconButton.styleFrom(
              backgroundColor: _showFilters 
                ? theme.colorScheme.primary.withOpacity(0.1)
                : null,
            ),
          ),
          
          // Sort Button
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (sortOption) {
              ref.read(marketplaceFiltersProvider.notifier).updateSort(sortOption);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.newest,
                child: Text('Newest First'),
              ),
              const PopupMenuItem(
                value: SortOption.oldest,
                child: Text('Oldest First'),
              ),
              const PopupMenuItem(
                value: SortOption.priceLowToHigh,
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem(
                value: SortOption.priceHighToLow,
                child: Text('Price: High to Low'),
              ),
              const PopupMenuItem(
                value: SortOption.mostPopular,
                child: Text('Most Popular'),
              ),
              const PopupMenuItem(
                value: SortOption.highestRated,
                child: Text('Highest Rated'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: const MarketplaceFiltersWidget(),
    );
  }

  Widget _buildResultsHeader(BuildContext context, ThemeData theme, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            '$count datasets found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          // View Toggle
          SegmentedButton<ViewMode>(
            segments: const [
              ButtonSegment(
                value: ViewMode.grid,
                icon: Icon(Icons.grid_view, size: 16),
              ),
              ButtonSegment(
                value: ViewMode.list,
                icon: Icon(Icons.list, size: 16),
              ),
            ],
            selected: {ref.watch(viewModeProvider)},
            onSelectionChanged: (Set<ViewMode> selection) {
              ref.read(viewModeProvider.notifier).state = selection.first;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatasetGrid(BuildContext context, MarketplaceState state) {
    if (state.isLoading && state.datasets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.datasets.isEmpty) {
      return _buildEmptyState(context);
    }

    final viewMode = ref.watch(viewModeProvider);
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(marketplaceNotifierProvider.notifier).refresh();
      },
      child: viewMode == ViewMode.grid
          ? _buildGridView(state)
          : _buildListView(state),
    );
  }

  Widget _buildGridView(MarketplaceState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.datasets.length + (state.isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= state.datasets.length) {
          return const Card(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        return DatasetCard(dataset: state.datasets[index]);
      },
    );
  }

  Widget _buildListView(MarketplaceState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.datasets.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.datasets.length) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DatasetCard(
            dataset: state.datasets[index],
            isListView: true,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No datasets found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(marketplaceFiltersProvider.notifier).clearFilters();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}
