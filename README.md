# App Demo

A Flutter application built with Clean Architecture pattern, featuring a login functionality as a demo.

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

- **Domain Layer**: Business logic, entities, use cases, and repository interfaces
- **Data Layer**: Data sources (remote & local), repository implementations, and models
- **Presentation Layer**: UI components, BLoC for state management, and pages

## Features

- ✅ Login functionality with email and password
- ✅ Form validation
- ✅ Error handling
- ✅ Loading states
- ✅ User data caching
- ✅ Clean Architecture implementation
- ✅ BLoC pattern for state management
- ✅ Dependency Injection with GetIt

## Getting Started

### Prerequisites

- Flutter SDK >=3.4.1
- Dart SDK

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Demo Credentials

For testing with the mock data source (default):
- **Email**: `demo@example.com`
- **Password**: `password123`

## Configuration

### Using Mock Data Source (Default)

The app is configured to use a mock data source by default for demo purposes. This allows you to test the login functionality without a backend API.

To use the mock data source, ensure `useMockDataSource = true` in `lib/core/di/injection_container.dart`.

### Using Real API

To connect to a real API:

1. Update the API base URL in `lib/core/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'https://your-api-url.com';
```

2. Set `useMockDataSource = false` in `lib/core/di/injection_container.dart`

3. Ensure your API endpoint `/auth/login` accepts:
   - Method: POST
   - Body: `{ "email": "string", "password": "string" }`
   - Response: `{ "id": "string", "email": "string", "name": "string", "token": "string" }`

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── di/              # Dependency injection setup
│   ├── error/           # Error handling (Failures)
│   ├── network/         # API client setup
│   ├── routes/          # App routing
│   └── usecase/         # Base use case classes
├── data/
│   ├── datasources/     # Remote and local data sources
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business use cases
└── presentation/
    ├── bloc/            # BLoC state management
    ├── pages/           # Screen widgets
    └── widgets/         # Reusable UI components
```

## Technologies Used

- **Flutter**: UI framework
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **dio**: HTTP client
- **go_router**: Navigation
- **shared_preferences**: Local storage
- **dartz**: Functional programming (Either type)
- **equatable**: Value equality

## Architecture Decisions

See [CHANGELOG.md](CHANGELOG.md) for detailed architecture decisions and rationale.

## License

This project is for demonstration purposes.
