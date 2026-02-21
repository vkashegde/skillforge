import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Sign up with email and password
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign in with GitHub
  Future<Either<Failure, UserEntity>> signInWithGitHub();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  UserEntity? getCurrentUser();

  /// Reset password
  Future<Either<Failure, void>> resetPassword(String email);
}
