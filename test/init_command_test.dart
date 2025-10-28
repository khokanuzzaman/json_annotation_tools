import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation_tools/src/cli/init.dart';
import 'package:path/path.dart' as p;

void main() {
  group('runInit', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync(
        'json_annotation_tools_test',
      );
      Directory(
        p.join(tempDir.path, 'lib', 'models'),
      ).createSync(recursive: true);
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    Future<File> writeModel(String filename, String content) async {
      final file = File(p.join(tempDir.path, 'lib', 'models', filename));
      await file.writeAsString(content);
      return file;
    }

    test('adds @SafeJsonParsing and part directive when missing', () async {
      final file = await writeModel('user.dart', '''
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;

  User(this.id, this.name);
}
''');

      final report = await runInit(
        InitOptions(
          projectRoot: tempDir.path,
          targetDirectory: 'lib',
          applyChanges: true,
          verbose: false,
        ),
      );

      expect(report.hasUpdates, isTrue);
      expect(report.changes, hasLength(1));
      expect(report.changes.first.addedAnnotation, isTrue);
      expect(report.changes.first.addedPartDirective, isTrue);

      final updatedContent = await file.readAsString();
      expect(
        updatedContent,
        contains('@JsonSerializable()\n@SafeJsonParsing()'),
      );
      expect(updatedContent, contains("part 'user.safe_json_parsing.g.dart';"));
    });

    test('reports dry run without touching files', () async {
      final file = await writeModel('product.dart', '''
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Product {
  final String sku;

  Product(this.sku);
}
''');

      final originalContent = await file.readAsString();

      final report = await runInit(
        InitOptions(
          projectRoot: tempDir.path,
          targetDirectory: 'lib',
          applyChanges: false,
          verbose: true,
        ),
      );

      expect(report.hasUpdates, isTrue);
      expect(report.changes.first.addedAnnotation, isTrue);
      expect(report.changes.first.addedPartDirective, isTrue);

      final afterContent = await file.readAsString();
      expect(afterContent, originalContent);
    });
  });
}
