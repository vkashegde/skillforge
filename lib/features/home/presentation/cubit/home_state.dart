part of 'home_cubit.dart';

/// Base class for home states
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {}

/// Loading state
class HomeLoading extends HomeState {}

/// Loaded state
class HomeLoaded extends HomeState {
  final HomeEntity entity;

  const HomeLoaded(this.entity);

  @override
  List<Object?> get props => [entity];
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
