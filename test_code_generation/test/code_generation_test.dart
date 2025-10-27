import 'package:flutter_test/flutter_test.dart';
import 'package:test_code_generation/models/user.dart';

void main() {
  group('Safe JSON Parsing Extension Tests', () {
    test('should parse valid JSON using manual fromJsonSafe method for User', () {
      // Valid JSON data
      final validJson = {
        'id': 123,
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30,
        'isActive': true,
        'createdAt': '2024-01-15T10:30:00Z',
        'tags': ['developer', 'flutter'],
      };

      // Test that we can call the manual safe method
      expect(() => User.fromJsonSafe(validJson), returnsNormally);
      
      final user = User.fromJsonSafe(validJson);
      expect(user.id, equals(123));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.age, equals(30));
      expect(user.isActive, isTrue);
      expect(user.tags, equals(['developer', 'flutter']));
    });

    test('should provide detailed error messages for type mismatches', () {
      // JSON with type mismatch
      final badJson = {
        'id': '123',           // Should be int, got String
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30,
        'isActive': true,
        'createdAt': '2024-01-15T10:30:00Z',
        'tags': ['developer', 'flutter'],
      };

      expect(
        () => User.fromJsonSafe(badJson),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('id'),
              anyOf([
                contains('expected'),
                contains('expects'),
              ]),
              anyOf([
                contains('number'),
                contains('text'),
                contains('int'),
                contains('String'),
              ]),
              contains('TYPE COMPARISON'),
            ]),
          ),
        ),
      );
    });

    test('should handle nullable fields correctly', () {
      // JSON without optional age field
      final jsonWithoutAge = {
        'id': 123,
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        // age is missing (nullable)
        'isActive': false,
        'createdAt': '2024-01-15T10:30:00Z',
        'tags': [],
      };

      final user = User.fromJsonSafe(jsonWithoutAge);
      expect(user.age, isNull);
      expect(user.name, equals('Jane Doe'));
      expect(user.isActive, isFalse);
    });

    test('should generate parseJsonSafe method for Product with custom configuration', () {
      final validProductJson = {
        'id': 'prod-123',
        'name': 'Flutter Book',
        'price': 29.99,
        'is_available': true,
        'tags': ['book', 'programming'],
      };

      // Test custom method name
      expect(() => Product.parseJsonSafe(validProductJson), returnsNormally);
      
      final product = Product.parseJsonSafe(validProductJson);
      expect(product.id, equals('prod-123'));
      expect(product.name, equals('Flutter Book'));
      expect(product.price, equals(29.99));
      expect(product.isAvailable, isTrue);
      expect(product.tags, equals(['book', 'programming']));
    });

    test('should provide enhanced error messages with field descriptions', () {
      final badProductJson = {
        'id': 'prod-123',
        'name': 'Flutter Book',
        'price': 'invalid-price', // Should be double, got String
        'is_available': true,
      };

      expect(
        () => Product.parseJsonSafe(badProductJson),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('price'),
              anyOf([
                contains('Product price in USD'),
                contains('Positive number'),
                contains('19.99'),
              ]),
            ]),
          ),
        ),
      );
    });

    test('should validate required keys when configured', () {
      // Missing required field for Product (which has validateRequiredKeys: true)
      final incompleteProductJson = {
        'id': 'prod-123',
        // name is missing
        'price': 29.99,
        'is_available': true,
      };

      expect(
        () => Product.parseJsonSafe(incompleteProductJson),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            anyOf([
              contains('name'),
              contains('required'),
              contains('missing'),
            ]),
          ),
        ),
      );
    });

    test('should handle JsonKey name mapping correctly', () {
      // Test that @JsonKey(name: 'is_available') works with generated method
      final jsonWithSnakeCase = {
        'id': 'prod-456',
        'name': 'Dart Guide',
        'price': 19.99,
        'is_available': false, // Snake case as specified in @JsonKey
      };

      final product = Product.parseJsonSafe(jsonWithSnakeCase);
      expect(product.isAvailable, isFalse);
    });

    test('should work alongside standard fromJson method', () {
      final json = {
        'id': 789,
        'name': 'Test User',
        'email': 'test@example.com',
        'isActive': true,
        'createdAt': '2024-01-15T10:30:00Z',
        'tags': ['test'],
      };

      // Both methods should work
      final userStandard = User.fromJson(json);
      final userSafe = User.fromJsonSafe(json);

      expect(userStandard.id, equals(userSafe.id));
      expect(userStandard.name, equals(userSafe.name));
      expect(userStandard.email, equals(userSafe.email));
      expect(userStandard.isActive, equals(userSafe.isActive));
    });
  });

  group('Error Message Quality Tests', () {
    test('should provide copy-paste ready solutions', () {
      final badJson = {
        'id': 'not-a-number',
        'name': 'John',
        'email': 'john@example.com',
        'isActive': true,
        'createdAt': '2024-01-15T10:30:00Z',
        'tags': ['test'],
      };

      try {
        User.fromJsonSafe(badJson);
        fail('Should have thrown FormatException');
      } catch (e) {
        final errorMessage = e.toString();
        
        // Should contain diagnostic information
        expect(errorMessage, anyOf([
          contains('EXACT PROBLEM'),
          contains('COPY-PASTE'),
          contains('getSafe'),
          contains('solution'),
        ]));
      }
    });

    test('should suggest fixes for common mistakes', () {
      final jsonWithWrongFieldName = {
        'id': 123,
        'user_name': 'John Doe', // Should be 'name'
        'email': 'john@example.com',
        'isActive': true,
        'createdAt': '2024-01-15T10:30:00Z',
        'tags': ['test'],
      };

      try {
        User.fromJsonSafe(jsonWithWrongFieldName);
        fail('Should have thrown FormatException');
      } catch (e) {
        final errorMessage = e.toString();
        
        // Should suggest similar field names
        expect(errorMessage, anyOf([
          contains('name'),
          contains('user_name'),
          contains('similar'),
          contains('suggestion'),
        ]));
      }
    });
  });
}
