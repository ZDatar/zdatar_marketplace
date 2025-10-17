import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class User {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String walletAddress;
  
  @HiveField(2)
  final String? username;
  
  @HiveField(3)
  final String? avatar;
  
  @HiveField(4)
  final double rating;
  
  @HiveField(5)
  final int totalSales;
  
  @HiveField(6)
  final int totalPurchases;
  
  @HiveField(7)
  final double totalEarnings;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime updatedAt;
  
  @HiveField(10)
  final bool isVerified;
  
  @HiveField(11)
  final List<String> specializations;

  const User({
    required this.id,
    required this.walletAddress,
    this.username,
    this.avatar,
    this.rating = 0.0,
    this.totalSales = 0,
    this.totalPurchases = 0,
    this.totalEarnings = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.specializations = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? walletAddress,
    String? username,
    String? avatar,
    double? rating,
    int? totalSales,
    int? totalPurchases,
    double? totalEarnings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    List<String>? specializations,
  }) {
    return User(
      id: id ?? this.id,
      walletAddress: walletAddress ?? this.walletAddress,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      rating: rating ?? this.rating,
      totalSales: totalSales ?? this.totalSales,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      specializations: specializations ?? this.specializations,
    );
  }
}
