/// A powerful utility class for safe JSON parsing with detailed error reporting
/// 
/// This class provides methods to parse JSON values safely while offering
/// crystal-clear error messages that help developers quickly identify and fix
/// JSON parsing issues. Unlike standard parsing which gives cryptic errors,
/// JsonFieldGuard tells you exactly which field failed and why.
class JsonFieldGuard {
  /// Safely parse a JSON value and provide clear error if type mismatch occurs
  /// 
  /// [key] - The JSON key being parsed (for error reporting)
  /// [value] - The actual value from JSON
  /// [parser] - Function to parse/convert the value to the expected type
  /// 
  /// Throws [FormatException] with detailed information if parsing fails
  /// 
  /// Example:
  /// ```dart
  /// final age = JsonFieldGuard.guard('age', jsonValue, (v) => v as int);
  /// ```
  static T guard<T>(String key, dynamic value, T Function(dynamic) parser) {
    try {
      return parser(value);
    } catch (e) {
      throw FormatException(
        _buildDetailedErrorMessage<T>(key, value, e),
      );
    }
  }

  /// Parse a required field with enhanced error context
  /// 
  /// This method provides additional context about the parsing operation
  /// and suggests common fixes for typical parsing errors.
  static T guardWithContext<T>(
    String key, 
    dynamic value, 
    T Function(dynamic) parser, {
    String? fieldDescription,
    String? expectedFormat,
    List<String>? commonValues,
  }) {
    try {
      return parser(value);
    } catch (e) {
      throw FormatException(
        _buildEnhancedErrorMessage<T>(
          key, 
          value, 
          e, 
          fieldDescription: fieldDescription,
          expectedFormat: expectedFormat,
          commonValues: commonValues,
        ),
      );
    }
  }

  /// Validate that a value is not null before parsing
  /// 
  /// Throws [FormatException] if value is null, otherwise delegates to guard()
  static T guardNotNull<T>(String key, dynamic value, T Function(dynamic) parser) {
    if (value == null) {
      throw FormatException(
        "❌ Required field '$key' is null.\n"
        "💡 Tip: Use getNullableSafe() if this field is optional.",
      );
    }
    return guard<T>(key, value, parser);
  }

  /// Parse a list with individual item validation
  /// 
  /// This method parses each item in a list and provides detailed error
  /// information including the index of the problematic item.
  static List<T> guardList<T>(
    String key, 
    dynamic value, 
    T Function(dynamic) itemParser,
  ) {
    if (value == null) {
      throw FormatException("❌ Required list field '$key' is null.");
    }
    
    if (value is! List) {
      throw FormatException(
        "❌ Error parsing key '$key': expected List, but got ${value.runtimeType}. Value: $value",
      );
    }

    final List<T> result = [];
    for (int i = 0; i < value.length; i++) {
      try {
        result.add(itemParser(value[i]));
      } catch (e) {
        throw FormatException(
          "❌ Error parsing list '$key' at index $i: $e\n"
          "📍 Item value: ${value[i]}\n"
          "📋 Full list: $value",
        );
      }
    }
    return result;
  }

