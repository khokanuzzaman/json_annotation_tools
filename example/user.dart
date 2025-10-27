library;

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation_tools/json_annotation_tools.dart';

part 'user.g.dart';
part 'user.safe_json_parsing.g.dart';

/// Example User model demonstrating @SafeJsonParsing() code generation
/// 
/// This shows how to:
/// - Use @SafeJsonParsing() annotation for enhanced error messages
/// - Generate UserSafeJsonParsing.fromJsonSafe() method automatically
/// - See detailed error messages in console when parsing fails
/// - Handle production JSON parsing with clear diagnostics
@JsonSerializable()
@SafeJsonParsing()
class User {
  final int id;
  final String name;
  final String email;
  final int? age;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    required this.isActive,
  });

  /// Standard json_serializable method
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  /// Standard json_serializable method
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, age: $age, isActive: $isActive)';
  }
}
