import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Open boxes for caching
  await Hive.openBox(AppConstants.userBox);
  await Hive.openBox(AppConstants.datasetBox);
  await Hive.openBox(AppConstants.transactionBox);
  
  runApp(
    const ProviderScope(
      child: ZDatarMarketplaceApp(),
    ),
  );
}
