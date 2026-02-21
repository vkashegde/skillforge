import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Skill Forge';
  static const String appVersion = '0.1.0';

  // API Constants (if needed in future)
  static const String baseUrl = 'https://api.example.com';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Supabase Constants
  // For production builds: Use --dart-define flags
  // For local development: Use .env file
  static String get supabaseUrl {
    // Try compile-time constant first (from --dart-define)
    const urlFromDefine = String.fromEnvironment('SUPABASE_URL');
    if (urlFromDefine.isNotEmpty) {
      return urlFromDefine;
    }

    // Fallback to .env file (for local development)
    if (kDebugMode) {
      try {
        final url = dotenv.env['SUPABASE_URL'];
        if (url != null && url.isNotEmpty) {
          return url;
        }
      } catch (e) {
        // dotenv not loaded yet, will throw below
      }
    }

    throw Exception(
      'SUPABASE_URL is not set. '
      'For production: Use --dart-define=SUPABASE_URL=your_url '
      'For local: Ensure .env file exists with SUPABASE_URL',
    );
  }

  static String get supabaseAnonKey {
    // Try compile-time constant first (from --dart-define)
    const keyFromDefine = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (keyFromDefine.isNotEmpty) {
      return keyFromDefine;
    }

    // Fallback to .env file (for local development)
    if (kDebugMode) {
      try {
        final key = dotenv.env['SUPABASE_ANON_KEY'];
        if (key != null && key.isNotEmpty) {
          return key;
        }
      } catch (e) {
        // dotenv not loaded yet, will throw below
      }
    }

    throw Exception(
      'SUPABASE_ANON_KEY is not set. '
      'For production: Use --dart-define=SUPABASE_ANON_KEY=your_key '
      'For local: Ensure .env file exists with SUPABASE_ANON_KEY',
    );
  }
}
