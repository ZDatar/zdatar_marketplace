import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/data_task.dart';
import '../providers/task_providers.dart';

class TaskFiltersWidget extends ConsumerWidget {
  const TaskFiltersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filters = ref.watch(taskFiltersProvider);
    final filtersNotifier = ref.read(taskFiltersProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clear filters button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filters',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => filtersNotifier.clearFilters(),
              child: const Text('Clear All'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Task Types
        _FilterSection(
          title: 'Task Types',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskType.values.map((type) {
              final isSelected = filters.taskTypes.contains(type);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(type.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) => filtersNotifier.toggleTaskType(type),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Categories
        _FilterSection(
          title: 'Categories',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskCategory.values.map((category) {
              final isSelected = filters.categories.contains(category);
              return FilterChip(
                label: Text(category.displayName),
                selected: isSelected,
                onSelected: (selected) => filtersNotifier.toggleCategory(category),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Difficulty
        _FilterSection(
          title: 'Difficulty',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TaskDifficulty.values.map((difficulty) {
              final isSelected = filters.difficulties.contains(difficulty);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(difficulty.icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(difficulty.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) => filtersNotifier.toggleDifficulty(difficulty),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Budget Range
        _FilterSection(
          title: 'Budget Range',
          child: Column(
            children: [
              RangeSlider(
                values: RangeValues(filters.minBudget, filters.maxBudget),
                min: 0,
                max: 10000,
                divisions: 100,
                labels: RangeLabels(
                  '\$${filters.minBudget.round()}',
                  '\$${filters.maxBudget.round()}',
                ),
                onChanged: (values) {
                  filtersNotifier.updateBudgetRange(values.start, values.end);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${filters.minBudget.round()}'),
                  Text('\$${filters.maxBudget.round()}'),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Currency
        _FilterSection(
          title: 'Currency',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['USDC', 'SOL', 'ZDTR'].map((currency) {
              final isSelected = filters.currencies.contains(currency);
              return FilterChip(
                label: Text(currency),
                selected: isSelected,
                onSelected: (selected) => filtersNotifier.toggleCurrency(currency),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Skills
        _FilterSection(
          title: 'Required Skills',
          child: Column(
            children: [
              // Popular skills
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _getPopularSkills().map((skill) {
                  final isSelected = filters.requiredSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) => filtersNotifier.toggleSkill(skill),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 12),
              
              // Skill search
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search skills',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                ),
                onSubmitted: (skill) {
                  if (skill.trim().isNotEmpty && !filters.requiredSkills.contains(skill.trim())) {
                    filtersNotifier.toggleSkill(skill.trim());
                  }
                },
              ),
              
              // Selected skills
              if (filters.requiredSkills.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: filters.requiredSkills.map((skill) {
                    return Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => filtersNotifier.toggleSkill(skill),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Deadline Filter
        _FilterSection(
          title: 'Deadline',
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Due within 7 days'),
                value: filters.deadlineBefore != null && 
                       filters.deadlineBefore!.difference(DateTime.now()).inDays <= 7,
                onChanged: (value) {
                  if (value == true) {
                    filtersNotifier.updateDeadline(DateTime.now().add(const Duration(days: 7)));
                  } else {
                    filtersNotifier.updateDeadline(null);
                  }
                },
                contentPadding: EdgeInsets.zero,
              ),
              
              // Custom deadline picker
              ListTile(
                title: const Text('Custom deadline'),
                subtitle: filters.deadlineBefore != null
                    ? Text('Before ${_formatDate(filters.deadlineBefore!)}')
                    : const Text('No deadline filter'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDeadline(context, filtersNotifier, filters.deadlineBefore),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Special Filters
        _FilterSection(
          title: 'Special Filters',
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Urgent tasks only'),
                value: filters.isUrgentOnly,
                onChanged: (value) => filtersNotifier.toggleUrgentOnly(),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Verification required'),
                value: filters.requiresVerificationOnly,
                onChanged: (value) => filtersNotifier.toggleVerificationOnly(),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Apply Filters Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ref.read(tasksNotifierProvider.notifier).applyFilters(),
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }

  List<String> _getPopularSkills() {
    return [
      'Python',
      'SQL',
      'Machine Learning',
      'Data Analysis',
      'ETL',
      'Tableau',
      'Power BI',
      'Data Annotation',
      'Excel',
      'Statistics',
    ];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDeadline(BuildContext context, TaskFiltersNotifier notifier, DateTime? currentDeadline) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      notifier.updateDeadline(date);
    }
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
