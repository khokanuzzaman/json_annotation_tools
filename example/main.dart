/// Example demonstrating the power of JSON Annotation Tools
/// 
/// This example shows how the package transforms cryptic JSON parsing errors
/// into clear, actionable error messages with helpful suggestions.
library;

import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  print('🚀 JSON Annotation Tools - Example Demonstration\n');
  
  // Example 1: Standard vs Safe JSON Parsing
  print('📍 Example 1: Clear Error Messages');
  print('=' * 50);
  standardJsonParsingExample();
  print('\n${'=' * 70}\n');
  
  // Example 2: Missing Keys with Suggestions
  print('📍 Example 2: Missing Keys with Smart Suggestions');
  print('=' * 50);
  missingKeyExample();
  print('\n${'=' * 70}\n');
  
  // Example 3: Complex Real-World API Response
  print('📍 Example 3: Real-World API Response Debugging');
  print('=' * 50);
  realWorldApiExample();
  print('\n${'=' * 70}\n');
  
  // Example 4: Safe Convenience Methods
  print('📍 Example 4: Type-Safe Convenience Methods');
  print('=' * 50);
  convenienceMethodsExample();
  print('\n${'=' * 70}\n');
  
  // Example 5: Advanced Features
  print('📍 Example 5: Advanced Features');
  print('=' * 50);
  advancedFeaturesExample();
  print('\n${'=' * 70}\n');
}

/// Shows the difference between standard JSON parsing errors and safe parsing
void standardJsonParsingExample() {
  final problematicJson = {
    'user_id': 123,
    'name': 'John Doe',
    'age': '25', // Oops! String instead of int
  };

  print('❌ Standard JSON parsing (cryptic error):');
  try {
    // This is what you'd typically do
    final age = problematicJson['age'] as int; // Throws unclear error
    print('Success: $age');
  } catch (e) {
    print('   Error: $e');
    print('   ❓ Which field? What value? No idea!');
  }
  
  print('\n✅ Safe JSON parsing (crystal clear):');
  try {
    final age = problematicJson.getSafeInt('age');
    print('Success: $age');
  } catch (e) {
    print('   $e');
    print('   💡 Now you know exactly what to fix!');
  }
}

/// Demonstrates helpful suggestions for missing or misnamed keys
void missingKeyExample() {
  final json = {
    'user_name': 'John Doe',
    'user_email': 'john@example.com',
    'user_age': 25,
  };
  
  print('Looking for \'username\' in JSON with similar keys...');
  try {
    final name = json.getSafeString('username'); // Typo: missing underscore
    print('Found: $name');
  } catch (e) {
    print('$e');
  }
}

/// Shows how to debug real-world API responses with mixed types
void realWorldApiExample() {
  // Simulating a problematic API response where backend returns unexpected types
  final apiResponse = {
    'user_id': '12345',           // Should be int, got string
    'name': 'John Doe',
    'balance': '99.99',           // Should be double, got string  
    'is_premium': 1,              // Should be bool, got int
    'created_at': 1698408600,     // Unix timestamp
    'settings': {
      'theme': 'dark',
      'notifications': true,
    },
    'tags': ['premium', 'verified'],
    'invalid_list': 'not_a_list', // Should be list, got string
  };

  print('🔍 Debugging API response with type mismatches:\n');
  
  // These work fine
  print('✅ Working fields:');
  print('   Name: ${apiResponse.getSafeString('name')}');
  print('   Created: ${apiResponse.getSafeDateTime('created_at')}');
  print('   Premium: ${apiResponse.getSafeBool('is_premium')}'); // Handles int->bool conversion
  print('   Tags: ${apiResponse.getSafeList('tags', (v) => v as String)}');
  
  print('\n❌ Problematic fields (with clear error messages):');
  
  // These will show clear errors
  _tryAndShowError('user_id as int', () => apiResponse.getSafeInt('user_id'));
  _tryAndShowError('balance as double', () => apiResponse.getSafeDouble('balance'));
  _tryAndShowError('invalid_list as list', () => apiResponse.getSafeList('invalid_list', (v) => v as String));
}

