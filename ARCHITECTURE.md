# Architecture Guide

## Clean Architecture Overview

This project follows **Clean Architecture** principles, which separates the application into three main layers:

1. **Presentation Layer** - UI, State Management (Cubit), Widgets
2. **Domain Layer** - Business Logic, Entities, Use Cases, Repository Interfaces
3. **Data Layer** - Data Sources, Models, Repository Implementations

## Dependency Rule

The dependency rule states that dependencies can only point inward:
- **Presentation** depends on **Domain**
- **Data** depends on **Domain**
- **Domain** depends on **nothing** (pure business logic)

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (UI, Cubits, Pages, Widgets)       │
└──────────────┬──────────────────────┘
               │ depends on
               ▼
┌─────────────────────────────────────┐
│        Domain Layer                  │
│  (Entities, Use Cases, Interfaces)  │
└──────────────┬──────────────────────┘
               │ implemented by
               ▼
┌─────────────────────────────────────┐
│         Data Layer                   │
│  (Models, Data Sources, Repos)      │
└──────────────────────────────────────┘
```

## Folder Structure

```
lib/
├── core/                           # Shared across all features
│   ├── constants/                  # App-wide constants
│   ├── di/                         # Dependency injection
│   ├── errors/                     # Error handling
│   │   ├── exceptions.dart         # Exception classes
│   │   └── failures.dart           # Failure classes (Freezed)
│   ├── network/                    # Network configuration
│   ├── router/                     # Go Router configuration
│   ├── theme/                      # App theming
│   └── utils/                      # Utility classes
│       ├── logger.dart             # Logging utility
│       └── result.dart             # Result pattern (Either)
│
├── features/                       # Feature modules
│   └── [feature_name]/
│       ├── data/                   # Data Layer
│       │   ├── datasources/        # Remote/Local data sources
│       │   ├── models/             # Data models (Freezed + JSON)
│       │   └── repositories/       # Repository implementations
│       │
│       ├── domain/                 # Domain Layer
│       │   ├── entities/           # Business entities (pure Dart)
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecases/           # Business logic use cases
│       │
│       └── presentation/           # Presentation Layer
│           ├── cubit/              # State management (Cubit)
│           ├── pages/              # Full screen widgets
│           └── widgets/            # Feature-specific widgets
│
└── shared/                         # Shared across features
    ├── widgets/                    # Reusable widgets
    └── utils/                      # Shared utilities
```

## Adding a New Feature

### Step 1: Create Feature Structure

Create the following folder structure:
```
lib/features/[feature_name]/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubit/
    ├── pages/
    └── widgets/
```

### Step 2: Define Domain Layer (Start Here!)

**Entity** (`domain/entities/[feature]_entity.dart`):
```dart
class FeatureEntity {
  final String id;
  final String name;
  
  const FeatureEntity({
    required this.id,
    required this.name,
  });
}
```

**Repository Interface** (`domain/repositories/[feature]_repository.dart`):
```dart
import '../../../../core/utils/result.dart';
import '../entities/feature_entity.dart';

abstract class FeatureRepository {
  Future<Result<FeatureEntity>> getFeature();
}
```

**Use Case** (`domain/usecases/get_feature.dart`):
```dart
import '../../../../core/utils/result.dart';
import '../entities/feature_entity.dart';
import '../repositories/feature_repository.dart';

class GetFeature {
  final FeatureRepository repository;
  
  GetFeature(this.repository);
  
  Future<Result<FeatureEntity>> call() async {
    return await repository.getFeature();
  }
}
```

### Step 3: Implement Data Layer

**Model** (`data/models/feature_model.dart`):
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/feature_entity.dart';

part 'feature_model.freezed.dart';
part 'feature_model.g.dart';

@freezed
class FeatureModel with _$FeatureModel {
  const factory FeatureModel({
    required String id,
    required String name,
  }) = _FeatureModel;

  factory FeatureModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureModelFromJson(json);
}

extension FeatureModelX on FeatureModel {
  FeatureEntity toEntity() {
    return FeatureEntity(
      id: id,
      name: name,
    );
  }
}
```

**Data Source** (`data/datasources/feature_remote_datasource.dart`):
```dart
import '../models/feature_model.dart';

abstract class FeatureRemoteDataSource {
  Future<FeatureModel> getFeature();
}

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  @override
  Future<FeatureModel> getFeature() async {
    // Implement API call
    throw UnimplementedError();
  }
}
```

**Repository Implementation** (`data/repositories/feature_repository_impl.dart`):
```dart
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/feature_entity.dart';
import '../../domain/repositories/feature_repository.dart';
import '../datasources/feature_remote_datasource.dart';
import '../models/feature_model.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;

  FeatureRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<FeatureEntity>> getFeature() async {
    try {
      final model = await remoteDataSource.getFeature();
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
```

### Step 4: Create Presentation Layer

**Cubit** (`presentation/cubit/feature_cubit.dart`):
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/feature_entity.dart';
import '../../domain/usecases/get_feature.dart';
import '../../../../core/utils/result.dart';

part 'feature_state.dart';

class FeatureCubit extends Cubit<FeatureState> {
  final GetFeature getFeature;

  FeatureCubit(this.getFeature) : super(FeatureInitial());

  Future<void> loadFeature() async {
    emit(FeatureLoading());
    
    final result = await getFeature();
    
    result.fold(
      (failure) => emit(FeatureError(failure.errorMessage)),
      (entity) => emit(FeatureLoaded(entity)),
    );
  }
}
```

**State** (`presentation/cubit/feature_state.dart`):
```dart
part of 'feature_cubit.dart';

abstract class FeatureState extends Equatable {
  const FeatureState();
  
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final FeatureEntity entity;
  const FeatureLoaded(this.entity);
  
  @override
  List<Object?> get props => [entity];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

**Page** (`presentation/pages/feature_page.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/feature_cubit.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeatureCubit(/* inject use case */)..loadFeature(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Feature')),
        body: BlocBuilder<FeatureCubit, FeatureState>(
          builder: (context, state) {
            if (state is FeatureLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FeatureError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is FeatureLoaded) {
              return Center(child: Text(state.entity.name));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
```

### Step 5: Register Dependencies

Add to `lib/core/di/injection_container.dart`:
```dart
// Data sources
sl.registerLazySingleton<FeatureRemoteDataSource>(
  () => FeatureRemoteDataSourceImpl(),
);

// Repositories
sl.registerLazySingleton<FeatureRepository>(
  () => FeatureRepositoryImpl(sl()),
);

// Use cases
sl.registerLazySingleton(() => GetFeature(sl()));

// Cubits (factory for new instance per page)
sl.registerFactory(() => FeatureCubit(sl()));
```

### Step 6: Add Route

Add to `lib/core/router/app_router.dart`:
```dart
GoRoute(
  path: '/feature',
  name: 'feature',
  builder: (context, state) => const FeaturePage(),
),
```

## Code Generation

After creating Freezed models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For watch mode:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Best Practices

1. **Always start with Domain Layer** - Define entities, repository interfaces, and use cases first
2. **Use Result Pattern** - Use `Result<T>` (Either<Failure, T>) for error handling
3. **Immutable State** - Use Freezed for state classes
4. **Dependency Injection** - Register all dependencies in `injection_container.dart`
5. **Separation of Concerns** - Each layer should only know about inner layers
6. **Testability** - Write unit tests for use cases, integration tests for features
