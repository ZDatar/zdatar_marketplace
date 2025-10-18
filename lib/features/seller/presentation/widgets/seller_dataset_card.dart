import 'package:flutter/material.dart';
import '../../../../models/dataset.dart';

class SellerDatasetCard extends StatelessWidget {
  final Dataset dataset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewAnalytics;

  const SellerDatasetCard({
    super.key,
    required this.dataset,
    this.onEdit,
    this.onDelete,
    this.onViewAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Category Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      dataset.category.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Title and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataset.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusChip(theme),
                          const SizedBox(width: 8),
                          Text(
                            dataset.category.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions Menu
                PopupMenuButton<String>(
                  onSelected: _handleMenuAction,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'analytics',
                      child: Row(
                        children: [
                          Icon(Icons.analytics, size: 16),
                          SizedBox(width: 8),
                          Text('Analytics'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 16),
                          SizedBox(width: 8),
                          Text('Duplicate'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              dataset.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Stats Row
            Row(
              children: [
                _buildStatItem(
                    theme, Icons.attach_money, dataset.formattedPrice),
                const SizedBox(width: 16),
                _buildStatItem(
                    theme, Icons.shopping_cart, '${dataset.totalSales} sales'),
                const SizedBox(width: 16),
                _buildStatItem(theme, Icons.star, '${dataset.rating}'),
                const SizedBox(width: 16),
                _buildStatItem(theme, Icons.storage, dataset.formattedFileSize),
              ],
            ),

            const SizedBox(height: 12),

            // Tags
            if (dataset.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: dataset.tags.take(3).map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // Footer Row
            Row(
              children: [
                Text(
                  'Updated ${_getRelativeTime(dataset.updatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                if (dataset.status == DatasetStatus.active) ...[
                  TextButton.icon(
                    onPressed: onViewAnalytics,
                    icon: const Icon(Icons.analytics, size: 16),
                    label: const Text('Analytics'),
                  ),
                  const SizedBox(width: 8),
                ],
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    Color color;
    String text;

    switch (dataset.status) {
      case DatasetStatus.active:
        color = theme.colorScheme.secondary;
        text = 'Active';
        break;
      case DatasetStatus.draft:
        color = theme.colorScheme.tertiary;
        text = 'Draft';
        break;
      case DatasetStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case DatasetStatus.suspended:
        color = theme.colorScheme.error;
        text = 'Suspended';
        break;
      default:
        color = theme.colorScheme.outline;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        onEdit?.call();
        break;
      case 'analytics':
        onViewAnalytics?.call();
        break;
      case 'duplicate':
        // Handle duplicate
        break;
      case 'delete':
        onDelete?.call();
        break;
    }
  }
}
