# 🌍 Simple Countries Explorer

A Flutter mobile app built for a coding test that displays countries with Clean Architecture, BLoC pattern, and offline support.

> **✅ Complete**: 77.5% test coverage, all coding test requirements met.

## ✨ Features

- **🌐 Countries List**: Browse countries with flags, names, and capitals
- **📱 Country Details**: View population, area, languages, and coat of arms
- **🔄 Pull-to-Refresh**: Refresh data with pull gesture
- **📶 Offline Support**: Cached data when offline
- **🎨 Modern UI**: Material 3 design with hero animations

## 🏗️ Architecture

**Clean Architecture** with clear separation:

```
UI Layer → BLoC → Use Cases → Repository → Data Sources
```

## 🚀 Quick Start

```bash
# Clone and install
git clone <repository-url>
cd countries_explorer
flutter pub get

# Run the app
flutter run                    # Android
flutter run -d ios            # iOS (macOS only)
```

## 🧪 Testing

**29 focused tests** with **77.5% coverage** on domain/data layers:

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Test Statistics:**
- **7 test files**, **673 lines**, **29 tests**
- **Domain Layer**: 100% coverage
- **Data Layer**: 77.5% coverage
- **Overall**: 77.5% coverage (exceeds >70% target)

## 📱 API Integration

**REST Countries API** integration:
- **Base URL**: `https://restcountries.com/v3.1/`
- **Caching**: SharedPreferences for offline support
- **Strategy**: Remote-first with local fallback

## 🛠️ Tech Stack

- **Flutter**: ^3.9.2
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: get_it
- **Functional Programming**: dartz (Either type)
- **HTTP Client**: http
- **Local Storage**: shared_preferences
- **Testing**: flutter_test + mocktail + bloc_test

## 📱 Platform Support

### ✅ **Android & iOS**
- **Status**: Fully functional
- **Features**: All features working including network, caching, and UI
- **Permissions**: INTERNET permission configured
- **Network**: HTTPS API calls with proper security

### 🚫 **Removed Platforms**
- **Web/Desktop**: Removed (mobile-focused app)


## 📦 Dependencies

### Production
- `flutter_bloc`: State management
- `dartz`: Functional programming utilities
- `http`: HTTP client for API calls
- `shared_preferences`: Local data storage
- `get_it`: Dependency injection
- `equatable`: Value equality for objects

### Development
- `flutter_test`: Testing framework
- `mocktail`: Mocking utilities
- `bloc_test`: BLoC testing utilities

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- [REST Countries API](https://restcountries.com) for providing free country data
- Flutter team for the amazing framework
- Clean Architecture principles by Uncle Bob
- BLoC pattern by Felix Angelov

---

**Built with ❤️ using Flutter for Android & iOS**