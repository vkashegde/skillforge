import '../../../../core/config/supabase_config.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/repositories/profile_repository.dart';

/// Helper class for checking profile state
class ProfileHelper {
  /// Check if current user has a completed profile
  static Future<bool> hasProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final profileRepository = di.sl<ProfileRepository>();
      final result = await profileRepository.getProfile(userId);

      return result.fold(
        (_) => false,
        (profile) => profile != null &&
            profile.goal != null &&
            profile.skillLevel != null &&
            profile.timeCommitment != null,
      );
    } catch (e) {
      return false;
    }
  }

  /// Check if profile exists (even if incomplete)
  static Future<bool> profileExists() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final profileRepository = di.sl<ProfileRepository>();
      final result = await profileRepository.getProfile(userId);

      return result.fold(
        (_) => false,
        (profile) => profile != null,
      );
    } catch (e) {
      return false;
    }
  }
}
