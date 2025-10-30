import 'guard.dart';

/// Powerful extension methods for `Map<String, dynamic>` that make JSON parsing
/// safer, more robust, and provide crystal-clear error messages when things go wrong.
///
/// These extensions transform cryptic JSON parsing errors into helpful,
/// actionable error messages that tell you exactly what went wrong and how to fix it.
extension SafeJsonExtension on Map<String, dynamic> {
  /// Get a parsed and validated value with detailed error tracking
  ///
  /// This method checks for the key's existence and safely parses the value,
  /// providing detailed error information if anything goes wrong.
  ///
  /// Example:
  /// ```dart
  /// final age = json.getSafe('age', (v) => v as int);
  /// final name = json.getSafe('name', (v) => v as String);
  /// ```
  T getSafe<T>(String key, T Function(dynamic) parser) {
    if (!containsKey(key)) {
      throw FormatException(_buildMissingKeyError(key, keys.toList()));
    }
    return JsonFieldGuard.guard(key, this[key], parser);
  }

  /// Get a nullable safe value (returns null if key is missing or value is null)
  ///
  /// Perfect for optional fields that might not be present in the JSON.
  /// Returns null if the key is missing or if the value is null.
  ///
  /// Example:
  /// ```dart
  /// final email = json.getNullableSafe('email', (v) => v as String);
  /// final phoneNumber = json.getNullableSafe('phone', (v) => v as String);
  /// ```
  T? getNullableSafe<T>(String key, T Function(dynamic) parser) {
    final value = this[key];
    if (value == null) return null;
    return JsonFieldGuard.guard(key, value, parser);
  }

  /// Get a safe value with enhanced context and suggestions
  ///
  /// Provides additional context about the field being parsed and can suggest
  /// common valid values or expected formats.
  ///
  /// Example:
  /// ```dart
  /// final status = json.getSafeWithContext(
  ///   'status',
  ///   (v) => Status.values.byName(v as String),
  ///   fieldDescription: 'User account status',
  ///   commonValues: ['active', 'inactive', 'pending'],
  /// );
  /// ```
  T getSafeWithContext<T>(
    String key,
    T Function(dynamic) parser, {
    String? fieldDescription,
    String? expectedFormat,
    List<String>? commonValues,
  }) {
    if (!containsKey(key)) {
      throw FormatException(_buildMissingKeyError(key, keys.toList()));
    }
    return JsonFieldGuard.guardWithContext(
      key,
      this[key],
      parser,
      fieldDescription: fieldDescription,
      expectedFormat: expectedFormat,
      commonValues: commonValues,
    );
  }

  /// Get a safe list with individual item validation
  ///
  /// Parses a JSON array and validates each item individually, providing
  /// detailed error information including the index of any problematic item.
  ///
  /// Example:
  /// ```dart
  /// final tags = json.getSafeList('tags', (v) => v as String);
  /// final userIds = json.getSafeList('user_ids', (v) => v as int);
  /// ```
  List<T> getSafeList<T>(String key, T Function(dynamic) itemParser) {
    if (!containsKey(key)) {
      throw FormatException(_buildMissingKeyError(key, keys.toList()));
    }
    return JsonFieldGuard.guardList(key, this[key], itemParser);
  }

  /// Get a nullable safe list (returns null if key is missing)
  ///
  /// Like getSafeList but returns null if the key is missing instead of throwing.
  ///
  /// Example:
  /// ```dart
  /// final optionalTags = json.getNullableSafeList('tags', (v) => v as String);
  /// ```
  List<T>? getNullableSafeList<T>(String key, T Function(dynamic) itemParser) {
    if (!containsKey(key)) return null;
    final value = this[key];
    if (value == null) return null;
    return JsonFieldGuard.guardList(key, value, itemParser);
  }

  // Common type-specific convenience methods

  /// Get a safe string value
  ///
  /// Convenience method for the most common case of parsing strings.
  ///
  /// Example:
  /// ```dart
  /// final name = json.getSafeString('name');
  /// final email = json.getNullableSafeString('email');
  /// ```
  String getSafeString(String key) => getSafe(key, (v) => v as String);
  String? getNullableSafeString(String key) =>
      getNullableSafe(key, (v) => v as String);

