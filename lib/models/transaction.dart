import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class Transaction {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String datasetId;
  
  @HiveField(2)
  final String buyerId;
  
  @HiveField(3)
  final String sellerId;
  
  @HiveField(4)
  final double amount;
  
  @HiveField(5)
  final String currency;
  
  @HiveField(6)
  final double platformFee;
  
  @HiveField(7)
  final String transactionHash;
  
  @HiveField(8)
  final TransactionStatus status;
  
  @HiveField(9)
  final DateTime createdAt;
  
  @HiveField(10)
  final DateTime? completedAt;
  
  @HiveField(11)
  final String? decryptionToken;
  
  @HiveField(12)
  final String? errorMessage;
  
  @HiveField(13)
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.datasetId,
    required this.buyerId,
    required this.sellerId,
    required this.amount,
    required this.currency,
    required this.platformFee,
    required this.transactionHash,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.decryptionToken,
    this.errorMessage,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  double get netAmount => amount - platformFee;
  String get formattedAmount => '$amount $currency';
  String get formattedPlatformFee => '$platformFee $currency';
  String get formattedNetAmount => '$netAmount $currency';

  Transaction copyWith({
    String? id,
    String? datasetId,
    String? buyerId,
    String? sellerId,
    double? amount,
    String? currency,
    double? platformFee,
    String? transactionHash,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? decryptionToken,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      datasetId: datasetId ?? this.datasetId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      platformFee: platformFee ?? this.platformFee,
      transactionHash: transactionHash ?? this.transactionHash,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      decryptionToken: decryptionToken ?? this.decryptionToken,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 5)
enum TransactionStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  processing,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed,
  @HiveField(4)
  cancelled,
  @HiveField(5)
  refunded,
}

extension TransactionStatusExtension on TransactionStatus {
  String get displayName {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.processing:
        return 'Processing';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.refunded:
        return 'Refunded';
    }
  }

  bool get isCompleted => this == TransactionStatus.completed;
  bool get isFailed => this == TransactionStatus.failed;
  bool get isPending => this == TransactionStatus.pending || this == TransactionStatus.processing;
}
