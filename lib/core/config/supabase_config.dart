import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

/// Initialize Supabase client
/// Credentials are loaded from .env file via AppConstants
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
}

/// Get Supabase client instance
SupabaseClient get supabase => Supabase.instance.client;
