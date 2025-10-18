import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/web_utils.dart';

void main() async {
  // Initialize web-specific configurations
  WebUtils.initializeWeb();

  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Open boxes for caching with error handling
    await _initializeHiveBoxes();
    
    runApp(
      const ProviderScope(
        child: ZDatarMarketplaceApp(),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error during app initialization: $e');
    }
    // Run app with minimal configuration if initialization fails
    runApp(
      const ProviderScope(
        child: ZDatarMarketplaceApp(),
      ),
    );
  }
}

Future<void> _initializeHiveBoxes() async {
  try {
    await Hive.openBox(AppConstants.userBox);
  } catch (e) {
    if (kDebugMode) print('Failed to open user box: $e');
  }
  
  try {
    await Hive.openBox(AppConstants.datasetBox);
  } catch (e) {
    if (kDebugMode) print('Failed to open dataset box: $e');
  }
  
  try {
    await Hive.openBox(AppConstants.transactionBox);
  } catch (e) {
    if (kDebugMode) print('Failed to open transaction box: $e');
  }
}
