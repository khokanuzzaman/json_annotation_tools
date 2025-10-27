library;

import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  print('🚀 json_annotation_tools Example');
  print('=' * 50);

  // 🎯 SAFE JSON PARSING WITH ENHANCED ERRORS
  print('\n📱 Safe JSON Parsing with Enhanced Error Messages');
  print('-' * 30);
  
  final userJson = {
    'id': 123,
    'name': 'John Doe',
    'email': 'john@example.com',
    'age': 30,
    'isActive': true,
  };

  try {
    // Using safe extension methods - no crashes on type mismatches!
    final id = userJson.getSafeInt('id');
    final name = userJson.getSafeString('name');
    final email = userJson.getSafeString('email');
    final age = userJson.getNullableSafeInt('age');
    final isActive = userJson.getSafeBool('isActive');
    
    print('✅ SUCCESS: Parsed user data safely');
    print('   ID: $id, Name: $name, Age: $age, Active: $isActive');
  } catch (e) {
    print('❌ Error: $e');
  }

  // 🔥 ERROR DEMONSTRATION: See enhanced error messages
  print('\n🔥 ERROR DEMONSTRATION: Enhanced Error Messages');
  print('-' * 30);
  
  final badJson = {
    'id': 'not-a-number', // ❌ Should be int, got String
    'name': 'Jane Doe',
    'email': 'jane@example.com',
    'isActive': true,
  };

  print('\n📋 Trying to parse invalid JSON (id should be int, got String):');
  
  try {
    final id = badJson.getSafeInt('id');
    print('❌ Should have failed but got: $id');
  } catch (e) {
    print('✅ CAUGHT ENHANCED ERROR:');
    print('🔽 Enhanced error message:');
    final lines = e.toString().split('\n');
    for (int i = 0; i < lines.length && i < 8; i++) {
      print('   ${lines[i]}');
    }
    print('   ...');
    print('💡 Notice: Clear diagnosis + copy-paste solutions!');
  }

  // 🔥 MISSING FIELD DEMONSTRATION
  print('\n🔥 MISSING FIELD DEMONSTRATION');
  print('-' * 30);
  
  final incompleteJson = {
    'name': 'Bob Wilson',
    'email': 'bob@example.com',
    // Missing 'id' field
  };

  print('\n📋 Trying to get missing field "id":');
  
  try {
    final id = incompleteJson.getSafeInt('id');
    print('❌ Should have failed but got: $id');
  } catch (e) {
    print('✅ CAUGHT MISSING FIELD ERROR:');
    print('🔽 Enhanced error message with suggestions:');
    final lines = e.toString().split('\n');
    for (int i = 0; i < lines.length && i < 6; i++) {
      print('   ${lines[i]}');
    }
    print('   ...');
    print('💡 Notice: Suggests similar field names!');
  }

  // 🎯 REAL-WORLD SCENARIO: API Response Handling
  print('\n🌐 REAL-WORLD SCENARIO: API Response Handling');
  print('-' * 30);
  
  // Simulate different API responses
  final apiResponses = [
    {'status': 'Valid user', 'data': userJson},
    {'status': 'Type error', 'data': badJson},
    {'status': 'Missing field', 'data': incompleteJson},
  ];

  for (int i = 0; i < apiResponses.length; i++) {
    final response = apiResponses[i];
    final status = response['status'] as String;
    print('\n📡 API Response ${i + 1}: $status');
    
    try {
      final data = response['data'] as Map<String, dynamic>;
      final id = data.getSafeInt('id');
      final name = data.getSafeString('name');
      print('   ✅ SUCCESS: Parsed user $name (ID: $id)');
    } catch (e) {
      print('   ❌ FAILED: ${e.toString().split('\n').first}');
      // In production: crashlytics.recordError(e, null);
    }
  }

  print('\n🎉 Example Complete!');
  print('=' * 50);
  print('✅ No more cryptic errors like "type \'String\' is not a subtype of type \'int\'"!');
  print('✅ Clear, actionable error messages for faster debugging!');
  print('✅ Copy-paste solutions save development time!');
  print('✅ Perfect for production apps with external APIs!');
  print('\n🚀 For code generation (@SafeJsonParsing), see PRODUCTION_SETUP.md!');
}
