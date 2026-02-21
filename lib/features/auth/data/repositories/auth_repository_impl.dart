import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gotrue/gotrue.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        return const Left(Failure.server(message: 'Failed to create account'));
      }

      final user = UserEntity(
        id: response.user!.id,
        email: response.user!.email,
        fullName: response.user!.userMetadata?['full_name'] as String?,
        avatarUrl: response.user!.userMetadata?['avatar_url'] as String?,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(Failure.server(message: 'Failed to sign in'));
      }

      final user = UserEntity(
        id: response.user!.id,
        email: response.user!.email,
        fullName: response.user!.userMetadata?['full_name'] as String?,
        avatarUrl: response.user!.userMetadata?['avatar_url'] as String?,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: Uri.base.origin,
      );
      // Note: OAuth flow will redirect, user will be available after redirect
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        return const Left(Failure.server(message: 'OAuth sign in failed'));
      }
      return Right(currentUser);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGitHub() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: Uri.base.origin,
      );
      // Note: OAuth flow will redirect, user will be available after redirect
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        return const Left(Failure.server(message: 'OAuth sign in failed'));
      }
      return Right(currentUser);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    return UserEntity(
      id: user.id,
      email: user.email,
      fullName: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
