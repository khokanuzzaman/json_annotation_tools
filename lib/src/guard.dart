class JsonFieldGuard {
  /// Safely parse a JSON value and provide clear error if type mismatch occurs
  static T guard<T>(String key, dynamic value, T Function(dynamic) parser) {
    try {
      return parser(value);
    } catch (e) {
      throw FormatException(
        "❌ Error parsing key '$key': expected ${T.toString()}, but got ${value.runtimeType}. Value: $value\nException: $e",
      );
    }
  }
}
