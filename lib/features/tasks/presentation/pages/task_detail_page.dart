import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/data_task.dart';
import '../widgets/task_application_dialog.dart';

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // In a real app, this would fetch from a provider using taskId
    final task = _getMockTask(taskId);
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Not Found')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64),
              SizedBox(height: 16),
              Text('Task not found'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            onPressed: () => _shareTask(context, task),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () => _bookmarkTask(context, task),
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(context, theme, task),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Overview
                  _buildOverviewSection(context, theme, task),

                  const SizedBox(height: 32),

                  // Requirements Section
                  _buildRequirementsSection(context, theme, task),

                  const SizedBox(height: 32),

                  // Dataset Section (if applicable)
                  if (task.hasDataset) ...[
                    _buildDatasetSection(context, theme, task),
                    const SizedBox(height: 32),
                  ],

                  // Deliverables Section
                  _buildDeliverablesSection(context, theme, task),

                  const SizedBox(height: 32),

                  // Buyer Information
                  _buildBuyerSection(context, theme, task),

                  const SizedBox(height: 32),

                  // Applications Section
                  _buildApplicationsSection(context, theme, task),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, theme, task),
    );
  }

  Widget _buildHeroSection(BuildContext context, ThemeData theme, DataTask task) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task type and status badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.taskType.icon,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.taskType.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (task.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              task.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Category
            Text(
              task.category.displayName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 24),

            // Key metrics
            Row(
              children: [
                _buildMetricCard(
                  context,
                  'Budget',
                  task.formattedBudget,
                  Icons.attach_money,
                  theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                _buildMetricCard(
                  context,
                  'Duration',
                  '${task.estimatedHours}h',
                  Icons.schedule,
                  theme.colorScheme.secondary,
                ),
                const SizedBox(width: 16),
                _buildMetricCard(
                  context,
                  'Difficulty',
                  task.difficulty.displayName,
                  null,
                  _getDifficultyColor(task.difficulty),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value, IconData? icon, Color color) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context, ThemeData theme, DataTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Description',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          task.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        
        // Timeline info
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                context,
                'Posted',
                _formatDate(task.createdAt),
                Icons.calendar_today,
              ),
            ),
            Expanded(
              child: _buildInfoItem(
                context,
                'Deadline',
                _formatDate(task.deadline),
                Icons.event,
              ),
            ),
            Expanded(
              child: _buildInfoItem(
                context,
                'Applications',
                '${task.applications.length}',
                Icons.people,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirementsSection(BuildContext context, ThemeData theme, DataTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requirements',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Required Skills
        if (task.requiredSkills.isNotEmpty) ...[
          Text(
            'Required Skills',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: task.requiredSkills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        
        // Additional requirements
        if (task.requiresVerification) ...[
          Row(
            children: [
              const Icon(
                Icons.verified,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Verification Required',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This task requires verified workers only.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDatasetSection(BuildContext context, ThemeData theme, DataTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dataset Information',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.dataset,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dataset Provided',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (task.dataFormat != null)
                            Text(
                              'Format: ${task.dataFormat}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (task.datasetSize != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.formattedDatasetSize,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                
                if (task.sampleDataUrl != null) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _viewSampleData(context, task.sampleDataUrl!),
                    icon: const Icon(Icons.preview),
                    label: const Text('View Sample Data'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverablesSection(BuildContext context, ThemeData theme, DataTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deliverables',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        ...task.deliverables.map((deliverable) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    deliverable,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBuyerSection(BuildContext context, ThemeData theme, DataTask task) {
    // Mock buyer data - in real app, fetch from user service
    final buyer = _getMockBuyer(task.buyerId);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Posted By',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    buyer['name']?.substring(0, 1).toUpperCase() ?? 'B',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            buyer['name'] ?? 'Anonymous Buyer',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (buyer['isVerified'] == true) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              color: theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${buyer['rating']?.toStringAsFixed(1) ?? '0.0'} Rating',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${buyer['tasksPosted'] ?? 0} tasks posted',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _viewBuyerProfile(context, task.buyerId),
                  child: const Text('View Profile'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationsSection(BuildContext context, ThemeData theme, DataTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Applications (${task.applications.length})',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (task.applications.isNotEmpty)
              TextButton(
                onPressed: () => _viewAllApplications(context, task),
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (task.applications.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No applications yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to apply for this task!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Text(
            '${task.applications.length} ${task.applications.length == 1 ? 'person has' : 'people have'} applied for this task.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, ThemeData theme, DataTask task) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.formattedBudget,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  _getPricingTypeLabel(task.pricingType),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _applyForTask(context, task),
              icon: const Icon(Icons.send),
              label: const Text('Apply for Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Mock data and helper methods
  DataTask? _getMockTask(String taskId) {
    // In real app, fetch from API/database
    return DataTask(
      id: taskId,
      title: 'Label 10K Product Images for E-commerce Platform',
      description: 'We need experienced data labelers to help us annotate our product image dataset. The task involves labeling product categories, identifying key features, and ensuring quality standards. This is a critical project for our machine learning pipeline that will improve our product recommendation system.\n\nThe dataset contains high-quality product images from various categories including electronics, clothing, home goods, and more. Each image needs to be carefully labeled with appropriate categories and attributes.',
      buyerId: 'buyer123',
      taskType: TaskType.dataLabeling,
      category: TaskCategory.imageAnnotation,
      requiredSkills: ['Data Annotation', 'Quality Control', 'Attention to Detail', 'Computer Vision'],
      budget: 2500.0,
      currency: 'USDC',
      pricingType: TaskPricing.fixed,
      deadline: DateTime.now().add(const Duration(days: 14)),
      difficulty: TaskDifficulty.intermediate,
      estimatedHours: 80,
      status: TaskStatus.active,
      deliverables: [
        'Labeled dataset in CSV format',
        'Quality assurance report',
        'Annotation guidelines documentation',
        'Sample validation set'
      ],
      datasetUrl: 'https://storage.zdatar.com/dataset123',
      datasetSize: 1024 * 1024 * 500, // 500MB
      dataFormat: 'Images (JPG/PNG)',
      sampleDataUrl: 'https://storage.zdatar.com/sample123',
      applications: [],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      isUrgent: false,
      requiresVerification: true,
      preferredRegions: ['North America', 'Europe'],
    );
  }

  Map<String, dynamic> _getMockBuyer(String buyerId) {
    return {
      'name': 'TechCorp Solutions',
      'isVerified': true,
      'rating': 4.8,
      'tasksPosted': 25,
    };
  }

  Color _getDifficultyColor(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.beginner:
        return Colors.green;
      case TaskDifficulty.intermediate:
        return Colors.orange;
      case TaskDifficulty.advanced:
        return Colors.red;
      case TaskDifficulty.expert:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPricingTypeLabel(TaskPricing pricing) {
    switch (pricing) {
      case TaskPricing.fixed:
        return 'Fixed price';
      case TaskPricing.hourly:
        return 'Per hour';
      case TaskPricing.perItem:
        return 'Per item';
      case TaskPricing.milestone:
        return 'Milestone-based';
    }
  }

  void _shareTask(BuildContext context, DataTask task) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _bookmarkTask(BuildContext context, DataTask task) {
    // Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task bookmarked!')),
    );
  }

  void _viewSampleData(BuildContext context, String sampleUrl) {
    // Implement sample data viewer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening sample data...')),
    );
  }

  void _viewBuyerProfile(BuildContext context, String buyerId) {
    // Navigate to buyer profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buyer profile coming soon!')),
    );
  }

  void _viewAllApplications(BuildContext context, DataTask task) {
    // Navigate to applications list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Applications view coming soon!')),
    );
  }

  void _applyForTask(BuildContext context, DataTask task) {
    showDialog(
      context: context,
      builder: (context) => TaskApplicationDialog(task: task),
    );
  }
}
