# JSON Annotation Tools - Examples

This directory contains practical examples demonstrating the power and effectiveness of the JSON Annotation Tools package.

## Running the Examples

```bash
# From the package root directory
cd example
dart run main.dart
```

## What You'll See

The example demonstrates five key scenarios where JSON Annotation Tools transforms your development experience:

### 1. 🔍 Clear Error Messages
**Before**: `type 'String' is not a subtype of type 'int'`  
**After**: `❌ Error parsing key 'age': expected int, but got String. Value: "25"`

### 2. 🎯 Smart Key Suggestions  
When you mistype a field name, get helpful suggestions:
```
❌ Missing required key: 'username'
📋 Available keys: user_name, user_email, user_age
💡 Did you mean: user_name?
```

### 3. 🌐 Real-World API Debugging
Handle problematic API responses with mixed types and get actionable error messages that you can immediately share with your backend team.

### 4. ⚡ Type-Safe Convenience Methods
Use simple, intuitive methods for common parsing tasks:
```dart
final name = json.getSafeString('name');
final age = json.getSafeInt('age');
final isActive = json.getSafeBool('active'); // Handles 0/1, "true"/"false", etc.
final createdAt = json.getSafeDateTime('created_at'); // ISO strings, timestamps
```

### 5. 🔧 Advanced Features
- Validate required keys upfront
- Get structure summaries for debugging
- Parse nested objects and lists safely
- Enhanced error context with field descriptions

## Key Benefits Demonstrated

- **Zero Performance Impact**: Only active during errors
- **Backward Compatible**: Works alongside existing `json_annotation` code
- **Developer Experience**: Transform debugging from hours to minutes
- **Production Ready**: Detailed logging for production error tracking
- **Flexible**: Handles various data formats commonly found in APIs

## Integration with Existing Code

The examples show how to:
1. Keep existing `fromJson` methods working
2. Add `fromJsonSafe` methods for enhanced debugging
3. Use both approaches in the same codebase
4. Gradually migrate critical models

Run the example to see the dramatic difference in error clarity and debugging speed!
