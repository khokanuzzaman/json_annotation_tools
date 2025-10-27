library;

import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  print('🚀 json_annotation_tools Example');
  print('=' * 50);

  // 🤖 CODE GENERATION APPROACH: @SafeJsonParsing() 
  print('\n🤖 APPROACH 1: @SafeJsonParsing() Code Generation');
  print('-' * 30);
  
  final userJson = {
    'id': 123,
    'name': 'John Doe',
    'email': 'john@example.com',
    'age': 30,
    'isActive': true,
  };

  print('📝 With @SafeJsonParsing(), you would write:');
  print('   @JsonSerializable()');
  print('   @SafeJsonParsing()');
  print('   class User { ... }');
  print('');
  print('🚀 This auto-generates: UserSafeJsonParsing.fromJsonSafe(json)');
  print('✅ Enhanced errors built into the generated method!');
  print('📖 See user.dart for the complete model example');
  print('🏗️ Run: dart run build_runner build (to generate code)');

  // 📱 MANUAL APPROACH: Safe Extension Methods
  print('\n📱 APPROACH 2: Manual Safe Extensions (Alternative)');
  print('-' * 30);

  try {
    // Using safe extension methods - no crashes on type mismatches!
    final id = userJson.getSafeInt('id');
    final name = userJson.getSafeString('name');
    final email = userJson.getSafeString('email');
    final age = userJson.getNullableSafeInt('age');
    final isActive = userJson.getSafeBool('isActive');
    
    print('✅ SUCCESS: Manual parsing worked!');
    print('   ID: $id, Name: $name, Age: $age, Active: $isActive');
  } catch (e) {
    print('❌ Error: $e');
  }

  // 🔥 ERROR DEMONSTRATION: See Enhanced Error Messages in Action!
  print('\n🔥 ERROR DEMONSTRATION: Enhanced Error Messages');
  print('-' * 30);
  
  final badJson = {
    'id': 'not-a-number', // ❌ Should be int, got String
    'name': 'Jane Doe',
    'email': 'jane@example.com',
    'age': 25,
    'isActive': true,
  };

  print('\n📋 Trying to parse invalid JSON (id should be int, got String):');
  
  try {
    // 🔍 Using manual extension method to show enhanced error
    final id = badJson.getSafeInt('id');
    print('❌ Should have failed but got: $id');
  } catch (e) {
    print('✅ CAUGHT ENHANCED ERROR MESSAGE:');
    print('🔽 This is the same enhanced error you get with @SafeJsonParsing():');
    final lines = e.toString().split('\n');
    for (int i = 0; i < lines.length && i < 12; i++) {
      print('   ${lines[i]}');
    }
    print('   ...');
    print('💡 Notice: Both approaches give the same detailed diagnosis + solutions!');
  }

  // 🔥 MISSING FIELD DEMONSTRATION
  print('\n🔥 MISSING FIELD: Smart Field Detection');
  print('-' * 30);
  
  final incompleteJson = {
    'name': 'Bob Wilson',
    'email': 'bob@example.com',
    // Missing 'id' field
  };

  print('\n📋 Trying to get missing field "id":');
  
  try {
    // 🔍 Using manual extension method to show missing field error
    final id = incompleteJson.getSafeInt('id');
    print('❌ Should have failed but got: $id');
  } catch (e) {
    print('✅ CAUGHT MISSING FIELD ERROR:');
    print('🔽 Enhanced missing field message with suggestions:');
    final lines = e.toString().split('\n');
    for (int i = 0; i < lines.length && i < 10; i++) {
      print('   ${lines[i]}');
    }
    print('   ...');
    print('💡 Notice: Shows available fields + suggests similar names!');
  }

  // 🎯 REAL-WORLD SCENARIO: Production API Handling
  print('\n🌐 PRODUCTION SCENARIO: API Response Handling');
  print('-' * 30);
  
  // Simulate different API responses
  final apiResponses = [
    {'status': 'Valid user response', 'data': userJson},
    {'status': 'Type error response', 'data': badJson},
    {'status': 'Missing field response', 'data': incompleteJson},
  ];

  for (int i = 0; i < apiResponses.length; i++) {
    final response = apiResponses[i];
    final status = response['status'] as String;
    print('\n📡 API Response ${i + 1}: $status');
    
    try {
      final data = response['data'] as Map<String, dynamic>;
      // 🔧 Using manual extension methods (same enhanced errors as @SafeJsonParsing!)
      final id = data.getSafeInt('id');
      final name = data.getSafeString('name');
      print('   ✅ SUCCESS: Parsed user $name (ID: $id)');
    } catch (e) {
      print('   ❌ PARSING FAILED: Enhanced error logged for debugging');
      print('   📝 Error preview: ${e.toString().split('\n').first}');
      // 🏭 In production, you'd log this to Crashlytics/Sentry:
      // crashlytics.recordError(e, null);
      // logger.error('User parsing failed', error: e);
    }
  }

  print('\n🎉 Enhanced JSON Parsing Example Complete!');
  print('=' * 50);
  print('🚀 WHAT YOU LEARNED:');
  print('✅ Two approaches: @SafeJsonParsing() code generation + manual extensions');
  print('✅ Enhanced errors show exact problem + copy-paste solutions');
  print('✅ Perfect for production: detailed errors + graceful handling');
  print('✅ Same enhanced error messages with both approaches');
  print('\n🤖 @SafeJsonParsing() CODE GENERATION:');
  print('• Annotate your model with @SafeJsonParsing()');
  print('• Run: dart run build_runner build');
  print('• Use: UserSafeJsonParsing.fromJsonSafe(json)');
  print('• Result: Enhanced errors built into generated method!');
  print('\n📚 NEXT STEPS:');
  print('🔗 Full production guide: PRODUCTION_SETUP.md');
  print('📱 Interactive Flutter demo: example_app/');
  print('🌟 Ready to eliminate cryptic JSON errors forever!');
}
