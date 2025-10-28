import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:json_annotation_tools/src/cli/init.dart';

Future<void> main(List<String> arguments) async {
  final runner = CommandRunner<int>(
    'json_annotation_tools',
    'Utilities that make integrating safe JSON parsing a breeze.',
  )..addCommand(_InitCommand());

  try {
    final result = await runner.run(arguments) ?? 0;
    exit(result);
  } on UsageException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(e.usage);
    exitCode = 64; // EX_USAGE
  } on StateError catch (e) {
    stderr.writeln('Error: ${e.message}');
    exitCode = 1;
  }
}

class _InitCommand extends Command<int> {
  _InitCommand() {
    argParser
      ..addOption(
        'path',
        abbr: 'p',
        defaultsTo: 'lib',
        help: 'Directory to scan for @JsonSerializable models.',
      )
      ..addFlag(
        'dry-run',
        defaultsTo: false,
        negatable: false,
        help: 'Preview changes without writing to disk.',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        defaultsTo: false,
        help:
            'Show files that were skipped because they are already configured.',
      );
  }

  @override
  String get name => 'init';

  @override
  String get description =>
      'Annotate models and part directives automatically.';

  @override
  Future<int> run() async {
    final dryRun = argResults!['dry-run'] as bool;
    final targetDir = argResults!['path'] as String;
    final verbose = argResults!['verbose'] as bool;
    final projectRoot = Directory.current.path;

    final report = await runInit(
      InitOptions(
        projectRoot: projectRoot,
        targetDirectory: targetDir,
        applyChanges: !dryRun,
        verbose: verbose,
      ),
    );

    if (report.changes.isEmpty) {
      stdout.writeln('Nothing to update. All models are already configured.');
    } else {
      stdout.writeln(
        dryRun
            ? 'The following files would be updated:'
            : 'Updated models with safe parsing support:',
      );
      for (final change in report.changes) {
        final updates = <String>[];
        if (change.addedAnnotation) {
          updates.add('@SafeJsonParsing()');
        }
        if (change.addedPartDirective) {
          updates.add('part directive');
        }
        stdout.writeln('  • ${change.path} (${updates.join(' + ')})');
      }

      if (dryRun) {
        stdout.writeln('\nRe-run without --dry-run to apply these updates.');
      }
    }

    if (verbose && report.skippedPaths.isNotEmpty) {
      stdout.writeln('\nSkipped files:');
      for (final path in report.skippedPaths) {
        stdout.writeln('  - $path');
      }
    }

    stdout.writeln(
      '\nNext steps: run `dart run build_runner build` to regenerate safe parsers.',
    );

    return 0;
  }
}