  /// Get a safe integer value
  ///
  /// Handles both int and num types from JSON, converting to int safely.
  ///
  /// Example:
  /// ```dart
  /// final age = json.getSafeInt('age');
  /// final optionalCount = json.getNullableSafeInt('count');
  /// ```
  int getSafeInt(String key) => getSafe(key, (v) => (v as num).toInt());
  int? getNullableSafeInt(String key) =>
      getNullableSafe(key, (v) => (v as num).toInt());

  /// Get a safe double value
  ///
  /// Handles both double and num types from JSON, converting to double safely.
  ///
  /// Example:
  /// ```dart
  /// final price = json.getSafeDouble('price');
  /// final optionalDiscount = json.getNullableSafeDouble('discount');
  /// ```
  double getSafeDouble(String key) =>
      getSafe(key, (v) => (v as num).toDouble());
  double? getNullableSafeDouble(String key) =>
      getNullableSafe(key, (v) => (v as num).toDouble());

  /// Get a safe boolean value
  ///
  /// Handles various boolean representations commonly found in APIs.
  ///
  /// Example:
  /// ```dart
  /// final isActive = json.getSafeBool('is_active');
  /// final optionalFlag = json.getNullableSafeBool('optional_flag');
  /// ```
  bool getSafeBool(String key) => getSafe(key, _parseBool);
  bool? getNullableSafeBool(String key) => getNullableSafe(key, _parseBool);

  /// Get a safe DateTime value from various formats
  ///
  /// Supports ISO 8601 strings, Unix timestamps (seconds), and milliseconds.
  ///
  /// Example:
  /// ```dart
  /// final createdAt = json.getSafeDateTime('created_at');
  /// final updatedAt = json.getNullableSafeDateTime('updated_at');
  /// ```
  DateTime getSafeDateTime(String key) => getSafe(key, _parseDateTime);
  DateTime? getNullableSafeDateTime(String key) =>
      getNullableSafe(key, _parseDateTime);

  /// Get a safe nested object
  ///
  /// Parses nested JSON objects using a provided factory method.
  ///
  /// Example:
  /// ```dart
  /// final address = json.getSafeObject('address', Address.fromJsonSafe);
  /// final profile = json.getNullableSafeObject('profile', UserProfile.fromJsonSafe);
  /// ```
  T getSafeObject<T>(String key, T Function(Map<String, dynamic>) factory) {
    return getSafe(key, (v) => factory(v as Map<String, dynamic>));
  }

  T? getNullableSafeObject<T>(
    String key,
    T Function(Map<String, dynamic>) factory,
  ) {
    return getNullableSafe(key, (v) => factory(v as Map<String, dynamic>));
  }

