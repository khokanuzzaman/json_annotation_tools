/// Test the amazing model generation feature
library;

import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  print('🚀 Model Generation Test\n');
  
  // Simulate a real API response from your Dio client
  final apiResponse = {
    'user_id': '12345',          // String (needs conversion to int)
    'full_name': 'John Doe',     // String
    'email_address': 'john@example.com', // String
    'is_active': 1,              // int (needs conversion to bool)
    'created_timestamp': 1698408600, // Unix timestamp 
    'profile_data': {            // Nested object
      'bio': 'Flutter developer',
      'avatar_url': 'https://example.com/avatar.jpg',
    },
    'permissions': ['read', 'write'], // List
    'balance': 99.99,            // double
    'last_login': null,          // nullable
  };
  
  print('📊 API Response:');
  print(apiResponse);
  print('\n${'=' * 70}\n');
  
  // Generate a complete Dart model from the JSON
  print('🎯 GENERATED DART MODEL:');
  print('=' * 70);
  final modelCode = apiResponse.generateModel('User');
  print(modelCode);
  
  print('\n${'=' * 70}\n');
  
  // Test property mapping analysis
  print('📊 PROPERTY MAPPING ANALYSIS:');
  print('=' * 70);
  final expectedFields = ['id', 'name', 'email', 'isActive', 'createdAt'];
  final analysis = apiResponse.analyzePropertyMapping(expectedFields);
  print(analysis);
}
