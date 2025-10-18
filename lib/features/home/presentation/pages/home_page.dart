import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../models/dataset.dart';
import '../../../marketplace/presentation/widgets/dataset_card.dart';
import '../../../marketplace/presentation/widgets/category_chip.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(context, theme),
          
          // Main Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Stats
                _buildQuickStats(context, theme),
                
                const SizedBox(height: 48),
                
                // Categories
                _buildCategoriesSection(context, theme),
                
                const SizedBox(height: 48),
                
                // Featured Datasets
                _buildFeaturedSection(context, theme),
                
                const SizedBox(height: 48),
                
                // Trending Datasets
                _buildTrendingSection(context, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
        child: Row(
          children: [
            // Left side - Text content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to ZDatar Marketplace',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Discover, trade, and monetize high-quality AI datasets on the world\'s first decentralized data marketplace.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/marketplace'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Explore Marketplace'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => context.go('/my-data'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Start Selling'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 64),
            
            // Right side - Visual element
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.data_usage,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            'Total Datasets',
            '1,234',
            Icons.dataset,
            theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            'Active Users',
            '5,678',
            Icons.people,
            theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            'Total Volume',
            '₹12.5M',
            Icons.trending_up,
            theme.colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Browse by Category',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(AppRoutes.marketplace),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DatasetCategory.values.map((category) {
            return CategoryChip(
              category: category,
              onTap: () {
                context.go('${AppRoutes.marketplace}?category=${category.name}');
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Featured Datasets',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(AppRoutes.marketplace),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getMockFeaturedDatasets().length,
            itemBuilder: (context, index) {
              final dataset = _getMockFeaturedDatasets()[index];
              return Container(
                width: 300,
                margin: EdgeInsets.only(
                  right: index < _getMockFeaturedDatasets().length - 1 ? 12 : 0,
                ),
                child: DatasetCard(dataset: dataset),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending This Week',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _getMockTrendingDatasets().length,
          itemBuilder: (context, index) {
            final dataset = _getMockTrendingDatasets()[index];
            return DatasetCard(dataset: dataset);
          },
        ),
      ],
    );
  }

  List<Dataset> _getMockFeaturedDatasets() {
    return [
      Dataset(
        id: '1',
        title: 'Urban Mobility Patterns',
        description: 'Location data from 1000+ users in Mumbai over 3 months',
        sellerId: 'seller1',
        category: DatasetCategory.location,
        tags: ['mobility', 'urban', 'transportation'],
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
      ),
      Dataset(
        id: '2',
        title: 'Fitness Tracking Data',
        description: 'Heart rate, steps, and activity data from fitness enthusiasts',
        sellerId: 'seller2',
        category: DatasetCategory.health,
        tags: ['fitness', 'health', 'activity'],
        price: 199.99,
        currency: 'SOL',
        fileSizeBytes: 25 * 1024 * 1024,
        fileType: 'csv',
        dataStartDate: DateTime.now().subtract(const Duration(days: 60)),
        dataEndDate: DateTime.now().subtract(const Duration(days: 1)),
        region: 'Global',
        encryptedFileUrl: 'https://storage.zdatar.com/encrypted/2',
        encryptionKeyHash: 'hash2',
        status: DatasetStatus.active,
        totalSales: 32,
        rating: 4.6,
        reviewCount: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        hasSample: true,
      ),
    ];
  }

  List<Dataset> _getMockTrendingDatasets() {
    return [
      Dataset(
        id: '3',
        title: 'App Usage Analytics',
        description: 'Mobile app usage patterns and screen time data',
        sellerId: 'seller3',
        category: DatasetCategory.appUsage,
        tags: ['apps', 'usage', 'behavior'],
        price: 149.99,
        currency: 'USDC',
        fileSizeBytes: 15 * 1024 * 1024,
        fileType: 'json',
        dataStartDate: DateTime.now().subtract(const Duration(days: 30)),
        dataEndDate: DateTime.now().subtract(const Duration(days: 1)),
        region: 'North America',
        encryptedFileUrl: 'https://storage.zdatar.com/encrypted/3',
        encryptionKeyHash: 'hash3',
        status: DatasetStatus.active,
        totalSales: 28,
        rating: 4.7,
        reviewCount: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        hasSample: false,
      ),
      Dataset(
        id: '4',
        title: 'Battery Performance Data',
        description: 'Device battery usage and charging patterns',
        sellerId: 'seller4',
        category: DatasetCategory.battery,
        tags: ['battery', 'performance', 'charging'],
        price: 99.99,
        currency: 'SOL',
        fileSizeBytes: 8 * 1024 * 1024,
        fileType: 'csv',
        dataStartDate: DateTime.now().subtract(const Duration(days: 45)),
        dataEndDate: DateTime.now().subtract(const Duration(days: 1)),
        region: 'Europe',
        encryptedFileUrl: 'https://storage.zdatar.com/encrypted/4',
        encryptionKeyHash: 'hash4',
        status: DatasetStatus.active,
        totalSales: 19,
        rating: 4.4,
        reviewCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        hasSample: true,
      ),
    ];
  }
}
