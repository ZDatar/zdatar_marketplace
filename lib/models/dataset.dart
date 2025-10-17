import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'dataset.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Dataset {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String sellerId;
  
  @HiveField(4)
  final DatasetCategory category;
  
  @HiveField(5)
  final List<String> tags;
  
  @HiveField(6)
  final double price;
  
  @HiveField(7)
  final String currency;
  
  @HiveField(8)
  final int fileSizeBytes;
  
  @HiveField(9)
  final String fileType;
  
  @HiveField(10)
  final DateTime dataStartDate;
  
  @HiveField(11)
  final DateTime dataEndDate;
  
  @HiveField(12)
  final String? region;
  
  @HiveField(13)
  final String? previewImageUrl;
  
  @HiveField(14)
  final Map<String, dynamic>? metadata;
  
  @HiveField(15)
  final String encryptedFileUrl;
  
  @HiveField(16)
  final String encryptionKeyHash;
  
  @HiveField(17)
  final DatasetStatus status;
  
  @HiveField(18)
  final int totalSales;
  
  @HiveField(19)
  final double rating;
  
  @HiveField(20)
  final int reviewCount;
  
  @HiveField(21)
  final DateTime createdAt;
  
  @HiveField(22)
  final DateTime updatedAt;
  
  @HiveField(23)
  final bool hasSample;
  
  @HiveField(24)
  final String? sampleDataUrl;

  const Dataset({
    required this.id,
    required this.title,
    required this.description,
    required this.sellerId,
    required this.category,
    required this.tags,
    required this.price,
    required this.currency,
    required this.fileSizeBytes,
    required this.fileType,
    required this.dataStartDate,
    required this.dataEndDate,
    this.region,
    this.previewImageUrl,
    this.metadata,
    required this.encryptedFileUrl,
    required this.encryptionKeyHash,
    required this.status,
    this.totalSales = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.hasSample = false,
    this.sampleDataUrl,
  });

  factory Dataset.fromJson(Map<String, dynamic> json) => _$DatasetFromJson(json);
  Map<String, dynamic> toJson() => _$DatasetToJson(this);

  String get formattedFileSize {
    if (fileSizeBytes < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    if (fileSizeBytes < 1024 * 1024 * 1024) return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String get formattedPrice => '$price $currency';

  Dataset copyWith({
    String? id,
    String? title,
    String? description,
    String? sellerId,
    DatasetCategory? category,
    List<String>? tags,
    double? price,
    String? currency,
    int? fileSizeBytes,
    String? fileType,
    DateTime? dataStartDate,
    DateTime? dataEndDate,
    String? region,
    String? previewImageUrl,
    Map<String, dynamic>? metadata,
    String? encryptedFileUrl,
    String? encryptionKeyHash,
    DatasetStatus? status,
    int? totalSales,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasSample,
    String? sampleDataUrl,
  }) {
    return Dataset(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      sellerId: sellerId ?? this.sellerId,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      fileType: fileType ?? this.fileType,
      dataStartDate: dataStartDate ?? this.dataStartDate,
      dataEndDate: dataEndDate ?? this.dataEndDate,
      region: region ?? this.region,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      metadata: metadata ?? this.metadata,
      encryptedFileUrl: encryptedFileUrl ?? this.encryptedFileUrl,
      encryptionKeyHash: encryptionKeyHash ?? this.encryptionKeyHash,
      status: status ?? this.status,
      totalSales: totalSales ?? this.totalSales,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasSample: hasSample ?? this.hasSample,
      sampleDataUrl: sampleDataUrl ?? this.sampleDataUrl,
    );
  }
}

@HiveType(typeId: 2)
enum DatasetCategory {
  @HiveField(0)
  location,
  @HiveField(1)
  motion,
  @HiveField(2)
  health,
  @HiveField(3)
  appUsage,
  @HiveField(4)
  battery,
  @HiveField(5)
  network,
  @HiveField(6)
  deviceInfo,
  @HiveField(7)
  sensorData,
}

@HiveType(typeId: 3)
enum DatasetStatus {
  @HiveField(0)
  draft,
  @HiveField(1)
  pending,
  @HiveField(2)
  active,
  @HiveField(3)
  sold,
  @HiveField(4)
  suspended,
  @HiveField(5)
  deleted,
}

extension DatasetCategoryExtension on DatasetCategory {
  String get displayName {
    switch (this) {
      case DatasetCategory.location:
        return 'Location';
      case DatasetCategory.motion:
        return 'Motion';
      case DatasetCategory.health:
        return 'Health';
      case DatasetCategory.appUsage:
        return 'App Usage';
      case DatasetCategory.battery:
        return 'Battery';
      case DatasetCategory.network:
        return 'Network';
      case DatasetCategory.deviceInfo:
        return 'Device Info';
      case DatasetCategory.sensorData:
        return 'Sensor Data';
    }
  }

  String get icon {
    switch (this) {
      case DatasetCategory.location:
        return '📍';
      case DatasetCategory.motion:
        return '🏃';
      case DatasetCategory.health:
        return '❤️';
      case DatasetCategory.appUsage:
        return '📱';
      case DatasetCategory.battery:
        return '🔋';
      case DatasetCategory.network:
        return '📶';
      case DatasetCategory.deviceInfo:
        return '📟';
      case DatasetCategory.sensorData:
        return '⚡';
    }
  }
}
