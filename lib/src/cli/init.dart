import 'dart:io';

import 'package:path/path.dart' as p;

/// Describes the outcome of running the `init` command.
class InitReport {
  InitReport({required this.changes, required this.skippedPaths});

  /// All files that were updated.
  final List<FileChange> changes;

  /// Files that were skipped (e.g. generated outputs or unsupported locations).
  final List<String> skippedPaths;

  /// Whether any file content was updated.
  bool get hasUpdates => changes.any((change) => change.hasUpdates);

  /// Number of files inspected (changed + skipped).
  int get processedCount => changes.length + skippedPaths.length;
}

/// Metadata describing how a single file was updated.
class FileChange {
  FileChange({
    required this.path,
    required this.addedAnnotation,
    required this.addedPartDirective,
  });

  final String path;
  final bool addedAnnotation;
  final bool addedPartDirective;

  bool get hasUpdates => addedAnnotation || addedPartDirective;
}

/// Options supported by the `init` command.
class InitOptions {
  InitOptions({
    required this.projectRoot,
    required this.targetDirectory,
    required this.applyChanges,
    required this.verbose,
  });

  final String projectRoot;
  final String targetDirectory;
  final bool applyChanges;
  final bool verbose;
}

/// Entry point used by the CLI as well as tests.
Future<InitReport> runInit(InitOptions options) async {
  final targetDir = Directory(
    p.join(options.projectRoot, options.targetDirectory),
  );
  if (!targetDir.existsSync()) {
    throw StateError(
      'Target directory "${options.targetDirectory}" does not exist under ${options.projectRoot}.',
    );
  }

  final changes = <FileChange>[];
  final skipped = <String>[];

  await for (final entity in targetDir.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is! File) {
      continue;
    }
    if (!_shouldProcessFile(entity)) {
      skipped.add(_relativePath(options.projectRoot, entity.path));
      continue;
    }

    final relativePath = _relativePath(options.projectRoot, entity.path);
    final originalContent = await entity.readAsString();

    if (!_hasSerializableAnnotation(originalContent)) {
      skipped.add(relativePath);
      continue;
    }

    final transformation = _transformContent(originalContent, entity.path);

    if (transformation.hasChanges) {
      if (options.applyChanges) {
        await entity.writeAsString(transformation.content);
      }

      changes.add(
        FileChange(
          path: relativePath,
          addedAnnotation: transformation.addedAnnotation,
          addedPartDirective: transformation.addedPart,
        ),
      );
    } else if (options.verbose) {
      skipped.add(relativePath);
    }
  }

  return InitReport(changes: changes, skippedPaths: skipped);
}

bool _shouldProcessFile(File file) {
  final segments = p.split(file.path);

  if (segments.any((segment) => segment.startsWith('.dart_tool'))) {
    return false;
  }

  if (file.path.endsWith('.g.dart') || file.path.endsWith('.freezed.dart')) {
    return false;
  }

  return file.path.endsWith('.dart');
}

String _relativePath(String root, String absolutePath) {
  return p.normalize(p.relative(absolutePath, from: root));
}

class _TransformationResult {
  _TransformationResult({
    required this.content,
    required this.addedAnnotation,
    required this.addedPart,
  });

  final String content;
  final bool addedAnnotation;
  final bool addedPart;

  bool get hasChanges => addedAnnotation || addedPart;
}

_TransformationResult _transformContent(String content, String filePath) {
  var updatedContent = content;
  final annotationResult = _ensureSafeAnnotation(updatedContent);
  updatedContent = annotationResult.content;

  final partResult = _ensureSafePartDirective(updatedContent, filePath);
  updatedContent = partResult.content;

  return _TransformationResult(
    content: updatedContent,
    addedAnnotation: annotationResult.changed,
    addedPart: partResult.changed,
  );
}

class _AnnotationResult {
  _AnnotationResult(this.content, this.changed);

  final String content;
  final bool changed;
}

bool _hasSerializableAnnotation(String content) {
  return RegExp(r'^\s*@JsonSerializable', multiLine: true).hasMatch(content);
}

