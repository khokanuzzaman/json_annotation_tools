/// Code generator for @SafeJsonParsing annotation
/// 
/// This library provides build_runner integration for automatic generation
/// of safe JSON parsing methods.
/// 
/// To use this generator, add to your `build.yaml`:
/// 
/// ```yaml
/// targets:
///   $default:
///     builders:
///       json_annotation_tools|safe_json_parsing:
///         enabled: true
/// ```
/// 
/// Or add to your `pubspec.yaml` dev_dependencies and run:
/// 
/// ```bash
/// dart run build_runner build
/// ```

library json_annotation_tools.generator;

export 'src/generator.dart';
