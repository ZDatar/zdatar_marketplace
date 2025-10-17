import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/dataset.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/marketplace_providers.dart';
import 'category_chip.dart';

class MarketplaceFiltersWidget extends ConsumerWidget {
  const MarketplaceFiltersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filters = ref.watch(marketplaceFiltersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categories
        _buildSection(
          theme,
          'Categories',
          _buildCategoriesFilter(context, ref, filters),
        ),
        
        const SizedBox(height: 16),
        
        // Price Range
        _buildSection(
          theme,
          'Price Range',
          _buildPriceRangeFilter(context, ref, filters),
        ),
        
        const SizedBox(height: 16),
        
        // Currency
        _buildSection(
          theme,
          'Currency',
          _buildCurrencyFilter(context, ref, filters),
        ),
        
        const SizedBox(height: 16),
        
        // Date Range
        _buildSection(
          theme,
          'Data Date Range',
          _buildDateRangeFilter(context, ref, filters),
        ),
        
        const SizedBox(height: 16),
        
        // File Size
        _buildSection(
          theme,
          'File Size',
          _buildFileSizeFilter(context, ref, filters),
        ),
        
        const SizedBox(height: 16),
        
        // Additional Filters
        _buildSection(
          theme,
          'Additional Filters',
          _buildAdditionalFilters(context, ref, filters),
        ),
        
        const SizedBox(height: 16),
        
        // Action Buttons
        _buildActionButtons(context, ref),
      ],
    );
  }

  Widget _buildSection(ThemeData theme, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildCategoriesFilter(BuildContext context, WidgetRef ref, MarketplaceFilters filters) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DatasetCategory.values.map((category) {
        final isSelected = filters.categories.contains(category);
        return CategoryChip(
          category: category,
          isSelected: isSelected,
          onTap: () {
            ref.read(marketplaceFiltersProvider.notifier).toggleCategory(category);
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeFilter(BuildContext context, WidgetRef ref, MarketplaceFilters filters) {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(filters.minPrice, filters.maxPrice),
          min: 0,
          max: 1000,
          divisions: 100,
          labels: RangeLabels(
            '\$${filters.minPrice.toInt()}',
            '\$${filters.maxPrice.toInt()}',
          ),
          onChanged: (RangeValues values) {
            ref.read(marketplaceFiltersProvider.notifier).updatePriceRange(
              values.start,
              values.end,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${filters.minPrice.toInt()}'),
            Text('\$${filters.maxPrice.toInt()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyFilter(BuildContext context, WidgetRef ref, MarketplaceFilters filters) {
    return Wrap(
      spacing: 8,
      children: AppConstants.supportedTokens.map((currency) {
        final isSelected = filters.currencies.contains(currency);
        return FilterChip(
          label: Text(currency),
          selected: isSelected,
          onSelected: (selected) {
            ref.read(marketplaceFiltersProvider.notifier).toggleCurrency(currency);
          },
        );
      }).toList(),
    );
  }

  Widget _buildDateRangeFilter(BuildContext context, WidgetRef ref, MarketplaceFilters filters) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(context, ref, true),
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(
              filters.startDate != null
                  ? '${filters.startDate!.day}/${filters.startDate!.month}/${filters.startDate!.year}'
                  : 'Start Date',
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('to'),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(context, ref, false),
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(
              filters.endDate != null
                  ? '${filters.endDate!.day}/${filters.endDate!.month}/${filters.endDate!.year}'
                  : 'End Date',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileSizeFilter(BuildContext context, WidgetRef ref, MarketplaceFilters filters) {
    const fileSizeOptions = [
      'Any Size',
      '< 1MB',
      '1MB - 10MB',
      '10MB - 100MB',
      '> 100MB',
    ];

    return Wrap(
      spacing: 8,
      children: fileSizeOptions.map((size) {
        final isSelected = filters.fileSize == size;
        return FilterChip(
          label: Text(size),
          selected: isSelected,
          onSelected: (selected) {
            ref.read(marketplaceFiltersProvider.notifier).updateFileSize(
              selected ? size : null,
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalFilters(BuildContext context, WidgetRef ref, MarketplaceFilters filters) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Has Sample Data'),
          value: filters.hasSample,
          onChanged: (value) {
            ref.read(marketplaceFiltersProvider.notifier).toggleHasSample();
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Verified Sellers Only'),
          value: filters.verifiedSellersOnly,
          onChanged: (value) {
            ref.read(marketplaceFiltersProvider.notifier).toggleVerifiedSellers();
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('High Rated (4+ stars)'),
          value: filters.highRatedOnly,
          onChanged: (value) {
            ref.read(marketplaceFiltersProvider.notifier).toggleHighRated();
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ref.read(marketplaceFiltersProvider.notifier).clearFilters();
            },
            child: const Text('Clear All'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ref.read(marketplaceNotifierProvider.notifier).applyFilters();
            },
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      if (isStartDate) {
        ref.read(marketplaceFiltersProvider.notifier).updateStartDate(picked);
      } else {
        ref.read(marketplaceFiltersProvider.notifier).updateEndDate(picked);
      }
    }
  }
}
