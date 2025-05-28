import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  test('throws error on wrong type', () {
    expect(
          () => JsonFieldGuard.guard('age', 'abc', (v) => int.parse(v)),
      throwsFormatException,
    );
  });

  test('parses correct type', () {
    final value = JsonFieldGuard.guard('id', 123, (v) => v as int);
    expect(value, 123);
  });
}
