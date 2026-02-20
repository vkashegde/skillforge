import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Type alias for Result pattern using Either from dartz
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  /// Returns true if the result is a success
  bool get isSuccess => isRight();

  /// Returns true if the result is a failure
  bool get isFailure => isLeft();

  /// Gets the value if success, null otherwise
  T? get value => fold((l) => null, (r) => r);

  /// Gets the failure if failure, null otherwise
  Failure? get failure => fold((l) => l, (r) => null);
}
