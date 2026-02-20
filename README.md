# Skill Forge

A DSA (Data Structures and Algorithms) learning and tracking platform built with Flutter for web.

## Architecture

This project follows **Clean Architecture** principles with the following structure:

```
lib/
├── core/                    # Core functionality shared across features
│   ├── constants/          # App-wide constants
│   ├── errors/             # Error handling (failures, exceptions)
│   ├── network/            # Network configuration
│   ├── router/             # Navigation configuration (Go Router)
│   ├── theme/              # App theming
│   ├── utils/              # Utility classes and extensions
│   └── di/                 # Dependency injection setup
│
├── features/               # Feature modules
│   └── [feature_name]/
│       ├── data/           # Data layer
│       │   ├── datasources/    # Remote/local data sources
│       │   ├── models/         # Data models (Freezed)
│       │   └── repositories/  # Repository implementations
│       │
│       ├── domain/         # Domain layer (business logic)
│       │   ├── entities/       # Domain entities
│       │   ├── repositories/  # Repository interfaces
│       │   └── usecases/      # Use cases
│       │
│       └── presentation/   # Presentation layer
│           ├── cubit/          # State management (Cubit)
│           ├── pages/          # Screen widgets
│           └── widgets/        # Feature-specific widgets
│
└── shared/                 # Shared components
    ├── widgets/           # Reusable widgets
    └── utils/             # Shared utilities
```

## Tech Stack

- **Flutter** - UI Framework
- **Cubit (flutter_bloc)** - State Management
- **Go Router** - Navigation
- **Freezed** - Code generation for immutable classes
- **GetIt** - Dependency Injection
- **Dartz** - Functional programming utilities (Either, Result pattern)

## Getting Started

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK (3.10.1 or higher)

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code (Freezed, JSON serialization):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run -d chrome
```

## Project Structure Guidelines

### Adding a New Feature

1. Create feature folder under `lib/features/[feature_name]/`
2. Set up the three layers:
   - **Domain**: Entities, repository interfaces, use cases
   - **Data**: Models, data sources, repository implementations
   - **Presentation**: Cubits, pages, widgets
3. Register routes in `lib/core/router/app_router.dart`
4. Register dependencies in `lib/core/di/injection_container.dart`

### Code Generation

After creating Freezed classes or JSON serializable models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For watch mode (auto-regenerate on file changes):
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Best Practices

1. **Separation of Concerns**: Each layer should only depend on inner layers
2. **Dependency Inversion**: Depend on abstractions (interfaces), not implementations
3. **Single Responsibility**: Each class/function should have one clear purpose
4. **Immutable State**: Use Freezed for state classes
5. **Error Handling**: Use Result pattern (Either) for error handling
6. **Testing**: Write unit tests for use cases, integration tests for features

## License

This project is private and not for distribution.
