import 'package:flutter/foundation.dart';

class WebUtils {
  /// Initialize web-specific configurations
  static void initializeWeb() {
    if (kIsWeb) {
      // Add any web-specific initialization here
      _setupErrorHandling();
    }
  }

  static void _setupErrorHandling() {
    // Handle uncaught errors in web
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        // In production, log errors silently
        debugPrint('Flutter Error: ${details.exception}');
      }
    };
  }

  /// Check if running in web environment
  static bool get isWeb => kIsWeb;

  /// Get user agent for web-specific features
  static String? getUserAgent() {
    if (kIsWeb) {
      // In a real implementation, you would get this from dart:html
      return 'Flutter Web App';
    }
    return null;
  }
}
