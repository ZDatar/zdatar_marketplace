import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/dataset.dart';

// View Mode Provider
enum ViewMode { grid, list }
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.grid);

// Sort Options
enum SortOption {
  newest,
  oldest,
  priceLowToHigh,
  priceHighToLow,
  mostPopular,
  highestRated,
}

// Marketplace Filters State
class MarketplaceFilters {
  final String searchQuery;
  final List<DatasetCategory> categories;
  final double minPrice;
  final double maxPrice;
  final List<String> currencies;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? fileSize;
  final bool hasSample;
  final bool verifiedSellersOnly;
  final bool highRatedOnly;
  final SortOption sortOption;

  const MarketplaceFilters({
    this.searchQuery = '',
    this.categories = const [],
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.currencies = const [],
    this.startDate,
    this.endDate,
    this.fileSize,
    this.hasSample = false,
    this.verifiedSellersOnly = false,
    this.highRatedOnly = false,
    this.sortOption = SortOption.newest,
  });

  MarketplaceFilters copyWith({
    String? searchQuery,
    List<DatasetCategory>? categories,
    double? minPrice,
    double? maxPrice,
    List<String>? currencies,
    DateTime? startDate,
    DateTime? endDate,
    String? fileSize,
    bool? hasSample,
    bool? verifiedSellersOnly,
    bool? highRatedOnly,
    SortOption? sortOption,
  }) {
    return MarketplaceFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      currencies: currencies ?? this.currencies,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      fileSize: fileSize ?? this.fileSize,
      hasSample: hasSample ?? this.hasSample,
      verifiedSellersOnly: verifiedSellersOnly ?? this.verifiedSellersOnly,
      highRatedOnly: highRatedOnly ?? this.highRatedOnly,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

// Marketplace Filters Notifier
class MarketplaceFiltersNotifier extends StateNotifier<MarketplaceFilters> {
  MarketplaceFiltersNotifier() : super(const MarketplaceFilters());

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleCategory(DatasetCategory category) {
    final categories = List<DatasetCategory>.from(state.categories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(categories: categories);
  }

  void updatePriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void toggleCurrency(String currency) {
    final currencies = List<String>.from(state.currencies);
    if (currencies.contains(currency)) {
      currencies.remove(currency);
    } else {
      currencies.add(currency);
    }
    state = state.copyWith(currencies: currencies);
  }

  void updateStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void updateEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void updateFileSize(String? size) {
    state = state.copyWith(fileSize: size);
  }

  void toggleHasSample() {
    state = state.copyWith(hasSample: !state.hasSample);
  }

  void toggleVerifiedSellers() {
    state = state.copyWith(verifiedSellersOnly: !state.verifiedSellersOnly);
  }

  void toggleHighRated() {
    state = state.copyWith(highRatedOnly: !state.highRatedOnly);
  }

  void updateSort(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearFilters() {
    state = const MarketplaceFilters();
  }
}

final marketplaceFiltersProvider = StateNotifierProvider<MarketplaceFiltersNotifier, MarketplaceFilters>(
  (ref) => MarketplaceFiltersNotifier(),
);

// Marketplace State
class MarketplaceState {
  final List<Dataset> datasets;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int page;

  const MarketplaceState({
    this.datasets = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.page = 1,
  });

  MarketplaceState copyWith({
    List<Dataset>? datasets,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? page,
  }) {
    return MarketplaceState(
      datasets: datasets ?? this.datasets,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      page: page ?? this.page,
    );
  }
}

// Marketplace Notifier
class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  MarketplaceNotifier() : super(const MarketplaceState()) {
    loadDatasets();
  }

  Future<void> loadDatasets() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newDatasets = _generateMockDatasets(state.page);
      
      state = state.copyWith(
        datasets: state.page == 1 ? newDatasets : [...state.datasets, ...newDatasets],
        isLoading: false,
        hasMore: newDatasets.isNotEmpty,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadDatasets();
  }

  Future<void> refresh() async {
    state = const MarketplaceState();
    await loadDatasets();
  }

  Future<void> applyFilters() async {
    state = const MarketplaceState();
    await loadDatasets();
  }

  List<Dataset> _generateMockDatasets(int page) {
    // Generate mock datasets for demonstration
    if (page > 3) return []; // Simulate end of data

    return List.generate(10, (index) {
      final id = ((page - 1) * 10 + index + 1).toString();
      return Dataset(
        id: id,
        title: 'Dataset $id',
        description: 'This is a sample dataset description for dataset $id',
        sellerId: 'seller$id',
        category: DatasetCategory.values[index % DatasetCategory.values.length],
        tags: ['tag1', 'tag2', 'tag3'],
        price: 50.0 + (index * 25.0),
        currency: ['SOL', 'USDC', 'ZDATA'][index % 3],
        fileSizeBytes: (1 + index) * 1024 * 1024,
        fileType: ['json', 'csv', 'parquet'][index % 3],
        dataStartDate: DateTime.now().subtract(Duration(days: 30 + index)),
        dataEndDate: DateTime.now().subtract(Duration(days: index)),
        region: ['Global', 'North America', 'Europe', 'Asia'][index % 4],
        encryptedFileUrl: 'https://storage.zdatar.com/encrypted/$id',
        encryptionKeyHash: 'hash$id',
        status: DatasetStatus.active,
        totalSales: 10 + (index * 5),
        rating: 3.5 + (index % 3) * 0.5,
        reviewCount: 5 + (index * 2),
        createdAt: DateTime.now().subtract(Duration(days: 10 + index)),
        updatedAt: DateTime.now().subtract(Duration(days: index)),
        hasSample: index % 3 == 0,
      );
    });
  }
}

final marketplaceNotifierProvider = StateNotifierProvider<MarketplaceNotifier, MarketplaceState>(
  (ref) => MarketplaceNotifier(),
);
