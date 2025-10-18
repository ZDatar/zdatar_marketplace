import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../models/dataset.dart';

class PreviewSection extends StatelessWidget {
  final PlatformFile? file;
  final String title;
  final String description;
  final DatasetCategory? category;
  final List<String> tags;
  final double price;
  final String currency;
  final String? region;
  final DateTime? dataStartDate;
  final DateTime? dataEndDate;
  final bool hasSample;

  const PreviewSection({
    super.key,
    required this.file,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.price,
    required this.currency,
    required this.region,
    required this.dataStartDate,
    required this.dataEndDate,
    required this.hasSample,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dataset Preview Card
          _buildDatasetPreview(theme),

          const SizedBox(height: 16),

          // File Information
          _buildFileInformation(theme),

          const SizedBox(height: 16),

          // Metadata Summary
          _buildMetadataSummary(theme),

          const SizedBox(height: 16),

          // Pricing Summary
          _buildPricingSummary(theme),

          const SizedBox(height: 16),

          // Publishing Checklist
          _buildPublishingChecklist(theme),
        ],
      ),
    );
  }

  Widget _buildDatasetPreview(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dataset Preview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Title and Category
            Row(
              children: [
                Expanded(
                  child: Text(
                    title.isNotEmpty ? title : 'Untitled Dataset',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (category != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category!.icon),
                        const SizedBox(width: 4),
                        Text(
                          category!.displayName,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              description.isNotEmpty ? description : 'No description provided',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: description.isEmpty
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : null,
              ),
            ),

            const SizedBox(height: 12),

            // Tags
            if (tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // Price
            Row(
              children: [
                Text(
                  'Price: ',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '${price.toStringAsFixed(2)} $currency',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (hasSample)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sample Available',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInformation(ThemeData theme) {
    if (file == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'No file selected',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ),
        ),
      );
    }

    final fileSizeInMB = (file!.size / (1024 * 1024)).toStringAsFixed(2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'File Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(theme, 'File Name', file!.name),
            _buildInfoRow(theme, 'File Size', '${fileSizeInMB}MB'),
            _buildInfoRow(theme, 'File Type',
                file!.extension?.toUpperCase() ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataSummary(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metadata Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (region != null) _buildInfoRow(theme, 'Region', region!),
            if (dataStartDate != null && dataEndDate != null)
              _buildInfoRow(theme, 'Data Period',
                  '${dataStartDate!.day}/${dataStartDate!.month}/${dataStartDate!.year} - ${dataEndDate!.day}/${dataEndDate!.month}/${dataEndDate!.year}'),
            _buildInfoRow(
                theme, 'Tags', tags.isNotEmpty ? tags.join(', ') : 'None'),
            _buildInfoRow(theme, 'Sample Data', hasSample ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSummary(ThemeData theme) {
    final platformFee = price * 0.025;
    final youReceive = price - platformFee;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(theme, 'Dataset Price',
                '${price.toStringAsFixed(2)} $currency'),
            _buildInfoRow(theme, 'Platform Fee (2.5%)',
                '${platformFee.toStringAsFixed(2)} $currency'),
            const Divider(),
            _buildInfoRow(
              theme,
              'You Receive',
              '${youReceive.toStringAsFixed(2)} $currency',
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishingChecklist(ThemeData theme) {
    final checklist = [
      ChecklistItem('File uploaded', file != null),
      ChecklistItem('Title provided', title.isNotEmpty),
      ChecklistItem('Description provided', description.isNotEmpty),
      ChecklistItem('Category selected', category != null),
      ChecklistItem('Price set', price > 0),
      ChecklistItem('Data period specified',
          dataStartDate != null && dataEndDate != null),
    ];

    final completedItems = checklist.where((item) => item.isCompleted).length;
    final allCompleted = completedItems == checklist.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  allCompleted ? Icons.check_circle : Icons.checklist,
                  color: allCompleted
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Publishing Checklist',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$completedItems/${checklist.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: allCompleted
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...checklist.map((item) => _buildChecklistItem(theme, item)),
            if (!allCompleted) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please complete all required fields before publishing.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isHighlighted ? FontWeight.w600 : null,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                color: isHighlighted ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(ThemeData theme, ChecklistItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            item.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 16,
            color: item.isCompleted
                ? theme.colorScheme.secondary
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Text(
            item.title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: item.isCompleted
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistItem {
  final String title;
  final bool isCompleted;

  ChecklistItem(this.title, this.isCompleted);
}
