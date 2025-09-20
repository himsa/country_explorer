# 🌍 Countries Explorer

A modern Flutter application that showcases countries from around the world with a clean, intuitive interface. Built using Clean Architecture principles, BLoC pattern, and modern Flutter best practices.

## ✨ Features

- **🌐 Countries List**: Browse all countries with flags, names, and capitals
- **📱 Detailed View**: Explore comprehensive country information including population, area, languages, and coat of arms
- **🔄 Pull-to-Refresh**: Refresh data with intuitive pull-to-refresh gesture
- **📶 Offline Support**: View cached data when offline with clear indicators
- **🎨 Modern UI**: Beautiful Material 3 design with smooth animations
- **⚡ Hero Animations**: Seamless flag transitions between screens
- **🛡️ Error Handling**: Comprehensive error handling with user-friendly messages

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core utilities and shared components
│   ├── error/              # Error handling and failure types
│   └── usecases/           # Base use case implementation
├── features/
│   └── countries/
│       ├── data/           # Data layer
│       │   ├── datasources/    # Remote and local data sources
│       │   ├── models/         # Data models
│       │   └── repositories/   # Repository implementations
│       ├── domain/         # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository contracts
│       │   └── usecases/       # Business logic use cases
│       └── presentation/   # Presentation layer
│           ├── bloc/           # BLoC state management
│           ├── pages/          # UI screens
│           └── widgets/        # Reusable UI components
└── main.dart              # Application entry point
```

## 🛠️ Tech Stack

- **Flutter**: ^3.9.2
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: get_it
- **Functional Programming**: dartz (Either type)
- **HTTP Client**: http
- **Local Storage**: shared_preferences
- **Testing**: flutter_test + mocktail + bloc_test
- **Code Generation**: None required

## 🚀 Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd countries_explorer

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📋 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (included with Flutter)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd countries_explorer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   
   **For Android:**
   ```bash
   flutter run
   ```
   
   **For iOS (macOS only):**
   ```bash
   flutter run -d ios
   ```
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```
   
   **For Desktop:**
   ```bash
   # Windows
   flutter run -d windows
   
   # macOS
   flutter run -d macos
   
   # Linux
   flutter run -d linux
   ```

### 🏗️ Build Modes

**Debug mode (default):**
```bash
flutter run --debug
```

**Release mode (optimized):**
```bash
flutter run --release
```

**Profile mode (performance testing):**
```bash
flutter run --profile
```

### 🔧 Additional Setup

**Check available devices:**
```bash
flutter devices
```

**Enable web support (if needed):**
```bash
flutter config --enable-web
```

**Enable desktop support (if needed):**
```bash
# Windows
flutter config --enable-windows-desktop

# macOS
flutter config --enable-macos-desktop

# Linux
flutter config --enable-linux-desktop
```

### 🚨 Troubleshooting

**If you encounter issues:**

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Flutter doctor:**
   ```bash
   flutter doctor
   ```

3. **Update dependencies:**
   ```bash
   flutter pub upgrade
   ```

4. **For Android build issues:**
   ```bash
   flutter build apk --debug
   ```

5. **For iOS build issues (macOS only):**
   ```bash
   cd ios && pod install && cd ..
   flutter run -d ios
   ```

## 🧪 Testing

The project includes comprehensive unit tests with >70% coverage:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Test Structure

- **Repository Tests**: Mock remote/local data sources and test business logic
- **BLoC Tests**: Test state management and event handling
- **Use Case Tests**: Verify business logic implementation

## 📱 API Integration

The app integrates with the [REST Countries API](https://restcountries.com):

- **Base URL**: `https://restcountries.com/v3.1/`
- **Endpoints**:
  - `GET /all?fields=name,capital,flags,population,area,languages,coatOfArms,cca2` - Fetch all countries
  - `GET /name/{name}?fields=name,capital,flags,population,area,languages,coatOfArms,cca2` - Fetch country details

**Note**: The API v3.1 requires the `fields` parameter to specify which data fields to return. Flag emojis are generated from country codes (cca2) using Unicode regional indicator symbols.

### Caching Strategy

- **Remote-First**: Always attempt to fetch fresh data from API
- **Local Fallback**: Use cached data when network is unavailable
- **Smart Caching**: Cache data in SharedPreferences for offline access

## 🎨 UI/UX Features

- **Material 3 Design**: Modern, accessible interface
- **Responsive Layout**: Optimized for various screen sizes
- **Loading States**: Smooth loading indicators and skeleton screens
- **Error States**: User-friendly error messages with retry options
- **Pull-to-Refresh**: Intuitive data refresh mechanism
- **Hero Animations**: Smooth transitions between screens
- **Offline Indicators**: Clear indication when using cached data

## 🔧 Development Guidelines

### Code Style

- Follow Dart/Flutter style guide
- Use meaningful variable and function names
- Add comments for complex business logic
- Maintain consistent file organization

### State Management

- Use BLoC for all state management
- Keep business logic in use cases
- Emit appropriate states for loading, success, and error scenarios

### Error Handling

- Use specific error types (NetworkFailure, ParseFailure, etc.)
- Provide user-friendly error messages
- Implement proper fallback mechanisms

## 📦 Dependencies

### Production Dependencies
- `flutter_bloc`: State management
- `dartz`: Functional programming utilities
- `http`: HTTP client for API calls
- `shared_preferences`: Local data storage
- `get_it`: Dependency injection
- `equatable`: Value equality for objects

### Development Dependencies
- `flutter_test`: Testing framework
- `mocktail`: Mocking utilities
- `bloc_test`: BLoC testing utilities

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [REST Countries API](https://restcountries.com) for providing free country data
- Flutter team for the amazing framework
- Clean Architecture principles by Uncle Bob
- BLoC pattern by Felix Angelov

---

**Built with ❤️ using Flutter**
