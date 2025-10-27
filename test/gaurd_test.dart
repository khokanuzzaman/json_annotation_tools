import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  group('JsonFieldGuard', () {
    test('parses correct type successfully', () {
      final value = JsonFieldGuard.guard('id', 123, (v) => v as int);
      expect(value, 123);
    });

    test('throws detailed error on wrong type', () {
      expect(
        () => JsonFieldGuard.guard('age', 'abc', (v) => int.parse(v)),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Field name: \'age\''),
          ),
        ),
      );
    });

    test('provides type-specific suggestions for int/string mismatch', () {
      expect(
        () => JsonFieldGuard.guard('age', '25', (v) => v as int),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('Field name: \'age\''),
              contains('whole number (like 42)'),
              contains('The actual value: 25'),
              contains('How to fix this'),
            ]),
          ),
        ),
      );
    });

    test('guardWithContext provides enhanced error information', () {
      expect(
        () => JsonFieldGuard.guardWithContext(
          'status',
          'invalid',
          (v) => throw ArgumentError('Invalid status'),
          fieldDescription: 'User account status',
          commonValues: ['active', 'inactive', 'pending'],
        ),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('User account status'),
              contains('Common valid values: active, inactive, pending'),
            ]),
          ),
        ),
      );
    });

    test('guardNotNull throws clear error for null values', () {
      expect(
        () => JsonFieldGuard.guardNotNull('name', null, (v) => v as String),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('Required field \'name\' is null'),
              contains('Use getNullableSafe()'),
            ]),
          ),
        ),
      );
    });

    test('guardList parses valid list successfully', () {
      final result = JsonFieldGuard.guardList('tags', ['a', 'b', 'c'], (v) => v as String);
      expect(result, ['a', 'b', 'c']);
    });

    test('guardList provides detailed error for invalid item', () {
      expect(
        () => JsonFieldGuard.guardList('numbers', [1, 'invalid', 3], (v) => v as int),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('Error parsing list \'numbers\' at index 1'),
              contains('Item value: invalid'),
              contains('Full list:'),
            ]),
          ),
        ),
      );
    });

    test('guardList throws error for non-list value', () {
      expect(
        () => JsonFieldGuard.guardList('tags', 'not a list', (v) => v as String),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('expected List'),
          ),
        ),
      );
    });
  });

  group('SafeJsonExtension - Basic Functionality', () {
    test('getSafe returns parsed value for existing key', () {
      final json = {'name': 'John', 'age': 25};
      expect(json.getSafe('name', (v) => v as String), 'John');
      expect(json.getSafe('age', (v) => v as int), 25);
    });

    test('getSafe throws detailed error for missing key', () {
      final json = {'name': 'John'};
      expect(
        () => json.getSafe('age', (v) => v as int),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('📍 Field your model expects: \'age\''),
              contains('📄 JSON response contains: name'),
            ]),
          ),
        ),
      );
    });

    test('getSafe suggests similar keys when available', () {
      final json = {'user_name': 'John', 'user_age': 25};
      expect(
        () => json.getSafe('username', (v) => v as String),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('→ \'user_name\' (looks similar to \'username\')'),
          ),
        ),
      );
    });

    test('getNullableSafe returns null for missing key', () {
      final json = {'name': 'John'};
      expect(json.getNullableSafe('age', (v) => v as int), isNull);
    });

    test('getNullableSafe returns null for null value', () {
      final json = {'name': 'John', 'age': null};
      expect(json.getNullableSafe('age', (v) => v as int), isNull);
    });

    test('getNullableSafe returns parsed value for existing non-null key', () {
      final json = {'name': 'John', 'age': 25};
      expect(json.getNullableSafe('age', (v) => v as int), 25);
    });
  });

  group('SafeJsonExtension - Convenience Methods', () {
    test('getSafeString works correctly', () {
      final json = {'name': 'John'};
      expect(json.getSafeString('name'), 'John');
    });

    test('getSafeInt handles num types', () {
      final json = {'age': 25, 'score': 99.0};
      expect(json.getSafeInt('age'), 25);
      expect(json.getSafeInt('score'), 99);
    });

    test('getSafeDouble handles num types', () {
      final json = {'price': 19.99, 'count': 5};
      expect(json.getSafeDouble('price'), 19.99);
      expect(json.getSafeDouble('count'), 5.0);
    });

    test('getSafeBool handles various boolean representations', () {
      final json = {
        'flag1': true,
        'flag2': false,
        'flag3': 1,
        'flag4': 0,
        'flag5': 'true',
        'flag6': 'false',
        'flag7': 'TRUE',
        'flag8': 'FALSE',
        'flag9': '1',
        'flag10': '0',
        'flag11': 'yes',
        'flag12': 'no',
      };
      
      expect(json.getSafeBool('flag1'), true);
      expect(json.getSafeBool('flag2'), false);
      expect(json.getSafeBool('flag3'), true);
      expect(json.getSafeBool('flag4'), false);
      expect(json.getSafeBool('flag5'), true);
      expect(json.getSafeBool('flag6'), false);
      expect(json.getSafeBool('flag7'), true);
      expect(json.getSafeBool('flag8'), false);
      expect(json.getSafeBool('flag9'), true);
      expect(json.getSafeBool('flag10'), false);
      expect(json.getSafeBool('flag11'), true);
      expect(json.getSafeBool('flag12'), false);
    });

    test('getSafeDateTime handles various date formats', () {
      final json = {
        'date1': '2023-10-27T10:30:00Z',
        'date2': 1698408600, // Unix timestamp in seconds
        'date3': 1698408600000, // Unix timestamp in milliseconds
      };
      
      final date1 = json.getSafeDateTime('date1');
      final date2 = json.getSafeDateTime('date2');
      final date3 = json.getSafeDateTime('date3');
      
      expect(date1, isA<DateTime>());
      expect(date2, isA<DateTime>());
      expect(date3, isA<DateTime>());
    });

    test('nullable convenience methods return null appropriately', () {
      final json = {'name': 'John'};
      
      expect(json.getNullableSafeString('email'), isNull);
      expect(json.getNullableSafeInt('age'), isNull);
      expect(json.getNullableSafeDouble('score'), isNull);
      expect(json.getNullableSafeBool('active'), isNull);
      expect(json.getNullableSafeDateTime('created'), isNull);
    });
  });

  group('SafeJsonExtension - Advanced Features', () {
    test('getSafeList works with homogeneous lists', () {
      final json = {
        'tags': ['work', 'urgent', 'meeting'],
        'scores': [85, 92, 78],
      };
      
      expect(json.getSafeList('tags', (v) => v as String), ['work', 'urgent', 'meeting']);
      expect(json.getSafeList('scores', (v) => v as int), [85, 92, 78]);
    });

    test('getSafeObject parses nested objects', () {
      final json = {
        'user': {'name': 'John', 'age': 25}
      };
      
      final user = json.getSafeObject('user', (data) => _TestUser.fromJson(data));
      expect(user.name, 'John');
      expect(user.age, 25);
    });

    test('getSafeObjectList parses list of objects', () {
      final json = {
        'users': [
          {'name': 'John', 'age': 25},
          {'name': 'Jane', 'age': 30},
        ]
      };
      
      final users = json.getSafeObjectList('users', _TestUser.fromJson);
      expect(users.length, 2);
      expect(users[0].name, 'John');
      expect(users[1].name, 'Jane');
    });

    test('requireKeys validates all required keys exist', () {
      final json = {'name': 'John', 'email': 'john@example.com'};
      
      // Should not throw
      json.requireKeys(['name', 'email']);
      
      // Should throw
      expect(
        () => json.requireKeys(['name', 'email', 'age']),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('❌ Missing fields: age'),
          ),
        ),
      );
    });

    test('getStructureSummary provides useful debugging info', () {
      final json = {
        'name': 'John',
        'age': 25,
        'active': true,
        'tags': ['work', 'urgent'],
      };
      
      final summary = json.getStructureSummary();
      expect(summary, contains('name'));
      expect(summary, contains('age'));
      expect(summary, contains('String'));
      expect(summary, contains('int'));
    });
  });

  group('SafeJsonExtension - Error Scenarios', () {
    test('detailed error messages for type mismatches', () {
      final json = {'age': '25'}; // String instead of int
      
      expect(
        () => json.getSafeInt('age'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('📍 Field name: \'age\''),
              contains('🎯 Your model expects: a whole number (like 42)'),
              contains('😕 JSON response contains: text (like \'hello\')'),
              contains('📄 The actual value: 25'),
            ]),
          ),
        ),
      );
    });

    test('helpful suggestions for invalid boolean values', () {
      final json = {'active': 'maybe'};
      
      expect(
        () => json.getSafeBool('active'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('🚨 OOPS! Can\'t convert \'maybe\' to true/false:'),
          ),
        ),
      );
    });

    test('clear error for invalid date formats', () {
      final json = {'created': 'not-a-date'};
      
      expect(
        () => json.getSafeDateTime('created'),
        throwsFormatException,
      );
    });

    test('list parsing errors include item index', () {
      final json = {'scores': [85, 'invalid', 78]};
      
      expect(
        () => json.getSafeList('scores', (v) => v as int),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('at index 1'),
              contains('Item value: invalid'),
            ]),
          ),
        ),
      );
    });
  });

  group('Real-World Scenarios', () {
    test('API response with mixed data types', () {
      // Simulating a problematic API response
      final apiResponse = {
        'user_id': '12345', // Should be int
        'name': 'John Doe',
        'age': 25,
        'balance': '99.99', // Should be double
        'is_premium': 1, // Should be bool
        'created_at': '2023-10-27T10:30:00Z',
        'tags': ['premium', 'verified'],
        'settings': {
          'theme': 'dark',
          'notifications': true,
        }
      };

      // These should work with flexible parsing
      expect(apiResponse.getSafeString('name'), 'John Doe');
      expect(apiResponse.getSafeInt('age'), 25);
      expect(apiResponse.getSafeList('tags', (v) => v as String), ['premium', 'verified']);
      
      // These would typically fail but should provide clear error messages
      expect(
        () => apiResponse.getSafeInt('user_id'), // String '12345' as int
        throwsA(isA<FormatException>()),
      );
      
      expect(
        () => apiResponse.getSafeDouble('balance'), // String '99.99' as double
        throwsA(isA<FormatException>()),
      );

      expect(
        () => apiResponse.getSafeBool('is_premium'), // int 1 as bool - this should actually work
        returnsNormally,
      );
      
      expect(apiResponse.getSafeBool('is_premium'), true);
    });

    test('handling completely malformed JSON structure', () {
      final malformedJson = {
        'user': 'should_be_object',
        'items': 'should_be_array',
        'count': null,
      };

      expect(
        () => malformedJson.getSafeObject('user', _TestUser.fromJson),
        throwsA(isA<FormatException>()),
      );

      expect(
        () => malformedJson.getSafeList('items', (v) => v as String),
        throwsA(isA<FormatException>()),
      );

      expect(
        () => malformedJson.getSafeInt('count'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}

// Helper class for testing object parsing
class _TestUser {
  final String name;
  final int age;

  _TestUser({required this.name, required this.age});

  static _TestUser fromJson(Map<String, dynamic> json) {
    return _TestUser(
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }
}