  /// Get a safe list of objects
  ///
  /// Parses a JSON array of objects using a provided factory method.
  ///
  /// Example:
  /// ```dart
  /// final items = json.getSafeObjectList('items', OrderItem.fromJsonSafe);
  /// final tags = json.getNullableSafeObjectList('tags', Tag.fromJsonSafe);
  /// ```
  List<T> getSafeObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) factory,
  ) {
    return getSafeList(key, (v) => factory(v as Map<String, dynamic>));
  }

  List<T>? getNullableSafeObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) factory,
  ) {
    return getNullableSafeList(key, (v) => factory(v as Map<String, dynamic>));
  }

  /// Check if the JSON contains all required keys
  ///
  /// Validates that all required keys are present before attempting to parse.
  /// Throws a detailed error if any required keys are missing.
  ///
  /// Example:
  /// ```dart
  /// json.requireKeys(['id', 'name', 'email']);
  /// ```
  void requireKeys(List<String> requiredKeys) {
    final missingKeys = requiredKeys.where((key) => !containsKey(key)).toList();
    if (missingKeys.isNotEmpty) {
      throw FormatException(_buildMissingKeysError(missingKeys, keys.toList()));
    }
  }

  /// Validate the JSON structure and provide a summary
  ///
  /// Returns a summary of the JSON structure, useful for debugging
  /// when you're not sure what fields are available.
  ///
  /// Example:
  /// ```dart
  /// print(json.getStructureSummary());
  /// // Output: Keys: [id, name, email, settings], Types: {id: int, name: String, ...}
  /// ```
  String getStructureSummary() {
    final keyTypes = <String, String>{};
    for (final entry in entries) {
      keyTypes[entry.key] = entry.value.runtimeType.toString();
    }
    return 'Keys: ${keys.toList()}, Types: $keyTypes';
  }

  /// Analyze property mapping between JSON response and model expectations
  ///
  /// This method provides detailed analysis of how well the JSON response
  /// matches what your model expects, including missing and extra properties.
  ///
  /// Example:
  /// ```dart
  /// final analysis = json.analyzePropertyMapping(['id', 'name', 'email']);
  /// print(analysis);
  /// ```
  String analyzePropertyMapping(List<String> expectedProperties) {
    final buffer = StringBuffer();
    final jsonKeys = keys.toList();
    final missing =
        expectedProperties.where((prop) => !containsKey(prop)).toList();
    final extra =
        jsonKeys.where((key) => !expectedProperties.contains(key)).toList();
    final matching =
        expectedProperties.where((prop) => containsKey(prop)).toList();

    buffer.writeln("🔍 PROPERTY MAPPING ANALYSIS:");
    buffer.writeln("");

    // Matching properties
    if (matching.isNotEmpty) {
      buffer.writeln("✅ MATCHING PROPERTIES (${matching.length}):");
      for (final prop in matching) {
        final value = this[prop];
        buffer.writeln("   ✓ '$prop': ${value.runtimeType} = $value");
      }
      buffer.writeln("");
    }

    // Missing properties
    if (missing.isNotEmpty) {
      buffer.writeln("❌ MISSING PROPERTIES (${missing.length}):");
      for (final prop in missing) {
        buffer.writeln(
          "   ✗ '$prop': Expected by model but NOT in JSON response",
        );

        // Suggest possible matches
        final suggestions = _findSimilarKeys(prop, jsonKeys);
        if (suggestions.isNotEmpty) {
          buffer.writeln("     💡 Similar: ${suggestions.join(', ')}");
        }
      }
      buffer.writeln("");
    }

    // Extra properties
    if (extra.isNotEmpty) {
      buffer.writeln("➕ EXTRA PROPERTIES (${extra.length}):");
      buffer.writeln("   (These are in JSON but not expected by your model)");
      for (final prop in extra) {
        final value = this[prop];
        buffer.writeln("   + '$prop': ${value.runtimeType} = $value");
      }
      buffer.writeln("");
      buffer.writeln(
        "   💡 These extra properties won't cause errors but might indicate:",
      );
      buffer.writeln("      • API returned more data than expected");
      buffer.writeln("      • Your model is missing some fields");
      buffer.writeln("      • API version mismatch");
      buffer.writeln("");
    }

    // Summary
    buffer.writeln("📊 SUMMARY:");
    buffer.writeln(
      "   ✅ Matching: ${matching.length}/${expectedProperties.length} properties",
    );
    buffer.writeln("   ❌ Missing: ${missing.length} properties");
    buffer.writeln("   ➕ Extra: ${extra.length} properties");

    if (missing.isEmpty && extra.isEmpty) {
      buffer.writeln(
        "   🎉 Perfect match! JSON response matches your model exactly.",
      );
    } else if (missing.isEmpty) {
      buffer.writeln(
        "   ⚠️  JSON has extra data but no missing required fields.",
      );
    } else {
      buffer.writeln(
        "   🚨 Action needed: Missing properties may cause parsing errors.",
      );
    }

    return buffer.toString();
  }

  /// Generate a complete corrected Dart model from this JSON response
  ///
  /// This method analyzes the JSON structure and generates a complete
  /// Dart model class with all necessary annotations and safe parsing.
  ///
  /// Example:
  /// ```dart
  /// final model = json.generateModel('User', ['id', 'name', 'email']);
  /// print(model); // Complete model class code
  /// ```
  String generateModel(String className, {List<String>? expectedFields}) {
    final buffer = StringBuffer();

    buffer.writeln("// 🚀 AUTO-GENERATED MODEL FROM JSON ANNOTATION TOOLS");
    buffer.writeln(
      "// Copy-paste this into your project and customize as needed",
    );
    buffer.writeln("");
    buffer.writeln("import 'package:json_annotation/json_annotation.dart';");
    buffer.writeln(
      "import 'package:json_annotation_tools/json_annotation_tools.dart';",
    );
    buffer.writeln("");
    buffer.writeln("part '${className.toLowerCase()}.g.dart';");
    buffer.writeln("");
    buffer.writeln("@JsonSerializable()");
    buffer.writeln("class $className {");

    // Generate fields
    final jsonKeys = keys.toList();
    for (final key in jsonKeys) {
      final value = this[key];
      final dartType = _getDartType(value);
      final fieldName = _toCamelCase(key);

      if (fieldName != key) {
        buffer.writeln("  @JsonKey(name: '$key')");
      }
      buffer.writeln("  final $dartType $fieldName;");
      buffer.writeln("");
    }

    // Generate constructor
    buffer.writeln("  $className({");
    for (final key in jsonKeys) {
      final fieldName = _toCamelCase(key);
      final value = this[key];
      final isRequired = value != null;

      if (isRequired) {
        buffer.writeln("    required this.$fieldName,");
      } else {
        buffer.writeln("    this.$fieldName,");
      }
    }
    buffer.writeln("  });");
    buffer.writeln("");

    // Generate standard fromJson (generated)
    buffer.writeln("  /// Standard fromJson (generated by json_serializable)");
    buffer.writeln(
      "  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);",
    );
    buffer.writeln("");

    // Generate safe fromJson
    buffer.writeln("  /// Safe fromJson with detailed error messages");
    buffer.writeln(
      "  factory $className.fromJsonSafe(Map<String, dynamic> json) {",
    );
    buffer.writeln("    return $className(");
    for (final key in jsonKeys) {
      final fieldName = _toCamelCase(key);
      final value = this[key];
      final safeMethod = _getSafeMethod(value);

      if (safeMethod.isNotEmpty) {
        buffer.writeln("      $fieldName: json.$safeMethod('$key'),");
      } else {
        buffer.writeln(
          "      $fieldName: json.getSafe('$key', (v) => v as ${_getDartType(value)}),",
        );
      }
    }
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("");

    // Generate toJson
    buffer.writeln("  /// Convert to JSON");
    buffer.writeln(
      "  Map<String, dynamic> toJson() => _\$${className}ToJson(this);",
    );
    buffer.writeln("");

    // Generate toString for debugging
    buffer.writeln("  @override");
    buffer.writeln("  String toString() {");
    buffer.write(
      "    return '$className(${jsonKeys.map((key) => '${_toCamelCase(key)}: \$${_toCamelCase(key)}').join(', ')})';",
    );
    buffer.writeln("");
    buffer.writeln("  }");

    buffer.writeln("}");

    // Add usage instructions
    buffer.writeln("");
    buffer.writeln("// 📋 USAGE INSTRUCTIONS:");
    buffer.writeln("// 1. Run: dart run build_runner build");
    buffer.writeln("// 2. Use $className.fromJsonSafe(json) for safe parsing");
    buffer.writeln("// 3. Use $className.fromJson(json) for standard parsing");
    buffer.writeln("");
    buffer.writeln("// 🎯 EXAMPLE USAGE:");
    buffer.writeln("// try {");
    buffer.writeln(
      "//   final user = $className.fromJsonSafe(apiResponse.data);",
    );
    buffer.writeln("//   print('Success: \$user');");
    buffer.writeln("// } catch (e) {");
    buffer.writeln(
      "//   print('JSON Error: \$e');  // Get detailed error message",
    );
    buffer.writeln("// }");

    return buffer.toString();
  }

  /// Get appropriate Dart type for a JSON value
  String _getDartType(dynamic value) {
    if (value == null) return 'String?';
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      final firstElement = value.first;
      final elementType = _getDartType(firstElement);
      return 'List<$elementType>';
    }
    if (value is Map) return 'Map<String, dynamic>';
    return 'dynamic';
  }

  /// Get appropriate safe method for a JSON value type
  String _getSafeMethod(dynamic value) {
    if (value == null) return 'getNullableSafeString';
    if (value is String) return 'getSafeString';
    if (value is int) return 'getSafeInt';
    if (value is double) return 'getSafeDouble';
    if (value is bool) return 'getSafeBool';
    if (value is List) return ''; // Use custom parsing
    if (value is Map) return ''; // Use custom parsing
    return '';
  }

  // Private helper methods

  /// Parse boolean from various representations
  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    throw FormatException(
      "🚨 OOPS! Can't convert '$value' to true/false:\n"
      "\n"
      "🤔 What happened?\n"
      "   You tried to convert '$value' (${value.runtimeType}) to a boolean (true/false),\n"
      "   but I don't know how to do that conversion.\n"
      "\n"
      "🔧 How to fix this:\n"
      "   ✅ Valid true values: true, 1, '1', 'true', 'TRUE', 'yes', 'YES'\n"
      "   ✅ Valid false values: false, 0, '0', 'false', 'FALSE', 'no', 'NO'\n"
      "\n"
      "💡 Beginner tip:\n"
      "   Different APIs use different ways to represent true/false.\n"
      "   Some use 1/0, others use 'true'/'false', and some use 'yes'/'no'.\n"
      "   This is totally normal in API development!",
    );
  }

  /// Parse DateTime from various formats
  DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is int) {
      // Handle Unix timestamps (seconds or milliseconds)
      if (value > 1000000000000) {
        // Milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else {
        // Seconds
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      }
    }
    throw FormatException(
      "🚨 OOPS! Can't convert '$value' to a date/time:\n"
      "\n"
      "🤔 What happened?\n"
      "   You tried to convert '$value' (${value.runtimeType}) to a DateTime,\n"
      "   but I don't recognize this date format.\n"
      "\n"
      "🔧 How to fix this:\n"
      "   ✅ Valid date formats I understand:\n"
      "      • '2023-10-27T10:30:00Z' (ISO 8601 string)\n"
      "      • '2023-10-27 10:30:00' (standard format)\n"
      "      • 1698408600 (Unix timestamp in seconds)\n"
      "      • 1698408600000 (Unix timestamp in milliseconds)\n"
      "\n"
      "💡 Beginner tip:\n"
      "   Different APIs send dates in different formats.\n"
      "   Ask your backend team what format they're using!",
    );
  }

  /// Build a helpful error message for missing keys
  String _buildMissingKeyError(String missingKey, List<String> availableKeys) {
    final buffer = StringBuffer();
    buffer.writeln("🚨 OOPS! Can't find the field you're looking for:");
    buffer.writeln("");

    // ENHANCED: Exact problem diagnosis
    buffer.writeln("🔍 EXACT PROBLEM DIAGNOSIS:");
    buffer.writeln("   ❌ ISSUE TYPE: PROPERTY NAME MISMATCH");
    buffer.writeln("   📍 Field your model expects: '$missingKey'");
    buffer.writeln("   ❌ Property EXISTS in JSON: NO");
    buffer.writeln("   ❌ Property name MATCHES response: NO");
    buffer.writeln("");

    buffer.writeln("📊 PROPERTY COMPARISON:");
    buffer.writeln("   🎯 Your model expects: '$missingKey'");
    buffer.writeln("   📄 JSON response contains: ${availableKeys.join(', ')}");
    buffer.writeln("");

    // Analyze the mismatch type
    final analysisResult = _analyzePropertyMismatch(missingKey, availableKeys);
    buffer.writeln("🔬 MISMATCH ANALYSIS:");
    buffer.writeln(analysisResult);
    buffer.writeln("");

    // Suggest similar keys
    final similarKeys = _findSimilarKeys(missingKey, availableKeys);
    if (similarKeys.isNotEmpty) {
      buffer.writeln("");
      buffer.writeln("🤔 Did you maybe mean one of these?");
      for (final suggestion in similarKeys) {
        buffer.writeln("   → '$suggestion' (looks similar to '$missingKey')");
      }
    }

    buffer.writeln("");
    buffer.writeln("🔧 How to fix this:");
    buffer.writeln(
      "   1. Check your spelling - is '$missingKey' spelled correctly?",
    );
    buffer.writeln("   2. Look at the available fields above");
    buffer.writeln("   3. Use the exact same spelling and capitalization");
    buffer.writeln(
      "   4. Or use getNullableSafe() if this field might not always exist",
    );

    // Add copy-paste solutions based on mismatch analysis
    final copyPasteAnalysis = _analyzePropertyMismatch(
      missingKey,
      availableKeys,
    );
    if (copyPasteAnalysis.contains("Case sensitivity issue")) {
      final exactMatch = availableKeys.firstWhere(
        (key) => key.toLowerCase() == missingKey.toLowerCase(),
      );
      buffer.writeln("");
      buffer.writeln("📋 COPY-PASTE READY SOLUTIONS:");
      buffer.writeln("   ✂️  Fix the field name in your model:");
      buffer.writeln(
        "       final String $exactMatch;  // Change from '$missingKey'",
      );
      buffer.writeln("");
      buffer.writeln("   ✂️  Or use @JsonKey annotation:");
      buffer.writeln(
        "       @JsonKey(name: '$exactMatch') final String $missingKey;",
      );
    } else if (copyPasteAnalysis.contains("Naming convention mismatch")) {
      final camelCase = _toCamelCase(missingKey);
      final snakeCase = _toSnakeCase(missingKey);
      final correctField =
          availableKeys.contains(camelCase)
              ? camelCase
              : availableKeys.contains(snakeCase)
              ? snakeCase
              : null;

      if (correctField != null) {
        buffer.writeln("");
        buffer.writeln("📋 COPY-PASTE READY SOLUTIONS:");
        buffer.writeln("   ✂️  Use @JsonKey annotation:");
        buffer.writeln(
          "       @JsonKey(name: '$correctField') final String $missingKey;",
        );
        buffer.writeln("");
        buffer.writeln("   ✂️  Or change your model field name:");
        buffer.writeln(
          "       final String $correctField;  // Change from '$missingKey'",
        );
      }
    } else {
      // Generic solutions for missing fields
      buffer.writeln("");
      buffer.writeln("📋 COPY-PASTE READY SOLUTIONS:");
      buffer.writeln("   ✂️  Make this field optional:");
      buffer.writeln(
        "       $missingKey: json.getNullableSafeString('$missingKey'),",
      );
      buffer.writeln("");
      if (similarKeys.isNotEmpty) {
        buffer.writeln("   ✂️  Use the most similar field instead:");
        buffer.writeln(
          "       @JsonKey(name: '${similarKeys.first}') final String $missingKey;",
        );
        buffer.writeln("");
      }
      buffer.writeln("   ✂️  Add default value:");
      buffer.writeln(
        "       $missingKey: json.getNullableSafeString('$missingKey') ?? 'default_value',",
      );
    }

    buffer.writeln("");
    buffer.writeln("💡 Beginner tip:");
    buffer.writeln("   JSON field names are case-sensitive!");
    buffer.writeln("   'UserName' is different from 'username' or 'user_name'");

    return buffer.toString();
  }

  /// Build error message for multiple missing keys
  String _buildMissingKeysError(
    List<String> missingKeys,
    List<String> availableKeys,
  ) {
    final buffer = StringBuffer();
    buffer.writeln("🚨 OOPS! Multiple required fields are missing:");
    buffer.writeln("");
    buffer.writeln("❌ Missing fields: ${missingKeys.join(', ')}");
    buffer.writeln("✅ Available fields: ${availableKeys.join(', ')}");

    buffer.writeln("");
    buffer.writeln("🔧 How to fix this:");
    buffer.writeln("   1. Check the spelling of each missing field");
    buffer.writeln("   2. Make sure you're using the exact field names");
    buffer.writeln("   3. Ask your backend team if these fields should exist");
    buffer.writeln("   4. Or use getNullableSafe() for optional fields");

    return buffer.toString();
  }

  /// Analyze the type of property mismatch and provide specific diagnosis
  String _analyzePropertyMismatch(
    String expectedKey,
    List<String> availableKeys,
  ) {
    final expectedLower = expectedKey.toLowerCase();
    final buffer = StringBuffer();

    // Check for exact case mismatch
    final exactCaseMatch =
        availableKeys
            .where((key) => key.toLowerCase() == expectedLower)
            .toList();
    if (exactCaseMatch.isNotEmpty) {
      buffer.writeln("   🎯 LIKELY CAUSE: Case sensitivity issue");
      buffer.writeln("   📝 Expected: '$expectedKey'");
      buffer.writeln("   📝 Available: '${exactCaseMatch.first}'");
      buffer.writeln("   💡 Solution: Fix the capitalization");
      return buffer.toString();
    }

    // Check for underscore vs camelCase
    final camelCaseVariant = _toCamelCase(expectedKey);
    final snakeCaseVariant = _toSnakeCase(expectedKey);

    for (final available in availableKeys) {
      if (available == camelCaseVariant && available != expectedKey) {
        buffer.writeln("   🎯 LIKELY CAUSE: Naming convention mismatch");
        buffer.writeln("   📝 Your model uses: '$expectedKey' (snake_case)");
        buffer.writeln("   📝 API response uses: '$available' (camelCase)");
        buffer.writeln(
          "   💡 Solution: Update model or use @JsonKey annotation",
        );
        return buffer.toString();
      }
      if (available == snakeCaseVariant && available != expectedKey) {
        buffer.writeln("   🎯 LIKELY CAUSE: Naming convention mismatch");
        buffer.writeln("   📝 Your model uses: '$expectedKey' (camelCase)");
        buffer.writeln("   📝 API response uses: '$available' (snake_case)");
        buffer.writeln(
          "   💡 Solution: Update model or use @JsonKey annotation",
        );
        return buffer.toString();
      }
    }

    // Check for partial matches
    final partialMatches =
        availableKeys
            .where(
              (key) =>
                  key.toLowerCase().contains(expectedLower) ||
                  expectedLower.contains(key.toLowerCase()),
            )
            .toList();

    if (partialMatches.isNotEmpty) {
      buffer.writeln("   🎯 LIKELY CAUSE: Property name was changed/shortened");
      buffer.writeln("   📝 You're looking for: '$expectedKey'");
      buffer.writeln("   📝 Possible matches: ${partialMatches.join(', ')}");
      buffer.writeln(
        "   💡 Solution: Check API documentation for exact field names",
      );
      return buffer.toString();
    }

    // No clear matches
    buffer.writeln("   🎯 LIKELY CAUSE: Property missing or renamed in API");
    buffer.writeln("   📝 Property '$expectedKey' not found in response");
    buffer.writeln("   📝 This might be a new field or API version change");
    buffer.writeln(
      "   💡 Solution: Check with backend team or API documentation",
    );

    return buffer.toString();
  }

  /// Convert string to camelCase
  String _toCamelCase(String str) {
    if (!str.contains('_')) return str;
    final parts = str.split('_');
    if (parts.isEmpty) return str;

    final result = StringBuffer(parts.first);
    for (int i = 1; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        result.write(parts[i][0].toUpperCase() + parts[i].substring(1));
      }
    }
    return result.toString();
  }

  /// Convert string to snake_case
  String _toSnakeCase(String str) {
    return str
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }

  /// Find keys that are similar to the missing key (simple fuzzy matching)
  List<String> _findSimilarKeys(String target, List<String> candidates) {
    final similar = <String>[];
    final targetLower = target.toLowerCase();

    for (final candidate in candidates) {
      final candidateLower = candidate.toLowerCase();
      // Simple similarity checks
      if (candidateLower.contains(targetLower) ||
          targetLower.contains(candidateLower) ||
          _levenshteinDistance(targetLower, candidateLower) <= 2) {
        similar.add(candidate);
      }
    }

    return similar.take(3).toList(); // Limit to 3 suggestions
  }

  /// Calculate Levenshtein distance for fuzzy matching
  int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }
}