_AnnotationResult _ensureSafeAnnotation(String content) {
  final annotationPattern = RegExp(
    r'^\s*@JsonSerializable(?:\s*\([^)]*\))?',
    multiLine: true,
  );
  var updatedContent = content;
  var changed = false;

  final matches = annotationPattern.allMatches(content).toList().reversed;

  for (final match in matches) {
    final tail = updatedContent.substring(match.end);
    if (_hasSafeAnnotationBeforeTypeDeclaration(tail)) {
      continue;
    }

    final indent = _indentAt(updatedContent, match.start);
    final insertion = '\n$indent@SafeJsonParsing()';
    updatedContent =
        updatedContent.substring(0, match.end) +
        insertion +
        updatedContent.substring(match.end);
    changed = true;
  }

  return _AnnotationResult(updatedContent, changed);
}

bool _hasSafeAnnotationBeforeTypeDeclaration(String tail) {
  final safeMatch = RegExp(r'@SafeJsonParsing\b').firstMatch(tail);
  if (safeMatch == null) {
    return false;
  }

  final typeMatch = RegExp(r'\b(?:class|enum|mixin)\b').firstMatch(tail);
  if (typeMatch == null) {
    return true;
  }

  return safeMatch.start < typeMatch.start;
}

String _indentAt(String content, int offset) {
  final lineStart = content.lastIndexOf('\n', offset - 1) + 1;
  final line = content.substring(lineStart, offset);
  final whitespaceMatch = RegExp(r'^\s*').firstMatch(line);
  return whitespaceMatch?.group(0) ?? '';
}

class _PartResult {
  _PartResult(this.content, this.changed);

  final String content;
  final bool changed;
}

_PartResult _ensureSafePartDirective(String content, String filePath) {
  final baseName = p.basenameWithoutExtension(filePath);
  final safePartName = "$baseName.safe_json_parsing.g.dart";

  final quotedPattern = RegExp(
    "part\\s+['\"]${RegExp.escape(safePartName)}['\"];",
  );

  if (quotedPattern.hasMatch(content)) {
    return _PartResult(content, false);
  }

  final insertionIndex = _findPartInsertionIndex(content);
  final quoteChar = _resolveQuoteCharacter(content);
  final partSource = "part $quoteChar$safePartName$quoteChar;";

  final before = content.substring(0, insertionIndex);
  final after = content.substring(insertionIndex);

  final needsLeadingNewline = insertionIndex > 0 && !before.endsWith('\n');
  final prefix = needsLeadingNewline ? '\n' : '';

  final suffix = () {
    if (after.isEmpty) {
      return '\n';
    }
    if (after.startsWith('\n\n')) {
      return '';
    }
    if (after.startsWith('\n')) {
      return '';
    }
    return '\n\n';
  }();

  final updated =
      StringBuffer()
        ..write(before)
        ..write(prefix)
        ..write(partSource)
        ..write(suffix)
        ..write(after);

  return _PartResult(updated.toString(), true);
}

int _findPartInsertionIndex(String content) {
  final partMatches =
      RegExp(r'^part\s+.+;\s*$', multiLine: true).allMatches(content).toList();
  if (partMatches.isNotEmpty) {
    return partMatches.last.end;
  }

  final importMatches =
      RegExp(
        r'^import\s+.+;\s*$',
        multiLine: true,
      ).allMatches(content).toList();
  if (importMatches.isNotEmpty) {
    return importMatches.last.end;
  }

  final libraryMatch = RegExp(
    r'^library\s+.+;\s*$',
    multiLine: true,
  ).firstMatch(content);
  if (libraryMatch != null) {
    return libraryMatch.end;
  }

  final shebangMatch = RegExp(r'^#!.*\n').firstMatch(content);
  if (shebangMatch != null) {
    return shebangMatch.end;
  }

  return 0;
}

String _resolveQuoteCharacter(String content) {
  final existingPartMatch = RegExp(
    '^part\\s+([\'"])([^\'"]+)\\1;\\s*\$',
    multiLine: true,
  ).firstMatch(content);
  return existingPartMatch?.group(1) ?? "'";
}
