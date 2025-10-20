import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/data_task.dart';

// Task Filters State
class TaskFilters {
  final String searchQuery;
  final List<TaskType> taskTypes;
  final List<TaskCategory> categories;
  final List<TaskDifficulty> difficulties;
  final double minBudget;
  final double maxBudget;
  final List<String> currencies;
  final List<String> requiredSkills;
  final bool isUrgentOnly;
  final bool requiresVerificationOnly;
  final DateTime? deadlineBefore;
  final TaskSortOption sortOption;

  const TaskFilters({
    this.searchQuery = '',
    this.taskTypes = const [],
    this.categories = const [],
    this.difficulties = const [],
    this.minBudget = 0,
    this.maxBudget = 10000,
    this.currencies = const [],
    this.requiredSkills = const [],
    this.isUrgentOnly = false,
    this.requiresVerificationOnly = false,
    this.deadlineBefore,
    this.sortOption = TaskSortOption.newest,
  });

  TaskFilters copyWith({
    String? searchQuery,
    List<TaskType>? taskTypes,
    List<TaskCategory>? categories,
    List<TaskDifficulty>? difficulties,
    double? minBudget,
    double? maxBudget,
    List<String>? currencies,
    List<String>? requiredSkills,
    bool? isUrgentOnly,
    bool? requiresVerificationOnly,
    DateTime? deadlineBefore,
    TaskSortOption? sortOption,
  }) {
    return TaskFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      taskTypes: taskTypes ?? this.taskTypes,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      currencies: currencies ?? this.currencies,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      isUrgentOnly: isUrgentOnly ?? this.isUrgentOnly,
      requiresVerificationOnly: requiresVerificationOnly ?? this.requiresVerificationOnly,
      deadlineBefore: deadlineBefore ?? this.deadlineBefore,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

enum TaskSortOption {
  newest,
  oldest,
  budgetHighToLow,
  budgetLowToHigh,
  deadlineSoon,
  mostApplications,
  leastApplications,
}

// Task Filters Notifier
class TaskFiltersNotifier extends StateNotifier<TaskFilters> {
  TaskFiltersNotifier() : super(const TaskFilters());

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleTaskType(TaskType taskType) {
    final taskTypes = List<TaskType>.from(state.taskTypes);
    if (taskTypes.contains(taskType)) {
      taskTypes.remove(taskType);
    } else {
      taskTypes.add(taskType);
    }
    state = state.copyWith(taskTypes: taskTypes);
  }

  void toggleCategory(TaskCategory category) {
    final categories = List<TaskCategory>.from(state.categories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(categories: categories);
  }

  void toggleDifficulty(TaskDifficulty difficulty) {
    final difficulties = List<TaskDifficulty>.from(state.difficulties);
    if (difficulties.contains(difficulty)) {
      difficulties.remove(difficulty);
    } else {
      difficulties.add(difficulty);
    }
    state = state.copyWith(difficulties: difficulties);
  }

  void updateBudgetRange(double min, double max) {
    state = state.copyWith(minBudget: min, maxBudget: max);
  }

  void toggleCurrency(String currency) {
    final currencies = List<String>.from(state.currencies);
    if (currencies.contains(currency)) {
      currencies.remove(currency);
    } else {
      currencies.add(currency);
    }
    state = state.copyWith(currencies: currencies);
  }

  void toggleSkill(String skill) {
    final skills = List<String>.from(state.requiredSkills);
    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }
    state = state.copyWith(requiredSkills: skills);
  }

  void toggleUrgentOnly() {
    state = state.copyWith(isUrgentOnly: !state.isUrgentOnly);
  }

  void toggleVerificationOnly() {
    state = state.copyWith(requiresVerificationOnly: !state.requiresVerificationOnly);
  }

  void updateDeadline(DateTime? deadline) {
    state = state.copyWith(deadlineBefore: deadline);
  }

  void updateSort(TaskSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearFilters() {
    state = const TaskFilters();
  }
}

final taskFiltersProvider = StateNotifierProvider<TaskFiltersNotifier, TaskFilters>(
  (ref) => TaskFiltersNotifier(),
);

// Tasks State
class TasksState {
  final List<DataTask> tasks;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int page;

  const TasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.page = 1,
  });

  TasksState copyWith({
    List<DataTask>? tasks,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? page,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      page: page ?? this.page,
    );
  }
}

// Tasks Notifier
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final newTasks = _generateMockTasks(state.page);

      state = state.copyWith(
        tasks: state.page == 1 ? newTasks : [...state.tasks, ...newTasks],
        isLoading: false,
        hasMore: newTasks.isNotEmpty,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadTasks();
  }

  Future<void> refresh() async {
    state = const TasksState();
    await loadTasks();
  }

  Future<void> applyFilters() async {
    state = const TasksState();
    await loadTasks();
  }

