/// Examples showing the ultra-detailed diagnostic capabilities
/// Perfect for understanding exactly what's wrong with JSON parsing
library;

import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  print('🚀 Ultra-Detailed JSON Diagnostics Examples\n');
  
  // Example 1: Data type mismatch (property exists, wrong type)
  dataTypeMismatchExample();
  
  // Example 2: Property name mismatch (property missing)
  propertyNameMismatchExample();
  
  // Example 3: Case sensitivity issue
  caseSensitivityExample();
  
  // Example 4: Naming convention mismatch (camelCase vs snake_case)
  namingConventionExample();
  
  // Example 5: Complete property mapping analysis
  propertyMappingAnalysisExample();
  
  // Example 6: Real Dio/Retrofit API scenario
  realApiScenarioExample();
}

/// Example 1: When property exists but has wrong data type
void dataTypeMismatchExample() {
  print('📍 Example 1: DATA TYPE MISMATCH');
  print('=' * 50);
  
  final json = {
    'user_id': '12345',    // ❌ String instead of int
    'name': 'John Doe',    // ✅ Correct type
    'is_active': 'true',   // ❌ String instead of bool
  };
  
  print('JSON Response: $json\n');
  
  try {
    final userId = json.getSafeInt('user_id');
    print('✅ User ID: $userId');
  } catch (e) {
    print('🔍 DETAILED DIAGNOSIS:');
    print(e);
  }
  
  print('\n${'=' * 70}\n');
}

/// Example 2: When property name doesn't exist
void propertyNameMismatchExample() {
  print('📍 Example 2: PROPERTY NAME MISMATCH');
  print('=' * 50);
  
  final json = {
    'user_name': 'John Doe',     // ✅ Available
    'user_email': 'john@example.com', // ✅ Available
    'user_age': 25,              // ✅ Available
  };
  
  print('JSON Response: $json');
  print('Model expects: "username" (typo - missing underscore)\n');
  
  try {
    final username = json.getSafeString('username'); // ❌ Typo
    print('✅ Username: $username');
  } catch (e) {
    print('🔍 DETAILED DIAGNOSIS:');
    print(e);
  }
  
  print('\n${'=' * 70}\n');
}

/// Example 3: Case sensitivity issue
void caseSensitivityExample() {
  print('📍 Example 3: CASE SENSITIVITY ISSUE');
  print('=' * 50);
  
  final json = {
    'UserName': 'John Doe',      // ✅ Available (capital U, capital N)
    'Email': 'john@example.com', // ✅ Available (capital E)
  };
  
  print('JSON Response: $json');
  print('Model expects: "username" (lowercase)\n');
  
  try {
    final username = json.getSafeString('username'); // ❌ Wrong case
    print('✅ Username: $username');
  } catch (e) {
    print('🔍 DETAILED DIAGNOSIS:');
    print(e);
  }
  
  print('\n${'=' * 70}\n');
}

/// Example 4: Naming convention mismatch
void namingConventionExample() {
  print('📍 Example 4: NAMING CONVENTION MISMATCH');
  print('=' * 50);
  
  final json = {
    'firstName': 'John',         // ✅ camelCase
    'lastName': 'Doe',          // ✅ camelCase
    'emailAddress': 'john@example.com', // ✅ camelCase
  };
  
  print('JSON Response: $json');
  print('Model expects: "first_name" (snake_case)\n');
  
  try {
    final firstName = json.getSafeString('first_name'); // ❌ Convention mismatch
    print('✅ First Name: $firstName');
  } catch (e) {
    print('🔍 DETAILED DIAGNOSIS:');
    print(e);
  }
  
  print('\n${'=' * 70}\n');
}

/// Example 5: Complete property mapping analysis
void propertyMappingAnalysisExample() {
  print('📍 Example 5: COMPLETE PROPERTY MAPPING ANALYSIS');
  print('=' * 50);
  
  final json = {
    'id': 123,                   // ✅ Expected
    'name': 'John Doe',         // ✅ Expected
    // 'email': missing!         // ❌ Expected but missing
    'phone': '+1234567890',     // ➕ Extra (not expected)
    'address': '123 Main St',   // ➕ Extra (not expected)
    'created_at': '2023-10-27', // ➕ Extra (not expected)
  };
  
  print('JSON Response: $json');
  print('Model expects: [id, name, email, age]\n');
  
  // Analyze complete property mapping
  final expectedProperties = ['id', 'name', 'email', 'age'];
  final analysis = json.analyzePropertyMapping(expectedProperties);
  print(analysis);
  
  print('\n${'=' * 70}\n');
}

/// Example 6: Real Dio/Retrofit API scenario
void realApiScenarioExample() {
  print('📍 Example 6: REAL DIO/RETROFIT API SCENARIO');
  print('=' * 50);
  
  // Simulate what you get from: dio.get('/api/users/123').data
  final apiResponse = {
    'user_id': '12345',          // ❌ Should be int
    'full_name': 'John Doe',     // ✅ But model expects 'name'
    'email_address': 'john@example.com', // ✅ But model expects 'email'  
    'is_active': 1,              // ❌ Should be bool
    'created_timestamp': 1698408600, // ✅ Unix timestamp
    'profile_data': {            // ➕ Extra nested data
      'bio': 'Flutter developer',
      'avatar_url': 'https://example.com/avatar.jpg',
    },
    'permissions': ['read', 'write'], // ➕ Extra array
    'last_login_ip': '192.168.1.1',  // ➕ Extra field
  };
  
  print('🌐 API Response from Dio:');
  print(apiResponse);
  print('\n📝 Your Retrofit model expects:');
  print('- id (int)');  
  print('- name (String)');
  print('- email (String)');
  print('- isActive (bool)');
  print('- createdAt (DateTime)');
  print('');
  
  // Test each field individually
  print('🔍 FIELD-BY-FIELD ANALYSIS:');
  print('');
  
  // Test user_id (type mismatch)
  try {
    final id = apiResponse.getSafeInt('id'); // Wrong field name
  } catch (e) {
    print('❌ ID Field:');
    print(e.toString().split('\n').take(8).join('\n'));
    print('...\n');
  }
  
  // Test name (field name mismatch)  
  try {
    final name = apiResponse.getSafeString('name'); // Wrong field name
  } catch (e) {
    print('❌ Name Field:');
    print(e.toString().split('\n').take(8).join('\n'));
    print('...\n');
  }
  
  // Complete mapping analysis
  print('📊 COMPLETE MAPPING ANALYSIS:');
  final expectedFields = ['id', 'name', 'email', 'isActive', 'createdAt'];
  final mappingAnalysis = apiResponse.analyzePropertyMapping(expectedFields);
  print(mappingAnalysis);
  
  print('💡 SOLUTIONS:');
  print('1. Use @JsonKey annotations in your model:');
  print('   @JsonKey(name: "user_id") final int id;');
  print('   @JsonKey(name: "full_name") final String name;');
  print('   @JsonKey(name: "email_address") final String email;');
  print('');
  print('2. Or create fromJsonSafe method with explicit mapping:');
  print('   factory User.fromJsonSafe(Map<String, dynamic> json) {');
  print('     return User(');
  print('       id: json.getSafeInt("user_id"),  // Map field names');
  print('       name: json.getSafeString("full_name"),');
  print('       email: json.getSafeString("email_address"),');
  print('       isActive: json.getSafeBool("is_active"), // Handles 0/1');
  print('       createdAt: json.getSafeDateTime("created_timestamp"),');
  print('     );');
  print('   }');
  
  print('\n${'=' * 70}\n');
}
