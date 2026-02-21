import 'package:dartz/dartz.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

/// Profile repository implementation
class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Either<Failure, ProfileEntity>> saveProfile(
      ProfileEntity profile) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      final now = DateTime.now();

      final data = {
        ...model.toJson(),
        'updated_at': now.toIso8601String(),
      };

      // Check if profile exists
      final existing = await supabase
          .from('profiles')
          .select()
          .eq('user_id', profile.userId)
          .maybeSingle();

      if (existing != null) {
        // Update existing profile
        await supabase
            .from('profiles')
            .update(data)
            .eq('user_id', profile.userId);
      } else {
        // Insert new profile
        data['created_at'] = now.toIso8601String();
        await supabase.from('profiles').insert(data);
      }

      final updatedProfile = ProfileEntity(
        userId: profile.userId,
        goal: profile.goal,
        skillLevel: profile.skillLevel,
        timeCommitment: profile.timeCommitment,
        createdAt: existing != null ? profile.createdAt : now,
        updatedAt: now,
      );

      return Right(updatedProfile);
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return const Right(null);
      }

      final model = ProfileModel.fromJson(response);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String userId,
    String? goal,
    String? skillLevel,
    String? timeCommitment,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (goal != null) updateData['goal'] = goal;
      if (skillLevel != null) updateData['skill_level'] = skillLevel;
      if (timeCommitment != null) updateData['time_commitment'] = timeCommitment;

      await supabase.from('profiles').update(updateData).eq('user_id', userId);

      // Fetch updated profile
      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single();

      final model = ProfileModel.fromJson(response);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
