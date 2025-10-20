import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'data_task.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class DataTask {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String buyerId;
  
  @HiveField(4)
  final TaskType taskType;
  
  @HiveField(5)
  final TaskCategory category;
  
  @HiveField(6)
  final List<String> requiredSkills;
  
  @HiveField(7)
  final double budget;
  
  @HiveField(8)
  final String currency;
  
  @HiveField(9)
  final TaskPricing pricingType;
  
  @HiveField(10)
  final DateTime deadline;
  
  @HiveField(11)
  final TaskDifficulty difficulty;
  
  @HiveField(12)
  final int estimatedHours;
  
  @HiveField(13)
  final TaskStatus status;
  
  @HiveField(14)
  final List<String> attachments;
  
  @HiveField(15)
  final Map<String, dynamic>? taskSpecifications;
  
  @HiveField(16)
  final List<String> deliverables;
  
  @HiveField(17)
  final String? datasetUrl;
  
  @HiveField(18)
  final int? datasetSize;
  
  @HiveField(19)
  final String? dataFormat;
  
  @HiveField(20)
  final List<TaskApplication> applications;
  
  @HiveField(21)
  final String? assignedWorkerId;
  
  @HiveField(22)
  final DateTime createdAt;
  
  @HiveField(23)
  final DateTime updatedAt;
  
  @HiveField(24)
  final double? rating;
  
  @HiveField(25)
  final int reviewCount;
  
  @HiveField(26)
  final bool isUrgent;
  
  @HiveField(27)
  final bool requiresVerification;
  
  @HiveField(28)
  final List<String> preferredRegions;
  
  @HiveField(29)
  final String? sampleDataUrl;

  const DataTask({
    required this.id,
    required this.title,
    required this.description,
    required this.buyerId,
    required this.taskType,
    required this.category,
    required this.requiredSkills,
    required this.budget,
    required this.currency,
    required this.pricingType,
    required this.deadline,
    required this.difficulty,
    required this.estimatedHours,
    required this.status,
    this.attachments = const [],
    this.taskSpecifications,
    this.deliverables = const [],
    this.datasetUrl,
    this.datasetSize,
    this.dataFormat,
    this.applications = const [],
    this.assignedWorkerId,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
    this.reviewCount = 0,
    this.isUrgent = false,
    this.requiresVerification = false,
    this.preferredRegions = const [],
    this.sampleDataUrl,
  });

  factory DataTask.fromJson(Map<String, dynamic> json) => _$DataTaskFromJson(json);
  Map<String, dynamic> toJson() => _$DataTaskToJson(this);

  String get formattedBudget => '$budget $currency';
  
  String get formattedDatasetSize {
    if (datasetSize == null) return 'N/A';
    if (datasetSize! < 1024) return '${datasetSize!}B';
    if (datasetSize! < 1024 * 1024) return '${(datasetSize! / 1024).toStringAsFixed(1)}KB';
    if (datasetSize! < 1024 * 1024 * 1024) return '${(datasetSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(datasetSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  bool get isDataLabelingTask => taskType == TaskType.dataLabeling;
  bool get isDataEngineeringTask => taskType == TaskType.dataEngineering;
  bool get hasDataset => datasetUrl != null && datasetUrl!.isNotEmpty;
  bool get isAssigned => assignedWorkerId != null;
  bool get isCompleted => status == TaskStatus.completed;
  bool get isActive => status == TaskStatus.active;

  DataTask copyWith({
    String? id,
    String? title,
    String? description,
    String? buyerId,
    TaskType? taskType,
    TaskCategory? category,
    List<String>? requiredSkills,
    double? budget,
    String? currency,
    TaskPricing? pricingType,
    DateTime? deadline,
    TaskDifficulty? difficulty,
    int? estimatedHours,
    TaskStatus? status,
    List<String>? attachments,
    Map<String, dynamic>? taskSpecifications,
    List<String>? deliverables,
    String? datasetUrl,
    int? datasetSize,
    String? dataFormat,
    List<TaskApplication>? applications,
    String? assignedWorkerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    int? reviewCount,
    bool? isUrgent,
    bool? requiresVerification,
    List<String>? preferredRegions,
    String? sampleDataUrl,
  }) {
    return DataTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      buyerId: buyerId ?? this.buyerId,
      taskType: taskType ?? this.taskType,
      category: category ?? this.category,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      pricingType: pricingType ?? this.pricingType,
      deadline: deadline ?? this.deadline,
      difficulty: difficulty ?? this.difficulty,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      taskSpecifications: taskSpecifications ?? this.taskSpecifications,
      deliverables: deliverables ?? this.deliverables,
      datasetUrl: datasetUrl ?? this.datasetUrl,
      datasetSize: datasetSize ?? this.datasetSize,
      dataFormat: dataFormat ?? this.dataFormat,
      applications: applications ?? this.applications,
      assignedWorkerId: assignedWorkerId ?? this.assignedWorkerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isUrgent: isUrgent ?? this.isUrgent,
      requiresVerification: requiresVerification ?? this.requiresVerification,
      preferredRegions: preferredRegions ?? this.preferredRegions,
      sampleDataUrl: sampleDataUrl ?? this.sampleDataUrl,
    );
  }
}

@HiveType(typeId: 5)
@JsonSerializable()
class TaskApplication {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String workerId;
  
  @HiveField(2)
  final String taskId;
  
