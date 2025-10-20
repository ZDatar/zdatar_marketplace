import 'package:flutter/material.dart';
import '../../../../models/data_task.dart';

class TaskTypeSelector extends StatelessWidget {
  final TaskType selectedType;
  final ValueChanged<TaskType> onChanged;

  const TaskTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Type *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: TaskType.values.map((type) {
            final isSelected = selectedType == type;
            return InkWell(
              onTap: () => onChanged(type),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      type.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type.displayName,
                      style: TextStyle(
                        color: isSelected 
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class TaskCategorySelector extends StatelessWidget {
  final TaskType taskType;
  final TaskCategory selectedCategory;
  final ValueChanged<TaskCategory> onChanged;

  const TaskCategorySelector({
    super.key,
    required this.taskType,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableCategories = _getCategoriesForTaskType(taskType);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TaskCategory>(
          value: availableCategories.contains(selectedCategory) 
              ? selectedCategory 
              : availableCategories.first,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select a category',
          ),
          items: availableCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category.displayName),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      ],
    );
  }

  List<TaskCategory> _getCategoriesForTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.dataLabeling:
        return [
          TaskCategory.imageAnnotation,
          TaskCategory.textLabeling,
          TaskCategory.audioTranscription,
          TaskCategory.videoAnnotation,
        ];
      case TaskType.dataEngineering:
        return [
          TaskCategory.dataProcessing,
          TaskCategory.etlPipeline,
          TaskCategory.databaseDesign,
        ];
      case TaskType.dataVisualization:
        return [TaskCategory.dataVisualization];
      case TaskType.dataAnalysis:
        return [
          TaskCategory.dataAnalysis,
          TaskCategory.machineLearning,
        ];
      case TaskType.dataCollection:
        return [TaskCategory.dataCollection];
      case TaskType.dataValidation:
        return [TaskCategory.dataValidation];
    }
  }
}

class BudgetPricingSection extends StatelessWidget {
  final TextEditingController budgetController;
  final TaskPricing selectedPricing;
  final String selectedCurrency;
  final ValueChanged<TaskPricing> onPricingChanged;
  final ValueChanged<String> onCurrencyChanged;

