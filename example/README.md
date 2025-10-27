# json_annotation_tools Example

This example demonstrates **@SafeJsonParsing() code generation** with crystal-clear enhanced error messages that eliminate cryptic JSON parsing errors.

## 🚀 Quick Start

```bash
# 1. Get dependencies
dart pub get

# 2. Generate code for @SafeJsonParsing()
dart run build_runner build

# 3. Run the example and see enhanced errors!
dart run main.dart
```

## 📋 What This Example Shows

### 🤖 **@SafeJsonParsing() Code Generation (Primary Approach):**
- `@SafeJsonParsing()` annotation auto-generates `UserSafeJsonParsing.fromJsonSafe()`
- **Enhanced error messages** built into generated methods
- **Zero runtime overhead** - all logic generated at compile time
- **Production ready** with detailed error logging

### 📱 **Manual Extension Methods (Alternative):**
- `json.getSafeInt('id')`, `json.getSafeString('name')` - no crashes on type mismatches!
- `json.getNullableSafeInt('age')` - handle nullable fields gracefully

### ✅ **Enhanced Error Messages You'll See:**
- **Type mismatches**: "Expected: int, Got: String" with copy-paste solutions
- **Missing fields**: Shows available vs missing fields with suggestions  
- **Clear diagnosis**: Exact problem identification with beginner-friendly explanations
- **Production patterns**: How to log enhanced errors for debugging

## 🎯 Expected Console Output

When you run the example, you'll see:

```
🚀 json_annotation_tools Example
==================================================

🤖 APPROACH 1: Code Generation (@SafeJsonParsing)
✅ SUCCESS: Auto-generated parsing worked!
   User: User(id: 123, name: John Doe, email: john@example.com, age: 30, isActive: true)

🔥 ERROR DEMONSTRATION: @SafeJsonParsing() Enhanced Errors
✅ CAUGHT @SafeJsonParsing() ENHANCED ERROR:
   🚨 OOPS! There's a problem with your JSON data:
   🔍 EXACT PROBLEM DIAGNOSIS:
   ❌ Field 'id' has the wrong data type
   📊 TYPE COMPARISON:
   Expected: int (whole number)
   Got: String (text)
   Value: "not-a-number"
   🔧 How to fix this (3 easy options):
   1. Fix your API to return: {"id": 123}
   2. Update your model: final String id;
   3. Add conversion: int.tryParse(json['id'])
```

## 🚀 Next Steps

- **📖 Complete Production Guide**: `../PRODUCTION_SETUP.md` - Full working examples with console logging
- **📱 Interactive Flutter Demo**: `../example_app/` - 6-page visual demo with "Try It Live!" buttons  
- **🏭 Production Setup**: Copy-paste ready patterns for real apps

Perfect for understanding how **@SafeJsonParsing()** eliminates cryptic JSON parsing errors forever! 🌟
