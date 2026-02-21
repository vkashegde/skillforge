import '../../../../core/config/supabase_config.dart';

/// Helper class for checking authentication state
class AuthHelper {
  /// Check if user is currently logged in
  static bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    return supabase.auth.currentUser?.id;
  }

  /// Get current user email
  static String? getCurrentUserEmail() {
    return supabase.auth.currentUser?.email;
  }
}