  const BudgetPricingSection({
    super.key,
    required this.budgetController,
    required this.selectedPricing,
    required this.selectedCurrency,
    required this.onPricingChanged,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget & Pricing *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Pricing Type
        DropdownButtonFormField<TaskPricing>(
          value: selectedPricing,
          decoration: const InputDecoration(
            labelText: 'Pricing Type',
            border: OutlineInputBorder(),
          ),
          items: TaskPricing.values.map((pricing) {
            return DropdownMenuItem(
              value: pricing,
              child: Text(_getPricingLabel(pricing)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onPricingChanged(value);
            }
          },
        ),
        
        const SizedBox(height: 16),
        
        // Budget Amount
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: budgetController,
                decoration: InputDecoration(
                  labelText: _getBudgetLabel(selectedPricing),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a budget';
                  }
                  final budget = double.tryParse(value);
                  if (budget == null || budget <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  border: OutlineInputBorder(),
                ),
                items: ['USDC', 'SOL', 'ZDTR'].map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onCurrencyChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getPricingLabel(TaskPricing pricing) {
    switch (pricing) {
      case TaskPricing.fixed:
        return 'Fixed Budget';
      case TaskPricing.hourly:
        return 'Hourly Rate';
      case TaskPricing.perItem:
        return 'Per Item Rate';
      case TaskPricing.milestone:
        return 'Milestone Budget';
    }
  }

  String _getBudgetLabel(TaskPricing pricing) {
    switch (pricing) {
      case TaskPricing.fixed:
        return 'Total Budget';
      case TaskPricing.hourly:
        return 'Hourly Rate';
      case TaskPricing.perItem:
        return 'Rate per Item';
      case TaskPricing.milestone:
        return 'Total Budget';
    }
  }
}

class DeadlineSelector extends StatelessWidget {
  final DateTime selectedDeadline;
  final ValueChanged<DateTime> onChanged;

  const DeadlineSelector({
    super.key,
    required this.selectedDeadline,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deadline *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 12),
                Text(
                  '${selectedDeadline.day}/${selectedDeadline.month}/${selectedDeadline.year}',
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      onChanged(date);
    }
  }
}

class DifficultySelector extends StatelessWidget {
  final TaskDifficulty selectedDifficulty;
  final ValueChanged<TaskDifficulty> onChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Level *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: TaskDifficulty.values.map((difficulty) {
            final isSelected = selectedDifficulty == difficulty;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => onChanged(difficulty),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surface,
                      border: Border.all(
                        color: isSelected 
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          difficulty.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          difficulty.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SkillsSelector extends StatefulWidget {
  final List<String> availableSkills;
  final List<String> selectedSkills;
  final ValueChanged<List<String>> onChanged;

  const SkillsSelector({
    super.key,
    required this.availableSkills,
    required this.selectedSkills,
    required this.onChanged,
  });

  @override
  State<SkillsSelector> createState() => _SkillsSelectorState();
}

class _SkillsSelectorState extends State<SkillsSelector> {
  final _controller = TextEditingController();
  List<String> _filteredSkills = [];

  @override
  void initState() {
    super.initState();
    _filteredSkills = widget.availableSkills;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Skills *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Search field
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Search skills',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _filteredSkills = widget.availableSkills
                  .where((skill) => skill.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Selected skills
        if (widget.selectedSkills.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedSkills.map((skill) {
              return Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final updated = List<String>.from(widget.selectedSkills);
                  updated.remove(skill);
                  widget.onChanged(updated);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Available skills
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: _filteredSkills.length,
            itemBuilder: (context, index) {
              final skill = _filteredSkills[index];
              final isSelected = widget.selectedSkills.contains(skill);
              
              return CheckboxListTile(
                title: Text(skill),
                value: isSelected,
                onChanged: (value) {
                  final updated = List<String>.from(widget.selectedSkills);
                  if (value == true) {
                    updated.add(skill);
                  } else {
                    updated.remove(skill);
                  }
                  widget.onChanged(updated);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class DeliverablesSection extends StatefulWidget {
  final List<String> deliverables;
  final ValueChanged<List<String>> onChanged;

  const DeliverablesSection({
    super.key,
    required this.deliverables,
    required this.onChanged,
  });

  @override
  State<DeliverablesSection> createState() => _DeliverablesSectionState();
}

class _DeliverablesSectionState extends State<DeliverablesSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deliverables *',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Add deliverable field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Add deliverable',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Labeled dataset in CSV format',
                ),
                onSubmitted: _addDeliverable,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addDeliverable(_controller.text),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Deliverables list
        if (widget.deliverables.isNotEmpty)
          ...widget.deliverables.asMap().entries.map((entry) {
            final index = entry.key;
            final deliverable = entry.value;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(deliverable),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeDeliverable(index),
                ),
              ),
            );
          }),
      ],
    );
  }

  void _addDeliverable(String deliverable) {
    if (deliverable.trim().isNotEmpty) {
      final updated = List<String>.from(widget.deliverables);
      updated.add(deliverable.trim());
      widget.onChanged(updated);
      _controller.clear();
    }
  }

  void _removeDeliverable(int index) {
    final updated = List<String>.from(widget.deliverables);
    updated.removeAt(index);
    widget.onChanged(updated);
  }
}

class DatasetSection extends StatelessWidget {
  final TextEditingController datasetUrlController;
  final TextEditingController sampleDataUrlController;
  final String? selectedFormat;
  final ValueChanged<String?> onFormatChanged;

  const DatasetSection({
    super.key,
    required this.datasetUrlController,
    required this.sampleDataUrlController,
    required this.selectedFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dataset Information',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Dataset URL
        TextFormField(
          controller: datasetUrlController,
          decoration: const InputDecoration(
            labelText: 'Dataset URL (optional)',
            hintText: 'https://storage.example.com/dataset.csv',
            border: OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Data Format
        DropdownButtonFormField<String>(
          value: selectedFormat,
          decoration: const InputDecoration(
            labelText: 'Data Format',
            border: OutlineInputBorder(),
          ),
          items: ['CSV', 'JSON', 'Parquet', 'Excel', 'XML', 'Other'].map((format) {
            return DropdownMenuItem(
              value: format,
              child: Text(format),
            );
          }).toList(),
          onChanged: onFormatChanged,
        ),
        
        const SizedBox(height: 16),
        
        // Sample Data URL
        TextFormField(
          controller: sampleDataUrlController,
          decoration: const InputDecoration(
            labelText: 'Sample Data URL (optional)',
            hintText: 'https://storage.example.com/sample.csv',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class RegionSelector extends StatelessWidget {
  final List<String> selectedRegions;
  final ValueChanged<List<String>> onChanged;

  const RegionSelector({
    super.key,
    required this.selectedRegions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableRegions = [
      'North America',
      'Europe',
      'Asia',
      'South America',
      'Africa',
      'Oceania',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Regions (optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableRegions.map((region) {
            final isSelected = selectedRegions.contains(region);
            return FilterChip(
              label: Text(region),
              selected: isSelected,
              onSelected: (selected) {
                final updated = List<String>.from(selectedRegions);
                if (selected) {
                  updated.add(region);
                } else {
                  updated.remove(region);
                }
                onChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class TaskReviewCard extends StatelessWidget {
  final String title;
  final String description;
  final TaskType taskType;
  final TaskCategory category;
  final String budget;
  final String currency;
  final TaskPricing pricingType;
  final DateTime deadline;
  final TaskDifficulty difficulty;
  final String estimatedHours;
  final List<String> requiredSkills;
  final List<String> deliverables;
  final bool isUrgent;
  final bool requiresVerification;

  const TaskReviewCard({
    super.key,
    required this.title,
    required this.description,
    required this.taskType,
    required this.category,
    required this.budget,
    required this.currency,
    required this.pricingType,
    required this.deadline,
    required this.difficulty,
    required this.estimatedHours,
    required this.requiredSkills,
    required this.deliverables,
    required this.isUrgent,
    required this.requiresVerification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Type
            Row(
              children: [
                Text(
                  taskType.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${taskType.displayName} • ${category.displayName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            
            const SizedBox(height: 20),
            
            // Budget and Timeline
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Budget',
                    '$budget $currency',
                    Icons.attach_money,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Estimated Hours',
                    '$estimatedHours hours',
                    Icons.schedule,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Deadline',
                    '${deadline.day}/${deadline.month}/${deadline.year}',
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Difficulty',
                    '${difficulty.icon} ${difficulty.displayName}',
                    null,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Skills
            if (requiredSkills.isNotEmpty) ...[
              Text(
                'Required Skills',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: requiredSkills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            
            // Deliverables
            if (deliverables.isNotEmpty) ...[
              Text(
                'Deliverables',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...deliverables.map((deliverable) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          deliverable,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
            
            // Flags
            if (isUrgent || requiresVerification)
              Wrap(
                spacing: 8,
                children: [
                  if (isUrgent)
                    Chip(
                      label: const Text('Urgent'),
                      backgroundColor: Colors.orange.withValues(alpha: 0.1),
                      side: const BorderSide(color: Colors.orange),
                    ),
                  if (requiresVerification)
                    Chip(
                      label: const Text('Verification Required'),
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      side: const BorderSide(color: Colors.blue),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData? icon) {
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
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
            ],
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
}
