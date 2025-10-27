/// Quick test to verify @SafeJsonParsing code generation works
library;
import 'lib/models/user.dart';

void main() {
  print('🚀 Testing @SafeJsonParsing() Code Generation!');
  print('=' * 50);

  // Test valid JSON
  final validJson = {
    'id': 123,
    'name': 'John Doe',
    'email': 'john@example.com',
    'age': 30,
    'isActive': true,
    'createdAt': '2024-01-15T10:30:00Z',
    'tags': ['developer', 'flutter'],
  };

  try {
    // 🚀 TESTING AUTO-GENERATED METHOD!
    final user = UserSafeJsonParsing.fromJsonSafe(validJson);
    print('✅ SUCCESS: Auto-generated UserSafeJsonParsing.fromJsonSafe() works!');
    print('   Name: ${user.name}, Age: ${user.age}');
  } catch (e) {
    print('❌ Error with UserSafeJsonParsing.fromJsonSafe(): $e');
  }

  // Test Product with validation
  final productJson = {
    'id': 'prod-123',
    'name': 'Flutter Book',
    'price': 29.99,
    'is_available': true,
    'tags': ['book', 'programming'],
  };

  try {
    // 🚀 TESTING AUTO-GENERATED METHOD WITH CUSTOM NAME!
    final product = ProductSafeJsonParsing.parseJsonSafe(productJson);
    print('✅ SUCCESS: Auto-generated ProductSafeJsonParsing.parseJsonSafe() works!');
    print('   Name: ${product.name}, Price: \$${product.price}');
  } catch (e) {
    print('❌ Error with ProductSafeJsonParsing.parseJsonSafe(): $e');
  }

  // Test error handling
  final badJson = {
    'id': '123',  // Should be int, got String - this will trigger enhanced error!
    'name': 'John Doe',
    'email': 'john@example.com',
    'isActive': true,
    'createdAt': '2024-01-15T10:30:00Z',
    'tags': ['test'],
  };

  print('\n🔥 Testing Enhanced Error Messages:');
  try {
    final user = UserSafeJsonParsing.fromJsonSafe(badJson);
    print('❌ Should have failed but got: $user');
  } catch (e) {
    print('✅ SUCCESS: Enhanced error message generated!');
    print('📋 Error details:');
    final errorLines = e.toString().split('\n');
    for (int i = 0; i < errorLines.length && i < 8; i++) {
      print('   ${errorLines[i]}');
    }
    if (errorLines.length > 8) {
      print('   ... (truncated for brevity)');
    }
  }

  print('\n🎉 @SafeJsonParsing() Code Generation Test Complete!');
}