  /// Build a detailed error message with helpful debugging information
  static String _buildDetailedErrorMessage<T>(String key, dynamic value, Object exception) {
    final buffer = StringBuffer();
    
    // Main error with friendly explanation
    buffer.writeln("🚨 OOPS! There's a problem with your JSON data:");
    buffer.writeln("");
    
    // ENHANCED: Exact problem diagnosis
    buffer.writeln("🔍 EXACT PROBLEM DIAGNOSIS:");
    buffer.writeln("   ❌ ISSUE TYPE: DATA TYPE MISMATCH");
    buffer.writeln("   📍 Field name: '$key'");
    buffer.writeln("   ✅ Property EXISTS in JSON: YES");
    buffer.writeln("   ✅ Property name MATCHES model: YES");
    buffer.writeln("   ❌ Data type MATCHES model: NO");
    buffer.writeln("");
    
    buffer.writeln("📊 TYPE COMPARISON:");
    buffer.writeln("   🎯 Your model expects: ${_getSimpleTypeName<T>()}");
    buffer.writeln("   😕 JSON response contains: ${_getSimpleTypeName(value.runtimeType)}");
    buffer.writeln("   📄 The actual value: $value");
    buffer.writeln("");
    
    buffer.writeln("✅ GOOD NEWS:");
    buffer.writeln("   • Property name '$key' is spelled correctly");
    buffer.writeln("   • Property exists in the JSON response");
    buffer.writeln("   • This is just a simple data type conversion issue");
    buffer.writeln("");
    
    // Beginner-friendly explanation
    buffer.writeln("");
    buffer.writeln("🤔 What does this mean?");
    buffer.writeln("   Your code expected '$key' to be ${_getTypeExplanation<T>()},");
    buffer.writeln("   but the API/JSON sent ${_getValueExplanation(value)} instead.");
    
    // Step-by-step fixes based on types
    buffer.writeln("");
    if (T == int && value is String) {
      buffer.writeln("🔧 How to fix this (3 easy options):");
      buffer.writeln("   Option 1: Convert the string to a number");
      buffer.writeln("            int.parse('$value')  // This gives you ${int.tryParse(value) ?? 'ERROR'}");
      buffer.writeln("");
      buffer.writeln("   Option 2: Use our safe method");
      buffer.writeln("            json.getSafe('$key', (v) => int.parse(v as String))");
      buffer.writeln("");
      buffer.writeln("   Option 3: Ask your backend team to send a number instead of '$value'");
      buffer.writeln("");
      buffer.writeln("📋 COPY-PASTE READY SOLUTIONS:");
      buffer.writeln("   ✂️  Quick fix in fromJson method:");
      buffer.writeln("       $key: int.parse(json['$key'] as String),");
      buffer.writeln("");
      buffer.writeln("   ✂️  Safe parsing method:");
      buffer.writeln("       $key: json.getSafe('$key', (v) => int.parse(v as String)),");
      buffer.writeln("");
      buffer.writeln("   ✂️  @JsonKey annotation approach:");
      buffer.writeln("       @JsonKey(fromJson: _stringToInt) final int $key;");
      buffer.writeln("       static int _stringToInt(dynamic value) => int.parse(value as String);");
      
    } else if (T == double && value is String) {
      buffer.writeln("🔧 How to fix this (3 easy options):");
      buffer.writeln("   Option 1: Convert the string to a decimal number");
      buffer.writeln("            double.parse('$value')  // This gives you ${double.tryParse(value) ?? 'ERROR'}");
      buffer.writeln("");
      buffer.writeln("   Option 2: Use our safe method");
      buffer.writeln("            json.getSafe('$key', (v) => double.parse(v as String))");
      buffer.writeln("");
      buffer.writeln("   Option 3: Ask your backend team to send a decimal number instead of '$value'");
      buffer.writeln("");
      buffer.writeln("📋 COPY-PASTE READY SOLUTIONS:");
      buffer.writeln("   ✂️  Quick fix in fromJson method:");
      buffer.writeln("       $key: double.parse(json['$key'] as String),");
      buffer.writeln("");
      buffer.writeln("   ✂️  Safe parsing method:");
      buffer.writeln("       $key: json.getSafe('$key', (v) => double.parse(v as String)),");
      buffer.writeln("");
      buffer.writeln("   ✂️  @JsonKey annotation approach:");
      buffer.writeln("       @JsonKey(fromJson: _stringToDouble) final double $key;");
      buffer.writeln("       static double _stringToDouble(dynamic value) => double.parse(value as String);");
      
    } else if (T == bool && value is int) {
      buffer.writeln("🔧 How to fix this (3 easy options):");
      buffer.writeln("   Option 1: Convert the number to true/false");
      buffer.writeln("            $value == 1  // This gives you ${value == 1}");
      buffer.writeln("            (1 = true, 0 = false)");
      buffer.writeln("");
      buffer.writeln("   Option 2: Use our safe method");
      buffer.writeln("            json.getSafeBool('$key')  // This handles 0/1 automatically!");
      buffer.writeln("");
      buffer.writeln("   Option 3: Ask your backend team to send true/false instead of $value");
      buffer.writeln("");
      buffer.writeln("📋 COPY-PASTE READY SOLUTIONS:");
      buffer.writeln("   ✂️  Quick fix in fromJson method:");
      buffer.writeln("       $key: (json['$key'] as int) == 1,");
      buffer.writeln("");
      buffer.writeln("   ✂️  Safe parsing method (recommended):");
      buffer.writeln("       $key: json.getSafeBool('$key'),  // Handles 0/1, 'true'/'false', etc.");
      buffer.writeln("");
      buffer.writeln("   ✂️  @JsonKey annotation approach:");
      buffer.writeln("       @JsonKey(fromJson: _intToBool) final bool $key;");
      buffer.writeln("       static bool _intToBool(dynamic value) => (value as int) == 1;");
      
    } else if (T == bool && value is String) {
      buffer.writeln("🔧 How to fix this (3 easy options):");
      buffer.writeln("   Option 1: Convert the text to true/false");
      buffer.writeln("            '$value'.toLowerCase() == 'true'");
      buffer.writeln("");
      buffer.writeln("   Option 2: Use our safe method");
      buffer.writeln("            json.getSafeBool('$key')  // This handles 'true'/'false' automatically!");
      buffer.writeln("");
      buffer.writeln("   Option 3: Ask your backend team to send true/false instead of '$value'");
      
    } else if (T == DateTime && value is String) {
      buffer.writeln("🔧 How to fix this (2 easy options):");
      buffer.writeln("   Option 1: Convert the date string");
      buffer.writeln("            DateTime.parse('$value')");
      buffer.writeln("");
      buffer.writeln("   Option 2: Use our safe method");
      buffer.writeln("            json.getSafeDateTime('$key')  // This handles different date formats!");
      
    } else {
      buffer.writeln("🔧 How to fix this:");
      buffer.writeln("   1. Check if '$key' should really be ${_getSimpleTypeName<T>()}");
      buffer.writeln("   2. Or write a custom converter:");
      buffer.writeln("      json.getSafe('$key', (v) => /* your conversion code */)");
      buffer.writeln("   3. Talk to your backend team about the data format");
    }
    
    // Beginner tips
    buffer.writeln("");
    buffer.writeln("💡 Beginner tip:");
    buffer.writeln("   JSON data types don't always match Dart types.");
    buffer.writeln("   APIs sometimes send numbers as text, or use 0/1 instead of true/false.");
    buffer.writeln("   This is totally normal - you just need to convert them!");
    
    // Technical details (collapsed for beginners)
    buffer.writeln("");
    buffer.writeln("🔍 Technical details (for advanced users):");
    buffer.writeln("   Original exception: $exception");
    
    return buffer.toString();
  }

