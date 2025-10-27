# Contributing to JSON Annotation Tools 🛠️

Thank you for your interest in contributing to JSON Annotation Tools! This guide will help you get started.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: Latest stable version
- **Dart SDK**: ^3.7.2 or higher
- **Git**: For version control
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA

### Development Setup

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/json_annotation_tools.git
   cd json_annotation_tools
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run tests**
   ```bash
   dart test
   ```

4. **Run example app**
   ```bash
   cd example_app
   flutter run
   ```

## 💡 How to Contribute

### 🐛 Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue  
- **Expected vs actual behavior**
- **Code examples** that demonstrate the issue
- **Environment details** (Flutter version, platform, etc.)

### ✨ Suggesting Features

Feature requests are welcome! Please provide:

- **Clear description** of the feature
- **Use case and motivation** for the feature
- **Possible implementation approach** (if you have ideas)
- **Examples** of how it would be used

### 🔧 Code Contributions

#### Types of Contributions Welcome:

1. **Core Functionality**
   - Enhanced error messages
   - New safe parsing methods
   - Performance improvements
   - Bug fixes

2. **Documentation**
   - README improvements
   - Code examples
   - API documentation
   - Visual guides

3. **Testing**
   - Unit tests
   - Integration tests
   - Edge case testing
   - Performance testing

4. **Examples**
   - Real-world use cases
   - Platform-specific examples
   - Integration guides

## 🔄 Pull Request Process

### Before Submitting

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow existing code style
   - Add tests for new functionality
   - Update documentation

3. **Test thoroughly**
   ```bash
   # Run all tests
   dart test
   
   # Test example app
   cd example_app && flutter test
   
   # Test on multiple platforms if relevant
   flutter run -d chrome
   flutter run -d android
   flutter run -d ios
   ```

4. **Update documentation**
   - Update README if needed
   - Add code comments
   - Update CHANGELOG.md

### Submitting the PR

1. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add amazing new feature
   
   - Describe what you added
   - Mention any breaking changes
   - Reference related issues"
   ```

2. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create Pull Request**
   - Use a clear title and description
   - Reference related issues
   - Include screenshots/GIFs for UI changes
   - Explain the motivation for changes

### PR Review Process

- Maintainers will review your PR
- Address any requested changes
- Once approved, your PR will be merged
- Your contribution will be acknowledged

## 🧪 Testing Guidelines

### Test Requirements

All contributions should include appropriate tests:

```dart
// Example test structure
import 'package:test/test.dart';
import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  group('YourFeature', () {
    test('should handle valid input correctly', () {
      // Arrange
      final json = {'key': 'value'};
      
      // Act
      final result = json.getSafe('key', (v) => v as String);
      
      // Assert
      expect(result, equals('value'));
    });
    
    test('should provide clear error for invalid input', () {
      // Test error scenarios
    });
  });
}
```

### Running Tests

```bash
# Run all tests
dart test

# Run tests with coverage
dart test --coverage=coverage
genhtml coverage/lcov.info -o coverage/html

# Run specific test file
dart test test/specific_test.dart
```

## 📖 Documentation Guidelines

### Code Documentation

- Use clear, descriptive variable names
- Add docstrings for public APIs
- Include usage examples in documentation

```dart
/// Safely extracts a value from JSON with detailed error reporting.
///
/// Example:
/// ```dart
/// final name = json.getSafe('name', (v) => v as String);
/// ```
///
/// Throws [FormatException] with detailed error information if parsing fails.
T getSafe<T>(String key, T Function(dynamic) parser) {
  // Implementation
}
```

### README Updates

When adding features, update:
- Feature list
- Code examples  
- Installation instructions (if needed)
- Platform support (if changed)

## 🎯 Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/effective-dart):

```dart
// Good
class JsonFieldGuard {
  static T guardSafe<T>(String key, dynamic value, T Function(dynamic) parser) {
    try {
      return parser(value);
    } catch (e) {
      throw FormatException(_buildDetailedError(key, value, e));
    }
  }
}

// Use meaningful names
final userAge = json.getSafe('age', (v) => v as int);

// Prefer final over var
final Map<String, dynamic> response = await api.getUser();
```

### File Organization

```
lib/
├── json_annotation_tools.dart     # Main export file
└── src/
    ├── extensions.dart            # Map extensions
    ├── guard.dart                 # Core guard logic
    └── utils/                     # Helper utilities

test/
├── extensions_test.dart           # Extension tests
├── guard_test.dart               # Guard tests
└── integration/                   # Integration tests

example/                           # Console examples
example_app/                       # Flutter demo app
doc/                              # Documentation assets
```

## 🌟 Recognition

Contributors will be:
- Listed in CHANGELOG.md for their contributions
- Mentioned in README acknowledgments
- Tagged in release notes for significant contributions

## 📞 Getting Help

Need help? Here are your options:

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Code Review**: Request feedback on draft PRs

## 🎉 Thank You!

Every contribution makes JSON Annotation Tools better for the Flutter community. Whether you're fixing a typo, adding a feature, or improving documentation - thank you for helping make JSON debugging easier for everyone!

---

**Happy Contributing!** 🚀