  @HiveField(3)
  final double proposedBudget;
  
  @HiveField(4)
  final int proposedTimeframe;
  
  @HiveField(5)
  final String proposal;
  
  @HiveField(6)
  final List<String> portfolioLinks;
  
  @HiveField(7)
  final ApplicationStatus status;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime updatedAt;

  const TaskApplication({
    required this.id,
    required this.workerId,
    required this.taskId,
    required this.proposedBudget,
    required this.proposedTimeframe,
    required this.proposal,
    this.portfolioLinks = const [],
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskApplication.fromJson(Map<String, dynamic> json) => _$TaskApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$TaskApplicationToJson(this);
}

@HiveType(typeId: 6)
enum TaskType {
  @HiveField(0)
  dataLabeling,
  @HiveField(1)
  dataEngineering,
  @HiveField(2)
  dataVisualization,
  @HiveField(3)
  dataAnalysis,
  @HiveField(4)
  dataCollection,
  @HiveField(5)
  dataValidation,
}

@HiveType(typeId: 7)
enum TaskCategory {
  @HiveField(0)
  imageAnnotation,
  @HiveField(1)
  textLabeling,
  @HiveField(2)
  audioTranscription,
  @HiveField(3)
  videoAnnotation,
  @HiveField(4)
  dataProcessing,
  @HiveField(5)
  etlPipeline,
  @HiveField(6)
  dataVisualization,
  @HiveField(7)
  machineLearning,
  @HiveField(8)
  dataAnalysis,
  @HiveField(9)
  dataValidation,
  @HiveField(10)
  dataCollection,
  @HiveField(11)
  databaseDesign,
}

@HiveType(typeId: 8)
enum TaskDifficulty {
  @HiveField(0)
  beginner,
  @HiveField(1)
  intermediate,
  @HiveField(2)
  advanced,
  @HiveField(3)
  expert,
}

@HiveType(typeId: 9)
enum TaskStatus {
  @HiveField(0)
  draft,
  @HiveField(1)
  active,
  @HiveField(2)
  assigned,
  @HiveField(3)
  inProgress,
  @HiveField(4)
  underReview,
  @HiveField(5)
  completed,
  @HiveField(6)
  cancelled,
  @HiveField(7)
  disputed,
}

@HiveType(typeId: 10)
enum TaskPricing {
  @HiveField(0)
  fixed,
  @HiveField(1)
  hourly,
  @HiveField(2)
  perItem,
  @HiveField(3)
  milestone,
}

@HiveType(typeId: 11)
enum ApplicationStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  accepted,
  @HiveField(2)
  rejected,
  @HiveField(3)
  withdrawn,
}

// Extensions for better display names
extension TaskTypeExtension on TaskType {
  String get displayName {
    switch (this) {
      case TaskType.dataLabeling:
        return 'Data Labeling';
      case TaskType.dataEngineering:
        return 'Data Engineering';
      case TaskType.dataVisualization:
        return 'Data Visualization';
      case TaskType.dataAnalysis:
        return 'Data Analysis';
      case TaskType.dataCollection:
        return 'Data Collection';
      case TaskType.dataValidation:
        return 'Data Validation';
    }
  }

  String get icon {
    switch (this) {
      case TaskType.dataLabeling:
        return '🏷️';
      case TaskType.dataEngineering:
        return '⚙️';
      case TaskType.dataVisualization:
        return '📊';
      case TaskType.dataAnalysis:
        return '📈';
      case TaskType.dataCollection:
        return '📥';
      case TaskType.dataValidation:
        return '✅';
    }
  }
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.imageAnnotation:
        return 'Image Annotation';
      case TaskCategory.textLabeling:
        return 'Text Labeling';
      case TaskCategory.audioTranscription:
        return 'Audio Transcription';
      case TaskCategory.videoAnnotation:
        return 'Video Annotation';
      case TaskCategory.dataProcessing:
        return 'Data Processing';
      case TaskCategory.etlPipeline:
        return 'ETL Pipeline';
      case TaskCategory.dataVisualization:
        return 'Data Visualization';
      case TaskCategory.machineLearning:
        return 'Machine Learning';
      case TaskCategory.dataAnalysis:
        return 'Data Analysis';
      case TaskCategory.dataValidation:
        return 'Data Validation';
      case TaskCategory.dataCollection:
        return 'Data Collection';
      case TaskCategory.databaseDesign:
        return 'Database Design';
    }
  }
}

extension TaskDifficultyExtension on TaskDifficulty {
  String get displayName {
    switch (this) {
      case TaskDifficulty.beginner:
        return 'Beginner';
      case TaskDifficulty.intermediate:
        return 'Intermediate';
      case TaskDifficulty.advanced:
        return 'Advanced';
      case TaskDifficulty.expert:
        return 'Expert';
    }
  }

  String get icon {
    switch (this) {
      case TaskDifficulty.beginner:
        return '🟢';
      case TaskDifficulty.intermediate:
        return '🟡';
      case TaskDifficulty.advanced:
        return '🟠';
      case TaskDifficulty.expert:
        return '🔴';
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.draft:
        return 'Draft';
      case TaskStatus.active:
        return 'Active';
      case TaskStatus.assigned:
        return 'Assigned';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.underReview:
        return 'Under Review';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.disputed:
        return 'Disputed';
    }
  }
}
