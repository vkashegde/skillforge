import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class for the application
@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.validation({
    required String message,
  }) = ValidationFailure;

  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;
}

/// Extension to get error message from any failure type
extension FailureExtension on Failure {
  String get errorMessage => when(
        server: (message, _) => message,
        network: (message) => message,
        cache: (message) => message,
        validation: (message) => message,
        unknown: (message) => message,
      );
}
