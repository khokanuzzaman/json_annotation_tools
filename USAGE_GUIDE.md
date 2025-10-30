# json_annotation_tools Usage Guide

## 1. Install

```yaml
dependencies:
  json_annotation_tools: ^0.1.6
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.12
  json_serializable: ^6.8.0
```

Run `flutter pub get`.

## 2. Bootstrap (optional but recommended)
```
# From your Flutter project root
flutter pub run json_annotation_tools init
```
Scans `lib/` for `@JsonSerializable` types, adds `@SafeJsonParsing()` and
`part '*.safe_json_parsing.g.dart';` where needed.

## 3. Generate code
```
flutter pub run build_runner build --delete-conflicting-outputs
```
Creates `*.safe_json_parsing.g.dart` files with enhanced `fromJsonSafe` helpers.

## 4. Use the safe parsers

```dart
final summary = DoctorSummarySafeJsonParsing.fromJsonSafe(json); // throws detailed FormatException
```

or wrap once to convert the error into your UI/logging.

## 5. Optional: manual helpers

```dart
import 'package:json_annotation_tools/json_annotation_tools.dart';

final count = json.getSafeInt('morningCount');
final item = json.getNullableSafeObject('item', Item.fromJsonSafe);
```

## 6. View a sample error
```
dart run tool/demo_safe_json_error.dart
```
Prints a full diagnostic when JSON types mismatch.

## 7. Suggested workflow
- Keep existing `fromJson` methods for compatibility.
- Call `fromJsonSafe` in tests or high-risk flows to catch issues early.
- Catch `FormatException` once near the API layer; log or surface it however your app prefers.

## 8. Maintenance
- Re-run `build_runner` after changing models.
- Remove `requiresVisitSummary` (demo field) if not needed.
```
flutter pub run build_runner build --delete-conflicting-outputs
```

## 9. Testing

`test/safe_json_parsing_test.dart` shows how to assert on the enhanced error text.

## 10. Rollout tips
- Document the migration in your project wiki.
- Encourage teammates to use `fromJsonSafe` in new code paths.
- Monitor logs for the new error format and feed back improvements as needed.
