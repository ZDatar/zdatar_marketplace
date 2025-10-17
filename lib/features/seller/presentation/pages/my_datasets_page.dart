import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/dataset.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/seller_dataset_card.dart';
import '../widgets/seller_stats_card.dart';

class MyDatasetsPage extends ConsumerStatefulWidget {
  const MyDatasetsPage({super.key});

  @override
  ConsumerState<MyDatasetsPage> createState() => _MyDatasetsPageState();
}

class _MyDatasetsPageState extends ConsumerState<MyDatasetsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Header with Stats
          _buildHeader(theme),
          
          // Tab Bar
          _buildTabBar(theme),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllDatasetsTab(),
                _buildActiveTab(),
                _buildDraftsTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.uploadDataset),
        icon: const Icon(Icons.add),
        label: const Text('Upload Dataset'),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Datasets',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: SellerStatsCard(
                  title: 'Total Datasets',
                  value: '12',
                  icon: Icons.dataset,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SellerStatsCard(
                  title: 'Total Sales',
                  value: '89',
                  icon: Icons.shopping_cart,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SellerStatsCard(
                  title: 'Total Earnings',
                  value: '\$2,450',
                  icon: Icons.attach_money,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Active'),
          Tab(text: 'Drafts'),
          Tab(text: 'Analytics'),
        ],
      ),
    );
  }

  Widget _buildAllDatasetsTab() {
    final datasets = _getMockDatasets();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: datasets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SellerDatasetCard(
            dataset: datasets[index],
            onEdit: () => _editDataset(datasets[index]),
            onDelete: () => _deleteDataset(datasets[index]),
            onViewAnalytics: () => _viewAnalytics(datasets[index]),
          ),
        );
      },
    );
  }

  Widget _buildActiveTab() {
    final activeDatasets = _getMockDatasets()
        .where((d) => d.status == DatasetStatus.active)
        .toList();
    
    if (activeDatasets.isEmpty) {
      return _buildEmptyState(
        'No Active Datasets',
        'Your published datasets will appear here',
        Icons.store,
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeDatasets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SellerDatasetCard(
            dataset: activeDatasets[index],
            onEdit: () => _editDataset(activeDatasets[index]),
            onDelete: () => _deleteDataset(activeDatasets[index]),
            onViewAnalytics: () => _viewAnalytics(activeDatasets[index]),
          ),
        );
      },
    );
  }

  Widget _buildDraftsTab() {
    final draftDatasets = _getMockDatasets()
        .where((d) => d.status == DatasetStatus.draft)
        .toList();
    
    if (draftDatasets.isEmpty) {
      return _buildEmptyState(
        'No Draft Datasets',
        'Start creating a new dataset to see drafts here',
        Icons.drafts,
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: draftDatasets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SellerDatasetCard(
            dataset: draftDatasets[index],
            onEdit: () => _editDataset(draftDatasets[index]),
            onDelete: () => _deleteDataset(draftDatasets[index]),
            onViewAnalytics: () => _viewAnalytics(draftDatasets[index]),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Overview
          _buildPerformanceOverview(),
          
          const SizedBox(height: 16),
          
          // Top Performing Datasets
          _buildTopPerformingDatasets(),
          
          const SizedBox(height: 16),
          
          // Revenue Chart
          _buildRevenueChart(),
          
          const SizedBox(height: 16),
          
          // Category Performance
          _buildCategoryPerformance(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.uploadDataset),
            icon: const Icon(Icons.add),
            label: const Text('Upload Dataset'),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(theme, 'Views', '1,234', '+12%', Icons.visibility),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(theme, 'Downloads', '89', '+8%', Icons.download),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(theme, 'Revenue', '\$2,450', '+15%', Icons.trending_up),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(ThemeData theme, String title, String value, String change, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformingDatasets() {
    final theme = Theme.of(context);
    final topDatasets = _getMockDatasets().take(3).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Performing Datasets',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...topDatasets.asMap().entries.map((entry) {
              final index = entry.key;
              final dataset = entry.value;
              return _buildTopDatasetItem(theme, dataset, index + 1);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDatasetItem(ThemeData theme, Dataset dataset, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank == 1 
                ? Colors.amber 
                : rank == 2 
                  ? Colors.grey[400] 
                  : Colors.brown[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataset.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${dataset.totalSales} sales • ${dataset.formattedPrice}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(dataset.price * dataset.totalSales).toStringAsFixed(0)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend (Last 30 Days)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Revenue Chart Placeholder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPerformance() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Performance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoryItem(theme, DatasetCategory.location, 45, '\$1,200'),
            _buildCategoryItem(theme, DatasetCategory.health, 32, '\$850'),
            _buildCategoryItem(theme, DatasetCategory.appUsage, 12, '\$400'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(ThemeData theme, DatasetCategory category, int sales, String revenue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(category.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.displayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$sales sales',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            revenue,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  List<Dataset> _getMockDatasets() {
    return [
      Dataset(
        id: '1',
        title: 'Urban Mobility Patterns',
        description: 'Location data from Mumbai users',
        sellerId: 'current_user',
        category: DatasetCategory.location,
        tags: ['mobility', 'urban'],
        price: 299.99,
        currency: 'USDC',
        fileSizeBytes: 50 * 1024 * 1024,
        fileType: 'json',
        dataStartDate: DateTime.now().subtract(const Duration(days: 90)),
        dataEndDate: DateTime.now().subtract(const Duration(days: 1)),
        encryptedFileUrl: 'url1',
        encryptionKeyHash: 'hash1',
        status: DatasetStatus.active,
        totalSales: 45,
        rating: 4.8,
        reviewCount: 23,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Dataset(
        id: '2',
        title: 'Fitness Tracking Data',
        description: 'Health and activity data',
        sellerId: 'current_user',
        category: DatasetCategory.health,
        tags: ['fitness', 'health'],
        price: 199.99,
        currency: 'SOL',
        fileSizeBytes: 25 * 1024 * 1024,
        fileType: 'csv',
        dataStartDate: DateTime.now().subtract(const Duration(days: 60)),
        dataEndDate: DateTime.now().subtract(const Duration(days: 1)),
        encryptedFileUrl: 'url2',
        encryptionKeyHash: 'hash2',
        status: DatasetStatus.draft,
        totalSales: 0,
        rating: 0.0,
        reviewCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _editDataset(Dataset dataset) {
    // Navigate to edit dataset page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${dataset.title}')),
    );
  }

  void _deleteDataset(Dataset dataset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dataset'),
        content: Text('Are you sure you want to delete "${dataset.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dataset deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewAnalytics(Dataset dataset) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View analytics for ${dataset.title}')),
    );
  }
}
