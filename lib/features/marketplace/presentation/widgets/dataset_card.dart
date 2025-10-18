import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/dataset.dart';
import '../../../../core/router/app_router.dart';

class DatasetCard extends StatelessWidget {
  final Dataset dataset;
  final bool isListView;

  const DatasetCard({
    super.key,
    required this.dataset,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('${AppRoutes.datasetDetail}/${dataset.id}'),
        child: isListView ? _buildListLayout(theme) : _buildGridLayout(theme),
      ),
    );
  }

  Widget _buildGridLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview Image or Category Icon
        _buildPreviewSection(theme, height: 120),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  dataset.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  dataset.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Stats Row
                _buildStatsRow(theme, isCompact: true),

                const SizedBox(height: 8),

                // Price and Action
                _buildPriceRow(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListLayout(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Image
          _buildPreviewSection(theme, width: 80, height: 80),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Category
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dataset.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildCategoryChip(theme),
                  ],
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  dataset.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Stats and Price
                Row(
                  children: [
                    Expanded(child: _buildStatsRow(theme)),
                    _buildPriceRow(theme),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(ThemeData theme,
      {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: width != null ? BorderRadius.circular(8) : null,
      ),
      child: dataset.previewImageUrl != null
          ? CachedNetworkImage(
              imageUrl: dataset.previewImageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildPlaceholder(theme),
              errorWidget: (context, url, error) => _buildPlaceholder(theme),
            )
          : _buildPlaceholder(theme),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dataset.category.icon,
              style: const TextStyle(fontSize: 24),
            ),
            if (!isListView) ...[
              const SizedBox(height: 4),
              Text(
                dataset.category.displayName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(dataset.category.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            dataset.category.displayName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, {bool isCompact = false}) {
    return Row(
      children: [
        // Rating
        Icon(
          Icons.star,
          size: isCompact ? 12 : 14,
          color: Colors.amber,
        ),
        const SizedBox(width: 2),
        Text(
          dataset.rating.toStringAsFixed(1),
          style: (isCompact
                  ? theme.textTheme.bodySmall
                  : theme.textTheme.bodyMedium)
              ?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),

        if (!isCompact) ...[
          const SizedBox(width: 4),
          Text(
            '(${dataset.reviewCount})',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],

        const SizedBox(width: 12),

        // Sales
        Icon(
          Icons.shopping_cart,
          size: isCompact ? 12 : 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 2),
        Text(
          '${dataset.totalSales}',
          style: (isCompact
                  ? theme.textTheme.bodySmall
                  : theme.textTheme.bodyMedium)
              ?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),

        if (!isCompact) ...[
          const SizedBox(width: 12),

          // File Size
          Icon(
            Icons.storage,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 2),
          Text(
            dataset.formattedFileSize,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceRow(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dataset.formattedPrice,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        if (dataset.hasSample) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Sample',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
