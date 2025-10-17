import 'package:flutter/material.dart';
import '../../../../models/dataset.dart';

class MetadataForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DatasetCategory? selectedCategory;
  final List<String> tags;
  final String? selectedRegion;
  final DateTime? dataStartDate;
  final DateTime? dataEndDate;
  final bool hasSample;
  final Function(DatasetCategory?) onCategoryChanged;
  final Function(List<String>) onTagsChanged;
  final Function(String?) onRegionChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(bool) onHasSampleChanged;

  const MetadataForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.tags,
    required this.selectedRegion,
    required this.dataStartDate,
    required this.dataEndDate,
    required this.hasSample,
    required this.onCategoryChanged,
    required this.onTagsChanged,
    required this.onRegionChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onHasSampleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          _buildSection(
            theme,
            'Dataset Title *',
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter a descriptive title for your dataset',
              ),
              maxLength: 100,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          _buildSection(
            theme,
            'Description *',
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Describe your dataset, its contents, and potential use cases',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Category
          _buildSection(
            theme,
            'Category *',
            _buildCategorySelector(theme),
          ),
          
          const SizedBox(height: 16),
          
          // Tags
          _buildSection(
            theme,
            'Tags',
            _buildTagsInput(theme),
          ),
          
          const SizedBox(height: 16),
          
          // Region
          _buildSection(
            theme,
            'Geographic Region',
            _buildRegionSelector(theme),
          ),
          
          const SizedBox(height: 16),
          
          // Date Range
          _buildSection(
            theme,
            'Data Collection Period *',
            _buildDateRangeSelector(theme, context),
          ),
          
          const SizedBox(height: 16),
          
          // Sample Data Option
          _buildSection(
            theme,
            'Sample Data',
            _buildSampleOption(theme),
          ),
        ],
      ),
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

  Widget _buildCategorySelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DatasetCategory.values.map((category) {
        final isSelected = selectedCategory == category;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.icon),
              const SizedBox(width: 4),
              Text(category.displayName),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            onCategoryChanged(selected ? category : null);
          },
          selectedColor: theme.colorScheme.primary.withOpacity(0.2),
          checkmarkColor: theme.colorScheme.primary,
        );
      }).toList(),
    );
  }

  Widget _buildTagsInput(ThemeData theme) {
    final tagController = TextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: tagController,
          decoration: InputDecoration(
            hintText: 'Enter tags separated by commas',
            suffixIcon: IconButton(
              onPressed: () => _addTags(tagController.text),
              icon: const Icon(Icons.add),
            ),
          ),
          onSubmitted: _addTags,
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeTag(tag),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          'Add relevant tags to help buyers find your dataset',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionSelector(ThemeData theme) {
    const regions = [
      'Global',
      'North America',
      'South America',
      'Europe',
      'Asia',
      'Africa',
      'Oceania',
      'India',
      'United States',
      'China',
      'Other',
    ];

    return DropdownButtonFormField<String>(
      value: selectedRegion,
      decoration: const InputDecoration(
        hintText: 'Select geographic region',
      ),
      items: regions.map((region) {
        return DropdownMenuItem(
          value: region,
          child: Text(region),
        );
      }).toList(),
      onChanged: onRegionChanged,
    );
  }

  Widget _buildDateRangeSelector(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(context, true),
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(
              dataStartDate != null
                  ? '${dataStartDate!.day}/${dataStartDate!.month}/${dataStartDate!.year}'
                  : 'Start Date',
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text('to'),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(context, false),
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(
              dataEndDate != null
                  ? '${dataEndDate!.day}/${dataEndDate!.month}/${dataEndDate!.year}'
                  : 'End Date',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSampleOption(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Provide Sample Data'),
          subtitle: const Text('Allow buyers to preview a sample of your dataset'),
          value: hasSample,
          onChanged: onHasSampleChanged,
          contentPadding: EdgeInsets.zero,
        ),
        if (hasSample) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sample data helps buyers understand your dataset quality and increases sales potential.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _addTags(String input) {
    if (input.trim().isEmpty) return;
    
    final newTags = input
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty && !tags.contains(tag))
        .toList();
    
    if (newTags.isNotEmpty) {
      onTagsChanged([...tags, ...newTags]);
    }
  }

  void _removeTag(String tag) {
    final updatedTags = List<String>.from(tags);
    updatedTags.remove(tag);
    onTagsChanged(updatedTags);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      if (isStartDate) {
        onStartDateChanged(picked);
      } else {
        onEndDateChanged(picked);
      }
    }
  }
}
