import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

/// Profile repository interface
abstract class ProfileRepository {
  /// Save or update user profile
  Future<Either<Failure, ProfileEntity>> saveProfile(ProfileEntity profile);

  /// Get user profile
  Future<Either<Failure, ProfileEntity?>> getProfile(String userId);

  /// Update profile fields
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String userId,
    String? goal,
    String? skillLevel,
    String? timeCommitment,
  });
}
