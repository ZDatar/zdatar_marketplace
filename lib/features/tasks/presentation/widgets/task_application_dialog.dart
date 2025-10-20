import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/data_task.dart';

class TaskApplicationDialog extends ConsumerStatefulWidget {
  final DataTask task;

  const TaskApplicationDialog({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<TaskApplicationDialog> createState() => _TaskApplicationDialogState();
}

class _TaskApplicationDialogState extends ConsumerState<TaskApplicationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _proposalController = TextEditingController();
  final _budgetController = TextEditingController();
  final _timeframeController = TextEditingController();
  final _portfolioController = TextEditingController();
  
  bool _isSubmitting = false;
  final List<String> _portfolioLinks = [];

  @override
  void initState() {
    super.initState();
    // Pre-fill with task budget as starting point
    _budgetController.text = widget.task.budget.toString();
    _timeframeController.text = widget.task.estimatedHours.toString();
  }

  @override
  void dispose() {
    _proposalController.dispose();
    _budgetController.dispose();
    _timeframeController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.send,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apply for Task',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.task.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task summary
                      _buildTaskSummary(theme),
                      
                      const SizedBox(height: 24),
                      
                      // Proposal
                      Text(
                        'Your Proposal *',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _proposalController,
                        decoration: const InputDecoration(
                          hintText: 'Explain why you\'re the right person for this task...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your proposal';
                          }
                          if (value.trim().length < 50) {
                            return 'Proposal must be at least 50 characters';
                          }
                          return null;
                        },
                        maxLength: 1000,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Budget and timeframe
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Budget *',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _budgetController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your budget',
                                    border: const OutlineInputBorder(),
                                    suffixText: widget.task.currency,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your budget';
                                    }
                                    final budget = double.tryParse(value);
                                    if (budget == null || budget <= 0) {
                                      return 'Please enter a valid budget';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Timeframe (hours) *',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _timeframeController,
                                  decoration: const InputDecoration(
                                    hintText: 'Estimated hours',
                                    border: OutlineInputBorder(),
                                    suffixText: 'hours',
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter timeframe';
                                    }
                                    final hours = int.tryParse(value);
                                    if (hours == null || hours <= 0) {
                                      return 'Please enter valid hours';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Portfolio links
                      Text(
                        'Portfolio Links (optional)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share links to your previous work or portfolio',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Add portfolio link field
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _portfolioController,
                              decoration: const InputDecoration(
                                hintText: 'https://portfolio.example.com',
                                border: OutlineInputBorder(),
                              ),
                              onFieldSubmitted: _addPortfolioLink,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _addPortfolioLink(_portfolioController.text),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      
                      // Portfolio links list
                      if (_portfolioLinks.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ..._portfolioLinks.asMap().entries.map((entry) {
                          final index = entry.key;
                          final link = entry.value;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.link),
                              title: Text(
                                link,
                                style: theme.textTheme.bodyMedium,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removePortfolioLink(index),
                              ),
                            ),
                          );
                        }),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Application guidelines
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Application Tips',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '• Clearly explain your relevant experience\n'
                              '• Provide realistic budget and timeline estimates\n'
                              '• Include links to similar work you\'ve done\n'
                              '• Ask clarifying questions if needed',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitApplication,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Application'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Summary',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Budget',
                  widget.task.formattedBudget,
                  Icons.attach_money,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Duration',
                  '${widget.task.estimatedHours}h',
                  Icons.schedule,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Difficulty',
                  widget.task.difficulty.displayName,
                  null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData? icon) {
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
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addPortfolioLink(String link) {
    if (link.trim().isNotEmpty && !_portfolioLinks.contains(link.trim())) {
      setState(() {
        _portfolioLinks.add(link.trim());
        _portfolioController.clear();
      });
    }
  }

  void _removePortfolioLink(int index) {
    setState(() {
      _portfolioLinks.removeAt(index);
    });
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create application object
      TaskApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workerId: 'current_user_id', // Replace with actual user ID
        taskId: widget.task.id,
        proposedBudget: double.parse(_budgetController.text),
        proposedTimeframe: int.parse(_timeframeController.text),
        proposal: _proposalController.text.trim(),
        portfolioLinks: _portfolioLinks,
        status: ApplicationStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