/// Demonstrates the convenience methods for common types
void convenienceMethodsExample() {
  final json = {
    'name': 'John Doe',
    'age': 25,
    'score': 99.5,
    'active': true,
    'premium': 1,           // Will be converted to bool
    'signup_date': '2023-10-27T10:30:00Z',
    'last_login': 1698408600, // Unix timestamp
    'tags': ['work', 'urgent'],
    'settings': {
      'theme': 'dark',
      'auto_save': true,
    }
  };
  
  print('🎯 Using convenience methods:');
  print('   String: ${json.getSafeString('name')}');
  print('   Int: ${json.getSafeInt('age')}');
  print('   Double: ${json.getSafeDouble('score')}');
  print('   Bool: ${json.getSafeBool('active')}');
  print('   Bool from int: ${json.getSafeBool('premium')}'); // 1 -> true
  print('   DateTime: ${json.getSafeDateTime('signup_date')}');
  print('   DateTime from timestamp: ${json.getSafeDateTime('last_login')}');
  print('   String list: ${json.getSafeList('tags', (v) => v as String)}');
  print('   Nested object: ${json.getSafeObject('settings', (data) => UserSettings.fromJson(data))}');
  
  print('\n🔒 Nullable methods (return null for missing keys):');
  print('   Optional email: ${json.getNullableSafeString('email')}');
  print('   Optional phone: ${json.getNullableSafeString('phone')}');
}

/// Shows advanced features like validation and structure analysis
void advancedFeaturesExample() {
  final json = {
    'id': 123,
    'name': 'John Doe',
    'email': 'john@example.com',
    'profile': {
      'bio': 'Flutter developer',
      'avatar_url': 'https://example.com/avatar.jpg',
    },
    'posts': [
      {'title': 'First Post', 'likes': 10},
      {'title': 'Second Post', 'likes': 25},
    ]
  };
  
  print('🔧 Advanced features:');
  
  // Validate required keys upfront
  print('\n1. Key validation:');
  try {
    json.requireKeys(['id', 'name', 'email']);
    print('   ✅ All required keys present');
  } catch (e) {
    print('   ❌ $e');
  }
  
  try {
    json.requireKeys(['id', 'name', 'email', 'missing_key']);
    print('   ✅ All required keys present');
  } catch (e) {
    print('   ❌ Missing key detected: ${e.toString().split('\n')[0]}');
  }
  
  // Structure analysis
  print('\n2. Structure summary:');
  print('   ${json.getStructureSummary()}');
  
  // Parse nested objects and lists
  print('\n3. Complex nested parsing:');
  final profile = json.getSafeObject('profile', UserProfile.fromJson);
  print('   Profile: ${profile.bio}');
  
  final posts = json.getSafeObjectList('posts', BlogPost.fromJson);
  print('   Posts: ${posts.length} posts, total likes: ${posts.fold(0, (sum, post) => sum + post.likes)}');
  
  // Enhanced error context
  print('\n4. Enhanced error context:');
  final statusJson = {'status': 'invalid_status'};
  _tryAndShowError('status with context', () => 
    statusJson.getSafeWithContext(
      'status',
      (v) => UserStatus.values.byName(v as String),
      fieldDescription: 'User account status',
      commonValues: ['active', 'inactive', 'pending', 'suspended'],
    )
  );
}

/// Helper to demonstrate error messages cleanly
void _tryAndShowError(String description, Function() action) {
  try {
    final result = action();
    print('   ✅ $description: $result');
  } catch (e) {
    print('   ❌ $description:');
    // Show only the first line for brevity in demo
    final firstLine = e.toString().split('\n')[0];
    print('      $firstLine');
  }
}

// Helper classes for demonstration
class UserSettings {
  final String theme;
  final bool autoSave;
  
  UserSettings({required this.theme, required this.autoSave});
  
  static UserSettings fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: json.getSafeString('theme'),
      autoSave: json.getSafeBool('auto_save'),
    );
  }
  
  @override
  String toString() => 'UserSettings(theme: $theme, autoSave: $autoSave)';
}

class UserProfile {
  final String bio;
  final String avatarUrl;
  
  UserProfile({required this.bio, required this.avatarUrl});
  
  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json.getSafeString('bio'),
      avatarUrl: json.getSafeString('avatar_url'),
    );
  }
}

class BlogPost {
  final String title;
  final int likes;
  
  BlogPost({required this.title, required this.likes});
  
  static BlogPost fromJson(Map<String, dynamic> json) {
    return BlogPost(
      title: json.getSafeString('title'),
      likes: json.getSafeInt('likes'),
    );
  }
}

enum UserStatus {
  active,
  inactive,
  pending,
  suspended,
}
