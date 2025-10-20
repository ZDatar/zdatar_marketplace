import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/data_task.dart';
import '../providers/task_providers.dart';
import '../widgets/task_form_sections.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  
  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  final _datasetUrlController = TextEditingController();
  final _sampleDataUrlController = TextEditingController();
  
  // Form state
  TaskType _selectedTaskType = TaskType.dataLabeling;
  TaskCategory _selectedCategory = TaskCategory.imageAnnotation;
  TaskDifficulty _selectedDifficulty = TaskDifficulty.intermediate;
  TaskPricing _selectedPricing = TaskPricing.fixed;
  String _selectedCurrency = 'USDC';
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 7));
  List<String> _selectedSkills = [];
  List<String> _deliverables = [];
  List<String> _preferredRegions = [];
  bool _isUrgent = false;
  bool _requiresVerification = false;
  String? _dataFormat;
  
  final List<String> _availableSkills = [
    'Python', 'SQL', 'Machine Learning', 'Data Analysis', 'ETL',
    'Tableau', 'Power BI', 'Data Annotation', 'Quality Control',
    'Data Processing', 'Statistics', 'R', 'Excel', 'Data Visualization',
    'Deep Learning', 'NLP', 'Computer Vision', 'Big Data', 'Spark',
    'Hadoop', 'AWS', 'GCP', 'Azure', 'Docker', 'Kubernetes'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _estimatedHoursController.dispose();
    _datasetUrlController.dispose();
    _sampleDataUrlController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final creationState = ref.watch(taskCreationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _previousStep,
              child: const Text('Back'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(theme),
          
          // Form content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicInfoStep(theme),
                _buildTaskDetailsStep(theme),
                _buildRequirementsStep(theme),
                _buildReviewStep(theme),
              ],
            ),
          ),
          
          // Bottom navigation
          _buildBottomNavigation(theme, creationState),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 3) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us about your task and what you need help with.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            
            // Task Type Selection
            TaskTypeSelector(
              selectedType: _selectedTaskType,
              onChanged: (type) {
                setState(() {
                  _selectedTaskType = type;
                  // Update category based on task type
                  _selectedCategory = _getDefaultCategory(type);
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title *',
                hintText: 'e.g., Label 10K product images for e-commerce',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                if (value.trim().length < 10) {
                  return 'Title must be at least 10 characters';
                }
                return null;
              },
              maxLength: 100,
            ),
            
            const SizedBox(height: 24),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description *',
                hintText: 'Provide detailed information about what you need...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task description';
                }
                if (value.trim().length < 50) {
                  return 'Description must be at least 50 characters';
                }
                return null;
              },
              maxLength: 1000,
            ),
            
            const SizedBox(height: 24),
            
            // Category Selection
            TaskCategorySelector(
              taskType: _selectedTaskType,
              selectedCategory: _selectedCategory,
              onChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDetailsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Details',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set the budget, timeline, and difficulty level.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          
          // Budget and Pricing
          BudgetPricingSection(
            budgetController: _budgetController,
            selectedPricing: _selectedPricing,
            selectedCurrency: _selectedCurrency,
            onPricingChanged: (pricing) {
              setState(() {
                _selectedPricing = pricing;
              });
            },
            onCurrencyChanged: (currency) {
              setState(() {
                _selectedCurrency = currency;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Estimated Hours
          TextFormField(
            controller: _estimatedHoursController,
            decoration: const InputDecoration(
              labelText: 'Estimated Hours *',
              hintText: 'e.g., 40',
              border: OutlineInputBorder(),
              suffixText: 'hours',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter estimated hours';
              }
              final hours = int.tryParse(value);
              if (hours == null || hours <= 0) {
                return 'Please enter a valid number of hours';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Deadline
          DeadlineSelector(
            selectedDeadline: _selectedDeadline,
            onChanged: (deadline) {
              setState(() {
                _selectedDeadline = deadline;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Difficulty
          DifficultySelector(
            selectedDifficulty: _selectedDifficulty,
            onChanged: (difficulty) {
              setState(() {
                _selectedDifficulty = difficulty;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Urgency and Verification
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Urgent Task'),
                  subtitle: const Text('Higher visibility'),
                  value: _isUrgent,
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value ?? false;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Requires Verification'),
                  subtitle: const Text('Verified workers only'),
                  value: _requiresVerification,
                  onChanged: (value) {
                    setState(() {
                      _requiresVerification = value ?? false;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requirements & Data',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Specify skills, deliverables, and data requirements.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          
          // Required Skills
          SkillsSelector(
            availableSkills: _availableSkills,
            selectedSkills: _selectedSkills,
            onChanged: (skills) {
              setState(() {
                _selectedSkills = skills;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Deliverables
          DeliverablesSection(
            deliverables: _deliverables,
            onChanged: (deliverables) {
              setState(() {
                _deliverables = deliverables;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Dataset Information (if applicable)
          if (_selectedTaskType == TaskType.dataLabeling || 
              _selectedTaskType == TaskType.dataEngineering)
            DatasetSection(
              datasetUrlController: _datasetUrlController,
              sampleDataUrlController: _sampleDataUrlController,
              selectedFormat: _dataFormat,
              onFormatChanged: (format) {
                setState(() {
                  _dataFormat = format;
                });
              },
            ),
          
          const SizedBox(height: 24),
          
          // Preferred Regions
          RegionSelector(
            selectedRegions: _preferredRegions,
            onChanged: (regions) {
              setState(() {
                _preferredRegions = regions;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Publish',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your task details before publishing.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          
          TaskReviewCard(
            title: _titleController.text,
            description: _descriptionController.text,
            taskType: _selectedTaskType,
            category: _selectedCategory,
            budget: _budgetController.text,
            currency: _selectedCurrency,
            pricingType: _selectedPricing,
            deadline: _selectedDeadline,
            difficulty: _selectedDifficulty,
            estimatedHours: _estimatedHoursController.text,
            requiredSkills: _selectedSkills,
            deliverables: _deliverables,
            isUrgent: _isUrgent,
            requiresVerification: _requiresVerification,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme, TaskCreationState creationState) {
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
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: creationState.isLoading ? null : _previousStep,
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: creationState.isLoading ? null : _nextStep,
              child: creationState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_currentStep == 3 ? 'Publish Task' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitTask();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState?.validate() ?? false;
      case 1:
        return _budgetController.text.isNotEmpty && 
               _estimatedHoursController.text.isNotEmpty;
      case 2:
        return _selectedSkills.isNotEmpty && _deliverables.isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  Future<void> _submitTask() async {
    final task = DataTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      buyerId: 'current_user_id', // Replace with actual user ID
      taskType: _selectedTaskType,
      category: _selectedCategory,
      requiredSkills: _selectedSkills,
      budget: double.tryParse(_budgetController.text) ?? 0,
      currency: _selectedCurrency,
      pricingType: _selectedPricing,
      deadline: _selectedDeadline,
      difficulty: _selectedDifficulty,
      estimatedHours: int.tryParse(_estimatedHoursController.text) ?? 0,
      status: TaskStatus.active,
      deliverables: _deliverables,
      datasetUrl: _datasetUrlController.text.trim().isNotEmpty 
          ? _datasetUrlController.text.trim() : null,
      dataFormat: _dataFormat,
      sampleDataUrl: _sampleDataUrlController.text.trim().isNotEmpty 
          ? _sampleDataUrlController.text.trim() : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isUrgent: _isUrgent,
      requiresVerification: _requiresVerification,
      preferredRegions: _preferredRegions,
    );

    final success = await ref.read(taskCreationProvider.notifier).createTask(task);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  TaskCategory _getDefaultCategory(TaskType taskType) {
    switch (taskType) {
      case TaskType.dataLabeling:
        return TaskCategory.imageAnnotation;
      case TaskType.dataEngineering:
        return TaskCategory.dataProcessing;
      case TaskType.dataVisualization:
        return TaskCategory.dataVisualization;
      case TaskType.dataAnalysis:
        return TaskCategory.dataAnalysis;
      case TaskType.dataCollection:
        return TaskCategory.dataCollection;
      case TaskType.dataValidation:
        return TaskCategory.dataValidation;
    }
  }
}
