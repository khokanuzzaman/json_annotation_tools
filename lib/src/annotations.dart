/// Annotation to enable automatic safe JSON parsing code generation.
/// 
/// Add this annotation to your `@JsonSerializable()` classes to automatically
/// generate enhanced `fromJsonSafe()` methods with detailed error messages.
/// 
/// Example:
/// ```dart
/// @JsonSerializable()
/// @SafeJsonParsing()
/// class User {
///   final int id;
///   final String name;
///   final int? age;
///   
///   User({required this.id, required this.name, this.age});
///   
///   // Standard json_serializable methods
///   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
///   Map<String, dynamic> toJson() => _$UserToJson(this);
///   
///   // Auto-generated safe parsing method (created by build_runner)
///   // factory User.fromJsonSafe(Map<String, dynamic> json) => _$UserFromJsonSafe(json);
/// }
/// ```
/// 
/// The generated `fromJsonSafe()` method will:
/// - Provide crystal-clear error messages for type mismatches
/// - Show exactly which field caused the parsing error
/// - Suggest fixes with copy-paste ready solutions
/// - Include smart field name suggestions for typos
/// - Handle all the complexity automatically
class SafeJsonParsing {
  /// Whether to generate null-safe parsing methods for nullable fields
  /// 
  /// When `true`, nullable fields will use `getNullableSafe()` instead of `getSafe()`
  /// Default: `true`
  final bool nullSafety;
  
  /// Whether to generate field validation (requireKeys) before parsing
  /// 
  /// When `true`, the generated method will validate all required keys exist
  /// before attempting to parse any fields
  /// Default: `false` (for better performance)
  final bool validateRequiredKeys;
  
  /// Custom method name for the generated safe parsing method
  /// 
  /// Default: `'fromJsonSafe'`
  final String methodName;
  
  /// Whether to generate both regular and safe methods
  /// 
  /// When `true`, generates both `fromJson()` and `fromJsonSafe()`
  /// When `false`, only generates the safe version
  /// Default: `true` (maintains compatibility)
  final bool generateBothMethods;
  
  const SafeJsonParsing({
    this.nullSafety = true,
    this.validateRequiredKeys = false,
    this.methodName = 'fromJsonSafe',
    this.generateBothMethods = true,
  });
}

/// Annotation for individual fields to customize safe parsing behavior
/// 
/// Use this on specific fields to override default parsing behavior.
/// 
/// Example:
/// ```dart
/// @JsonSerializable()
/// @SafeJsonParsing()
/// class User {
///   final int id;
///   
///   @SafeJsonField(
///     description: 'User email address',
///     expectedFormat: 'user@example.com',
///     commonValues: ['test@example.com', 'admin@company.com'],
///   )
///   final String email;
///   
///   @SafeJsonField(
///     customParser: '_parseUserStatus',
///   )
///   final UserStatus status;
/// }
/// ```
class SafeJsonField {
  /// Human-readable description of what this field represents
  final String? description;
  
  /// Expected format or example value for this field
  final String? expectedFormat;
  
  /// List of common/valid values for this field (helpful for debugging)
  final List<String>? commonValues;
  
  /// Name of a custom static parser method to use for this field
  /// 
  /// The method should have signature: `static T methodName(dynamic value)`
  final String? customParser;
  
  /// Whether this field should use enhanced error reporting
  /// 
  /// Default: `true`
  final bool enhancedErrors;
  
  const SafeJsonField({
    this.description,
    this.expectedFormat,
    this.commonValues,
    this.customParser,
    this.enhancedErrors = true,
  });
}

/// Configuration annotation for the entire safe JSON parsing system
/// 
/// Add this to your main() or configure globally to customize behavior.
/// 
/// Example:
/// ```dart
/// @SafeJsonConfig(
///   enableGlobalInterception: true,
///   logParsingErrors: true,
///   generateDebugInfo: true,
/// )
/// void main() {
///   runApp(MyApp());
/// }
/// ```
class SafeJsonConfig {
  /// Whether to enable global JSON parsing error interception
  /// 
  /// When `true`, all JSON parsing errors will be enhanced automatically,
  /// even for classes without `@SafeJsonParsing()` annotation
  final bool enableGlobalInterception;
  
  /// Whether to log parsing errors to console (useful for debugging)
  final bool logParsingErrors;
  
  /// Whether to generate additional debug information in error messages
  final bool generateDebugInfo;
  
  /// Custom error message prefix
  final String errorPrefix;
  
  const SafeJsonConfig({
    this.enableGlobalInterception = false,
    this.logParsingErrors = false,
    this.generateDebugInfo = true,
    this.errorPrefix = '🚨 JSON Parsing Error',
  });
}