  /// Get simple, beginner-friendly type names
  static String _getSimpleTypeName<T>([Type? type]) {
    final targetType = type ?? T;
    switch (targetType) {
      case int:
        return "a whole number (like 42)";
      case double:
        return "a decimal number (like 3.14)";
      case String:
        return "text (like 'hello')";
      case bool:
        return "true or false";
      case DateTime:
        return "a date/time";
      case List:
        return "a list of items";
      default:
        return targetType.toString();
    }
  }

  /// Get explanation of what the type means
  static String _getTypeExplanation<T>() {
    switch (T) {
      case int:
        return "a whole number (no decimal points)";
      case double:
        return "a number that can have decimal points";
      case String:
        return "text wrapped in quotes";
      case bool:
        return "either true or false";
      case DateTime:
        return "a date and time";
      case List:
        return "a list (array) of items";
      default:
        return "a ${T.toString()}";
    }
  }

  /// Get explanation of what the actual value represents
  static String _getValueExplanation(dynamic value) {
    if (value is String) {
      return "text: '$value'";
    } else if (value is int) {
      return "a whole number: $value";
    } else if (value is double) {
      return "a decimal number: $value";
    } else if (value is bool) {
      return "true/false: $value";
    } else if (value is List) {
      return "a list with ${value.length} items";
    } else if (value == null) {
      return "nothing (null)";
    } else {
      return "a ${value.runtimeType}: $value";
    }
  }

  /// Build an enhanced error message with additional context
  static String _buildEnhancedErrorMessage<T>(
    String key, 
    dynamic value, 
    Object exception, {
    String? fieldDescription,
    String? expectedFormat,
    List<String>? commonValues,
  }) {
    final buffer = StringBuffer();
    
    // Main error with context
    buffer.writeln("❌ Error parsing key '$key'${fieldDescription != null ? ' ($fieldDescription)' : ''}:");
    buffer.writeln("   Expected: ${T.toString()}");
    if (expectedFormat != null) {
      buffer.writeln("   Expected format: $expectedFormat");
    }
    buffer.writeln("   Got: ${value.runtimeType}");
    buffer.writeln("   Value: $value");
    
    // Common values suggestion
    if (commonValues != null && commonValues.isNotEmpty) {
      buffer.writeln("\n💡 Common valid values: ${commonValues.join(', ')}");
    }
    
    // Type-specific suggestions
    if (T == int && value is String) {
      buffer.writeln("\n🔧 Suggested fix: int.parse('$value')");
    } else if (T == double && value is String) {
      buffer.writeln("\n🔧 Suggested fix: double.parse('$value')");
    } else if (T == bool && value is int) {
      buffer.writeln("\n🔧 Suggested fix: $value == 1");
    }
    
    // Original exception
    buffer.writeln("\n🔍 Original exception: $exception");
    
    return buffer.toString();
  }
}
