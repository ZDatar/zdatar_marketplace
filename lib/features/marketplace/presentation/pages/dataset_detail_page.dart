import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../models/dataset.dart';
import '../../../../models/user.dart';
import '../widgets/purchase_dialog.dart';

class DatasetDetailPage extends ConsumerWidget {
  final String datasetId;

  const DatasetDetailPage({
    super.key,
    required this.datasetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // In a real app, this would fetch from a provider
    final dataset = _getMockDataset(datasetId);
    final seller = _getMockSeller(dataset.sellerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(dataset.title),
        actions: [
          IconButton(
            onPressed: () => _shareDataset(context, dataset),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () => _favoriteDataset(context, dataset),
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(context, theme, dataset),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Section
                  _buildOverviewSection(context, theme, dataset),

                  const SizedBox(height: 24),

                  // Sample Data Preview
                  if (dataset.hasSample) ...[
                    _buildSampleSection(context, theme, dataset),
                    const SizedBox(height: 24),
                  ],

                  // Seller Section
                  _buildSellerSection(context, theme, seller),

                  const SizedBox(height: 24),

                  // Reviews Section
                  _buildReviewsSection(context, theme, dataset),

                  const SizedBox(height: 24),

                  // Related Datasets
                  _buildRelatedSection(context, theme),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, theme, dataset),
    );
  }

  Widget _buildHeroSection(
      BuildContext context, ThemeData theme, Dataset dataset) {
    return Container(
      height: 200,
      width: double.infinity,
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
      child: dataset.previewImageUrl != null
          ? CachedNetworkImage(
              imageUrl: dataset.previewImageUrl!,
              fit: BoxFit.cover,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dataset.category.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dataset.category.displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewSection(
      BuildContext context, ThemeData theme, Dataset dataset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Category
        Row(
          children: [
            Expanded(
              child: Text(
                dataset.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dataset.category.icon),
                  const SizedBox(width: 4),
                  Text(
                    dataset.category.displayName,
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

        const SizedBox(height: 12),

        // Stats Row
        Row(
          children: [
            _buildStatChip(
                theme, Icons.star, '${dataset.rating}', Colors.amber),
            const SizedBox(width: 8),
            _buildStatChip(theme, Icons.shopping_cart, '${dataset.totalSales}',
                theme.colorScheme.secondary),
            const SizedBox(width: 8),
            _buildStatChip(theme, Icons.storage, dataset.formattedFileSize,
                theme.colorScheme.tertiary),
            const SizedBox(width: 8),
            if (dataset.region != null)
              _buildStatChip(theme, Icons.location_on, dataset.region!,
                  theme.colorScheme.primary),
          ],
        ),

        const SizedBox(height: 16),

        // Description
        Text(
          dataset.description,
          style: theme.textTheme.bodyLarge,
        ),

        const SizedBox(height: 16),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: dataset.tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Data Info
        _buildDataInfo(theme, dataset),
      ],
    );
  }

  Widget _buildStatChip(
      ThemeData theme, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataInfo(ThemeData theme, Dataset dataset) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dataset Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(theme, 'File Type', dataset.fileType.toUpperCase()),
            _buildInfoRow(theme, 'File Size', dataset.formattedFileSize),
            _buildInfoRow(theme, 'Data Period',
                '${dataset.dataStartDate.day}/${dataset.dataStartDate.month}/${dataset.dataStartDate.year} - ${dataset.dataEndDate.day}/${dataset.dataEndDate.month}/${dataset.dataEndDate.year}'),
            if (dataset.region != null)
              _buildInfoRow(theme, 'Region', dataset.region!),
            _buildInfoRow(theme, 'Listed',
                '${dataset.createdAt.day}/${dataset.createdAt.month}/${dataset.createdAt.year}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleSection(
      BuildContext context, ThemeData theme, Dataset dataset) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Sample Data Preview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _viewFullSample(context, dataset),
                  child: const Text('View Full Sample'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Sample chart
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSampleData(),
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerSection(
      BuildContext context, ThemeData theme, User seller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seller Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    seller.username?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            seller.username ?? 'Anonymous',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (seller.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: theme.colorScheme.secondary,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '${seller.walletAddress.substring(0, 6)}...${seller.walletAddress.substring(seller.walletAddress.length - 4)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text('${seller.rating}'),
                      ],
                    ),
                    Text(
                      '${seller.totalSales} sales',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(
      BuildContext context, ThemeData theme, Dataset dataset) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Reviews (${dataset.reviewCount})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    Text('${dataset.rating}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Sample reviews
            ...List.generate(3, (index) => _buildReviewItem(theme, index)),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _viewAllReviews(context, dataset),
                child: const Text('View All Reviews'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(ThemeData theme, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Text('U${index + 1}'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'User${index + 1}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < 4 ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                        ),
                      ],
                    ),
                    Text(
                      'Great dataset with clean data. Very useful for my research project.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (index < 2) const Divider(),
        ],
      ),
    );
  }

  Widget _buildRelatedSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Datasets',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Related Dataset ${index + 1}',
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Brief description of the related dataset',
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '\$${(50 + index * 25).toStringAsFixed(2)} USDC',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
      BuildContext context, ThemeData theme, Dataset dataset) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  dataset.formattedPrice,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _purchaseDataset(context, dataset),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Purchase Dataset'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSampleData() {
    return List.generate(20, (index) {
      return FlSpot(
          index.toDouble(), (index * 0.5 + (index % 3) * 2).toDouble());
    });
  }

  Dataset _getMockDataset(String id) {
    return Dataset(
      id: id,
      title: 'Urban Mobility Patterns Dataset',
      description:
          'Comprehensive location and movement data collected from 1000+ users across Mumbai over a 3-month period. This dataset includes GPS coordinates, timestamps, transportation modes, and anonymized user demographics. Perfect for urban planning research, transportation optimization, and mobility behavior analysis.',
      sellerId: 'seller1',
      category: DatasetCategory.location,
      tags: ['mobility', 'urban', 'transportation', 'gps', 'mumbai'],
      price: 299.99,
      currency: 'USDC',
      fileSizeBytes: 50 * 1024 * 1024,
      fileType: 'json',
      dataStartDate: DateTime.now().subtract(const Duration(days: 90)),
      dataEndDate: DateTime.now().subtract(const Duration(days: 1)),
      region: 'Mumbai, India',
      encryptedFileUrl: 'https://storage.zdatar.com/encrypted/1',
      encryptionKeyHash: 'hash1',
      status: DatasetStatus.active,
      totalSales: 45,
      rating: 4.8,
      reviewCount: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      hasSample: true,
    );
  }

  User _getMockSeller(String sellerId) {
    return User(
      id: sellerId,
      walletAddress: '7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU',
      username: 'DataCollector_Mumbai',
      rating: 4.9,
      totalSales: 156,
      totalPurchases: 23,
      totalEarnings: 12450.75,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isVerified: true,
      specializations: ['Location Data', 'Urban Analytics'],
    );
  }

  void _shareDataset(BuildContext context, Dataset dataset) {
    // Implement share functionality
  }

  void _favoriteDataset(BuildContext context, Dataset dataset) {
    // Implement favorite functionality
  }

  void _viewFullSample(BuildContext context, Dataset dataset) {
    // Implement full sample view
  }

  void _viewAllReviews(BuildContext context, Dataset dataset) {
    // Implement reviews page
  }

  void _purchaseDataset(BuildContext context, Dataset dataset) {
    showDialog(
      context: context,
      builder: (context) => PurchaseDialog(dataset: dataset),
    );
  }
}
