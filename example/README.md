# json_annotation_tools Example

This example demonstrates how to use `json_annotation_tools` for safe JSON parsing with crystal-clear error messages.

## 🚀 Quick Start

```bash
# 1. Get dependencies
dart pub get

# 2. Run the example
dart run main.dart
```

## 📋 What This Example Shows

### ✅ **Safe JSON Parsing:**
- `json.getSafeInt('id')`, `json.getSafeString('name')` - no crashes on type mismatches!
- `json.getNullableSafeInt('age')` - handle nullable fields gracefully

### ✅ **Enhanced Error Messages:**
- Clear diagnosis of what went wrong (type mismatch vs missing field)
- Expected vs actual type comparison  
- Copy-paste ready solutions
- Beginner-friendly explanations with field name suggestions

### ✅ **Real-World Scenarios:**
- API response handling with different error types
- Production error logging patterns
- Graceful error handling strategies

## 🎯 Expected Output

When you run the example, you'll see:
- ✅ Successful parsing with safe extension methods
- 🔥 Enhanced error messages for type mismatches
- 🔥 Smart suggestions for missing fields
- 🌐 Real-world API response simulation

## 🚀 Advanced Features

For **code generation** with `@SafeJsonParsing()` annotation, see:
- `../PRODUCTION_SETUP.md` - Complete setup guide with working examples
- `../example_app/` - Interactive Flutter demo with 6 feature pages

Perfect for understanding how `json_annotation_tools` eliminates cryptic JSON parsing errors!
