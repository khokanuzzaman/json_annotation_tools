import 'guard.dart';

extension SafeJsonExtension on Map<String, dynamic> {
  /// Get a parsed and validated value with error tracking
  T getSafe<T>(String key, T Function(dynamic) parser) {
    if (!containsKey(key)) {
      throw FormatException("❌ Missing required key: '$key'");
    }
    return JsonFieldGuard.guard(key, this[key], parser);
  }

  /// Get a nullable safe value (returns null if key is missing or value is null)
  T? getNullableSafe<T>(String key, T Function(dynamic) parser) {
    final value = this[key];
    if (value == null) return null;
    return JsonFieldGuard.guard(key, value, parser);
  }
}
