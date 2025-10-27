/// Example showing how JSON Annotation Tools integrates perfectly with
/// Dio + Retrofit + json_annotation stack for bulletproof API development
library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation_tools/json_annotation_tools.dart';

part 'dio_integration_example.g.dart';

// Your typical Retrofit API client
@RestApi(baseUrl: "https://api.example.com/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/users/{id}")
  Future<User> getUser(@Path("id") int id);

  @GET("/users")
  Future<List<User>> getUsers();
}

// Your typical json_annotation model
@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final bool isActive;
  final DateTime? lastLogin;
  final UserProfile? profile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    this.lastLogin,
    this.profile,
  });

  // 🔥 KEEP YOUR EXISTING GENERATED METHOD
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 🚀 ADD BULLETPROOF SAFE PARSING METHOD
  factory User.fromJsonSafe(Map<String, dynamic> json) {
    return User(
      id: json.getSafeInt('id'),
      name: json.getSafeString('name'),
      email: json.getSafeString('email'),
      isActive: json.getSafeBool('isActive'), // Handles 0/1, "true"/"false"
      lastLogin: json.getNullableSafeDateTime('lastLogin'), // Handles multiple formats
      profile: json.getNullableSafeObject('profile', UserProfile.fromJsonSafe),
    );
  }
}

@JsonSerializable()
class UserProfile {
  final String bio;
  final String? avatarUrl;
  final List<String> tags;

  UserProfile({
    required this.bio,
    this.avatarUrl,
    required this.tags,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  // 🚀 SAFE PARSING FOR NESTED OBJECTS
  factory UserProfile.fromJsonSafe(Map<String, dynamic> json) {
    return UserProfile(
      bio: json.getSafeString('bio'),
      avatarUrl: json.getNullableSafeString('avatarUrl'),
      tags: json.getSafeList('tags', (v) => v as String),
    );
  }
}

// 🔥 ENHANCED API CLIENT WITH SAFE PARSING
class SafeApiClient {
  final ApiClient _client;

  SafeApiClient(this._client);

  /// Get user with bulletproof error handling
  Future<User> getUserSafe(int id) async {
    try {
      // Use regular Retrofit method first
      return await _client.getUser(id);
    } catch (e) {
      // If that fails, try manual parsing with detailed errors
      final dio = Dio();
      final response = await dio.get('/users/$id');
      
      try {
        return User.fromJsonSafe(response.data);
      } catch (parseError) {
        // Now you get AMAZING error messages!
        print('🚨 JSON Parsing Error:');
        print(parseError);
        rethrow;
      }
    }
  }

  /// Get users list with safe parsing
  Future<List<User>> getUsersSafe() async {
    final dio = Dio();
    final response = await dio.get('/users');
    
    final List<dynamic> jsonList = response.data;
    final List<User> users = [];
    
    for (int i = 0; i < jsonList.length; i++) {
      try {
        users.add(User.fromJsonSafe(jsonList[i]));
      } catch (e) {
        print('🚨 Error parsing user at index $i:');
        print(e);
        // Continue with other users or rethrow based on your needs
      }
    }
    
    return users;
  }
}

// 🎯 REAL-WORLD USAGE EXAMPLES
void main() async {
  // Setup your Dio with logging
  final dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ));

  final apiClient = ApiClient(dio);
  final safeApiClient = SafeApiClient(apiClient);

  // Example 1: Handle problematic API responses
  await handleProblematicApiResponse(safeApiClient);
  
  // Example 2: Debug production issues
  await debugProductionIssues(safeApiClient);
  
  // Example 3: Development with better errors
  await developmentWithBetterErrors(safeApiClient);
}

/// Example: When your backend returns unexpected data types
Future<void> handleProblematicApiResponse(SafeApiClient client) async {
  print('🔍 Example 1: Handling Problematic API Response');
  print('=' * 50);
  
  // Simulate problematic JSON response from your API
  final problematicJson = {
    'id': '123',          // Should be int, but API returned string
    'name': 'John Doe',   
    'email': 'john@example.com',
    'isActive': 1,        // Should be bool, but API returned int
    'lastLogin': '2023-10-27T10:30:00Z',
    'profile': {
      'bio': 'Flutter developer',
      'avatarUrl': null,
      'tags': 'flutter,dart', // Should be array, but got string
    }
  };

  try {
    final user = User.fromJsonSafe(problematicJson);
    print('✅ Successfully parsed user: ${user.name}');
  } catch (e) {
    print('❌ Parsing failed with clear error:');
    print(e);
    
    // Now you can:
    // 1. Immediately identify the problem
    // 2. Share specific error details with backend team
    // 3. Implement quick fixes while waiting for API fix
  }
}

/// Example: Debug production crashes with detailed info
Future<void> debugProductionIssues(SafeApiClient client) async {
  print('\n🔍 Example 2: Production Debugging');
  print('=' * 50);
  
  // Simulate production JSON that crashes standard parsing
  final productionJson = {
    'id': 456,
    'name': 'Jane Smith',
    'email': 'jane@example.com',
    'isActive': 'yes',    // Unexpected format
    'lastLogin': 1698408600, // Unix timestamp instead of ISO string
    // 'profile': missing field that should be there
  };

  try {
    final user = User.fromJsonSafe(productionJson);
    print('✅ User parsed: ${user.name}, Active: ${user.isActive}');
  } catch (e) {
    print('🚨 Production error with full context:');
    print(e);
    
    // Send to crash reporting with detailed info
    // Firebase.crashlytics.recordError(e, stackTrace, fatal: false);
  }
}

/// Example: Better development experience
Future<void> developmentWithBetterErrors(SafeApiClient client) async {
  print('\n🔍 Example 3: Development with Better Errors');
  print('=' * 50);
  
  // During development, APIs change frequently
  final devJson = {
    'id': 789,
    'username': 'developer123',  // Oops, field renamed from 'name'
    'email': 'dev@example.com',
    'active': true,              // Field renamed from 'isActive'
    'profile': {
      'biography': 'Full stack developer', // Field renamed from 'bio'
      'avatar': 'https://example.com/avatar.jpg',
      'skills': ['flutter', 'dart'], // Field renamed from 'tags'
    }
  };

  try {
    final user = User.fromJsonSafe(devJson);
    print('✅ User parsed successfully');
  } catch (e) {
    print('🔧 Development error with helpful suggestions:');
    print(e);
    
    // The error will clearly show:
    // - Which fields are missing
    // - What fields ARE available
    // - Suggestions for similar field names
    // - How to fix each issue
  }
}

// 🎯 BONUS: Dio Interceptor for automatic safe parsing
class SafeJsonInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // You could automatically validate JSON responses here
    // and log warnings for type mismatches before they cause crashes
    
    if (response.data is Map<String, dynamic>) {
      final json = response.data as Map<String, dynamic>;
      
      // Example: Validate structure and log warnings
      try {
        json.getStructureSummary(); // Gets field types summary
        print('📊 API Response Structure: ${json.getStructureSummary()}');
      } catch (e) {
        print('⚠️  Potential parsing issues detected in API response');
      }
    }
    
    super.onResponse(response, handler);
  }
}