  Future<void> createTask(DataTask task) async {
    try {
      // Simulate API call to create task
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Add to local state
      final updatedTasks = [task, ...state.tasks];
      state = state.copyWith(tasks: updatedTasks);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  List<DataTask> _generateMockTasks(int page) {
    // Generate mock tasks for demonstration
    if (page > 3) return []; // Simulate end of data

    return List.generate(8, (index) {
      final id = ((page - 1) * 8 + index + 1).toString();
      const taskTypes = TaskType.values;
      const categories = TaskCategory.values;
      const difficulties = TaskDifficulty.values;
      
      return DataTask(
        id: id,
        title: _getTaskTitle(index, taskTypes[index % taskTypes.length]),
        description: _getTaskDescription(index, taskTypes[index % taskTypes.length]),
        buyerId: 'buyer$id',
        taskType: taskTypes[index % taskTypes.length],
        category: categories[index % categories.length],
        requiredSkills: _getRequiredSkills(taskTypes[index % taskTypes.length]),
        budget: 100.0 + (index * 150.0),
        currency: ['SOL', 'USDC', 'ZDTR'][index % 3],
        pricingType: TaskPricing.values[index % TaskPricing.values.length],
        deadline: DateTime.now().add(Duration(days: 7 + index * 3)),
        difficulty: difficulties[index % difficulties.length],
        estimatedHours: 10 + (index * 5),
        status: TaskStatus.active,
        attachments: index % 3 == 0 ? ['sample_data.csv', 'requirements.pdf'] : [],
        deliverables: _getDeliverables(taskTypes[index % taskTypes.length]),
        datasetUrl: index % 2 == 0 ? 'https://storage.zdatar.com/dataset$id' : null,
        datasetSize: index % 2 == 0 ? (1 + index) * 1024 * 1024 : null,
        dataFormat: index % 2 == 0 ? ['CSV', 'JSON', 'Parquet'][index % 3] : null,
        applications: [],
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(hours: index)),
        reviewCount: index * 2,
        isUrgent: index % 4 == 0,
        requiresVerification: index % 3 == 0,
        preferredRegions: ['Global', 'North America', 'Europe'][index % 3] == 'Global' 
            ? [] : [['North America', 'Europe', 'Asia'][index % 3]],
        sampleDataUrl: index % 3 == 0 ? 'https://storage.zdatar.com/sample$id' : null,
      );
    });
  }

  String _getTaskTitle(int index, TaskType taskType) {
    switch (taskType) {
      case TaskType.dataLabeling:
        return [
          'Label 10K Product Images for E-commerce',
          'Annotate Medical X-Ray Images',
          'Text Sentiment Analysis Labeling',
          'Video Object Detection Annotation',
        ][index % 4];
      case TaskType.dataEngineering:
        return [
          'Build ETL Pipeline for Customer Data',
          'Design Data Warehouse Schema',
          'Clean and Process Sales Data',
          'Create Real-time Analytics Pipeline',
        ][index % 4];
      case TaskType.dataVisualization:
        return [
          'Create Interactive Sales Dashboard',
          'Build Customer Analytics Visualization',
          'Design KPI Monitoring Dashboard',
          'Develop Market Trends Visualization',
        ][index % 4];
      default:
        return 'Data Task ${index + 1}';
    }
  }

  String _getTaskDescription(int index, TaskType taskType) {
    switch (taskType) {
      case TaskType.dataLabeling:
        return 'We need experienced data labelers to help us annotate our dataset. The task requires attention to detail and consistency in labeling standards.';
      case TaskType.dataEngineering:
        return 'Looking for a skilled data engineer to help process and transform our raw data into a structured format suitable for analysis.';
      case TaskType.dataVisualization:
        return 'We need a data visualization expert to create compelling and interactive dashboards that tell the story of our data.';
      default:
        return 'Detailed task description will be provided to selected candidates.';
    }
  }

  List<String> _getRequiredSkills(TaskType taskType) {
    switch (taskType) {
      case TaskType.dataLabeling:
        return ['Data Annotation', 'Quality Control', 'Attention to Detail'];
      case TaskType.dataEngineering:
        return ['Python', 'SQL', 'ETL', 'Data Processing'];
      case TaskType.dataVisualization:
        return ['Tableau', 'Power BI', 'D3.js', 'Data Storytelling'];
      default:
        return ['Data Analysis', 'Problem Solving'];
    }
  }

  List<String> _getDeliverables(TaskType taskType) {
    switch (taskType) {
      case TaskType.dataLabeling:
        return ['Labeled Dataset', 'Quality Report', 'Annotation Guidelines'];
      case TaskType.dataEngineering:
        return ['Processed Data', 'ETL Scripts', 'Documentation'];
      case TaskType.dataVisualization:
        return ['Interactive Dashboard', 'Source Code', 'User Guide'];
      default:
        return ['Final Report', 'Source Files'];
    }
  }
}

final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);

// My Tasks Provider (for buyers to see their created tasks)
final myTasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);

// Task Creation State
class TaskCreationState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const TaskCreationState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  TaskCreationState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return TaskCreationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class TaskCreationNotifier extends StateNotifier<TaskCreationState> {
  TaskCreationNotifier() : super(const TaskCreationState());

  Future<bool> createTask(DataTask task) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Task created successfully!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create task: ${e.toString()}',
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

final taskCreationProvider = StateNotifierProvider<TaskCreationNotifier, TaskCreationState>(
  (ref) => TaskCreationNotifier(),
);

// Extension for sort option labels
extension TaskSortOptionExtension on TaskSortOption {
  String get displayName {
    switch (this) {
      case TaskSortOption.newest:
        return 'Newest';
      case TaskSortOption.oldest:
        return 'Oldest';
      case TaskSortOption.budgetHighToLow:
        return 'Budget: High to Low';
      case TaskSortOption.budgetLowToHigh:
        return 'Budget: Low to High';
      case TaskSortOption.deadlineSoon:
        return 'Deadline: Soon';
      case TaskSortOption.mostApplications:
        return 'Most Applications';
      case TaskSortOption.leastApplications:
        return 'Least Applications';
    }
  }
}
