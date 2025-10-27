import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation_tools/json_annotation_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Annotation Tools Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const JsonToolsDemo(),
    );
  }
}

class JsonToolsDemo extends StatefulWidget {
  const JsonToolsDemo({super.key});

  @override
  State<JsonToolsDemo> createState() => _JsonToolsDemoState();
}

class _JsonToolsDemoState extends State<JsonToolsDemo> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<DemoPage> _pages = [
    DemoPage(
      title: '🔍 Clear Error Messages',
      subtitle: 'See the dramatic difference',
      color: Colors.red.shade100,
    ),
    DemoPage(
      title: '💡 Smart Suggestions',
      subtitle: 'Fuzzy matching for typos',
      color: Colors.blue.shade100,
    ),
    DemoPage(
      title: '🌐 Real-World API',
      subtitle: 'Handle problematic responses',
      color: Colors.green.shade100,
    ),
    DemoPage(
      title: '⚡ Convenience Methods',
      subtitle: 'Type-safe parsing made easy',
      color: Colors.orange.shade100,
    ),
    DemoPage(
      title: '🛡️ Advanced Features',
      subtitle: 'Validation and structure analysis',
      color: Colors.purple.shade100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('JSON Annotation Tools Demo'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Page indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildErrorMessagesDemo(),
                _buildSmartSuggestionsDemo(),
                _buildRealWorldApiDemo(),
                _buildConvenienceMethodsDemo(),
                _buildAdvancedFeaturesDemo(),
              ],
            ),
          ),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _currentPage < _pages.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessagesDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('🔍 Clear Error Messages', Colors.red.shade100),
          const SizedBox(height: 16),
          _buildComparisonCard(
            title: '❌ Standard JSON Parsing',
            subtitle: 'Cryptic error messages',
            code: '''final json = {'age': '25'}; // String instead of int
final age = json['age'] as int; // What fails?''',
            error: "type 'String' is not a subtype of type 'int'",
            errorColor: Colors.red.shade50,
          ),
          const SizedBox(height: 16),
          _buildComparisonCard(
            title: '✅ Safe JSON Parsing',
            subtitle: 'Crystal clear debugging info',
            code: '''final json = {'age': '25'};
final age = json.getSafeInt('age');''',
            error: '''❌ Error parsing key 'age':
   Expected: int
   Got: String
   Value: 25

💡 Common fix: The API returned a string instead of a number.
   Try: int.parse('25') or use a custom parser.''',
            errorColor: Colors.green.shade50,
          ),
          const SizedBox(height: 16),
          _buildTryItButton(() => _demonstrateErrorMessages()),
        ],
      ),
    );
  }

  Widget _buildSmartSuggestionsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('💡 Smart Suggestions', Colors.blue.shade100),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Fuzzy Matching for Typos',
            'When you mistype a field name, get helpful suggestions based on available keys.',
          ),
          const SizedBox(height: 16),
          _buildCodeCard('''final json = {
  'user_name': 'John Doe',
  'user_email': 'john@example.com',
  'user_age': 25,
};

// Oops, typo: 'username' instead of 'user_name'
final name = json.getSafeString('username');'''),
          const SizedBox(height: 16),
          _buildResultCard('''❌ Missing required key: 'username'
📋 Available keys: user_name, user_email, user_age
💡 Did you mean: user_name?'''),
          const SizedBox(height: 16),
          _buildTryItButton(() => _demonstrateSmartSuggestions()),
        ],
      ),
    );
  }

  Widget _buildRealWorldApiDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('🌐 Real-World API Debugging', Colors.green.shade100),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Handle Problematic API Responses',
            'When your backend returns unexpected data types, get actionable error messages you can share with your team.',
          ),
          const SizedBox(height: 16),
          _buildCodeCard('''// Problematic API response
final apiResponse = {
  'user_id': '12345',     // Should be int, got string
  'balance': '99.99',     // Should be double, got string
  'is_premium': 1,        // Should be bool, got int
  'tags': 'not_a_list',   // Should be list, got string
};

// Safe parsing with clear errors
final userId = apiResponse.getSafeInt('user_id');
final balance = apiResponse.getSafeDouble('balance');
final tags = apiResponse.getSafeList('tags', (v) => v as String);'''),
          const SizedBox(height: 16),
          _buildTryItButton(() => _demonstrateRealWorldApi()),
        ],
      ),
    );
  }

  Widget _buildConvenienceMethodsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('⚡ Convenience Methods', Colors.orange.shade100),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Type-Safe Parsing Made Easy',
            'Simple, intuitive methods for common parsing tasks with flexible input handling.',
          ),
          const SizedBox(height: 16),
          _buildCodeCard('''final json = {
  'name': 'John Doe',
  'age': 25,
  'active': true,
  'premium': 1,           // Converts to bool
  'signup': '2023-10-27T10:30:00Z',
  'last_login': 1698408600, // Unix timestamp
  'tags': ['work', 'urgent'],
};

// Type-safe convenience methods
final name = json.getSafeString('name');
final age = json.getSafeInt('age');
final isActive = json.getSafeBool('active');
final isPremium = json.getSafeBool('premium'); // 1 → true
final signup = json.getSafeDateTime('signup');
final lastLogin = json.getSafeDateTime('last_login');
final tags = json.getSafeList('tags', (v) => v as String);'''),
          const SizedBox(height: 16),
          _buildTryItButton(() => _demonstrateConvenienceMethods()),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeaturesDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('🛡️ Advanced Features', Colors.purple.shade100),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Validation & Structure Analysis',
            'Validate required keys upfront, analyze JSON structure, and parse complex nested objects safely.',
          ),
          const SizedBox(height: 16),
          _buildCodeCard('''final json = {
  'id': 123,
  'name': 'John Doe',
  'email': 'john@example.com',
  'profile': {'bio': 'Flutter dev', 'avatar': 'url'},
  'posts': [
    {'title': 'Post 1', 'likes': 10},
    {'title': 'Post 2', 'likes': 25},
  ]
};

// Validate required keys upfront
json.requireKeys(['id', 'name', 'email']);

// Get structure summary
final summary = json.getStructureSummary();

// Parse nested objects safely
final profile = json.getSafeObject('profile', Profile.fromJson);
final posts = json.getSafeObjectList('posts', Post.fromJson);'''),
          const SizedBox(height: 16),
          _buildTryItButton(() => _demonstrateAdvancedFeatures()),
        ],
      ),
    );
  }

  Widget _buildDemoHeader(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required String subtitle,
    required String code,
    required String error,
    required Color errorColor,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: errorColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: errorColor.withOpacity(0.3)),
              ),
              child: Text(
                error,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard(String code) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Code Example',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String result) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.output, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Result',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                result,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTryItButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Try It Live!'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _demonstrateErrorMessages() {
    final problematicJson = {'age': '25'};
    
    try {
      problematicJson.getSafeInt('age');
    } catch (e) {
      _showResultDialog('Clear Error Message', e.toString());
    }
  }

  void _demonstrateSmartSuggestions() {
    final json = {
      'user_name': 'John Doe',
      'user_email': 'john@example.com',
      'user_age': 25,
    };
    
    try {
      json.getSafeString('username'); // Typo
    } catch (e) {
      _showResultDialog('Smart Suggestions', e.toString());
    }
  }

  void _demonstrateRealWorldApi() {
    final apiResponse = {
      'user_id': '12345',
      'balance': '99.99',
      'is_premium': 1,
      'tags': 'not_a_list',
    };
    
    final results = <String>[];
    
    // Test user_id
    try {
      apiResponse.getSafeInt('user_id');
    } catch (e) {
      results.add('user_id error:\n${e.toString().split('\n')[0]}');
    }
    
    // Test balance
    try {
      apiResponse.getSafeDouble('balance');
    } catch (e) {
      results.add('balance error:\n${e.toString().split('\n')[0]}');
    }
    
    // Test premium (this should work)
    try {
      final premium = apiResponse.getSafeBool('is_premium');
      results.add('✅ is_premium: $premium (int → bool conversion works!)');
    } catch (e) {
      results.add('is_premium error: ${e.toString()}');
    }
    
    // Test tags
    try {
      apiResponse.getSafeList('tags', (v) => v as String);
    } catch (e) {
      results.add('tags error:\n${e.toString().split('\n')[0]}');
    }
    
    _showResultDialog('Real-World API Results', results.join('\n\n'));
  }

  void _demonstrateConvenienceMethods() {
    final json = {
      'name': 'John Doe',
      'age': 25,
      'active': true,
      'premium': 1,
      'signup': '2023-10-27T10:30:00Z',
      'last_login': 1698408600,
      'tags': ['work', 'urgent'],
    };
    
    final results = <String>[];
    
    try {
      results.add('✅ Name: ${json.getSafeString('name')}');
      results.add('✅ Age: ${json.getSafeInt('age')}');
      results.add('✅ Active: ${json.getSafeBool('active')}');
      results.add('✅ Premium: ${json.getSafeBool('premium')} (1 → true)');
      results.add('✅ Signup: ${json.getSafeDateTime('signup')}');
      results.add('✅ Last Login: ${json.getSafeDateTime('last_login')}');
      results.add('✅ Tags: ${json.getSafeList('tags', (v) => v as String)}');
      
      // Nullable methods
      results.add('✅ Optional Email: ${json.getNullableSafeString('email')}');
      
    } catch (e) {
      results.add('Error: ${e.toString()}');
    }
    
    _showResultDialog('Convenience Methods Results', results.join('\n'));
  }

  void _demonstrateAdvancedFeatures() {
    final json = {
      'id': 123,
      'name': 'John Doe',
      'email': 'john@example.com',
      'profile': {'bio': 'Flutter developer', 'avatar_url': 'https://example.com/avatar.jpg'},
      'posts': [
        {'title': 'First Post', 'likes': 10},
        {'title': 'Second Post', 'likes': 25},
      ]
    };
    
    final results = <String>[];
    
    try {
      // Validate keys
      json.requireKeys(['id', 'name', 'email']);
      results.add('✅ All required keys present');
      
      // Structure summary
      final summary = json.getStructureSummary();
      results.add('📊 Structure: ${summary.substring(0, 50)}...');
      
      // Parse nested objects
      final profile = json.getSafeObject('profile', (data) => {
        'bio': data.getSafeString('bio'),
        'avatar': data.getSafeString('avatar_url'),
      });
      results.add('✅ Profile: ${profile['bio']}');
      
      final posts = json.getSafeObjectList('posts', (data) => {
        'title': data.getSafeString('title'),
        'likes': data.getSafeInt('likes'),
      });
      results.add('✅ Posts: ${posts.length} posts found');
      
      final totalLikes = posts.fold(0, (sum, post) => sum + (post['likes'] as int));
      results.add('📈 Total likes: $totalLikes');
      
    } catch (e) {
      results.add('Error: ${e.toString()}');
    }
    
    _showResultDialog('Advanced Features Results', results.join('\n'));
  }

  void _showResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                content,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: content));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard!')),
                );
              },
              child: const Text('Copy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class DemoPage {
  final String title;
  final String subtitle;
  final Color color;

  DemoPage({
    required this.title,
    required this.subtitle,
    required this.color,
  });
}