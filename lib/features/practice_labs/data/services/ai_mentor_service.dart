import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/problem_entity.dart';
import '../../presentation/cubit/practice_labs_state.dart' show AIMessage;

/// Service for AI mentor functionality using Google Gemini REST API
class AIMentorService {
  
  /// Get API key from environment variables or constants
  static String _getApiKey() {
    // Try compile-time constant first (from --dart-define)
    const keyFromDefine = String.fromEnvironment('GEMINI_API_KEY');
    if (keyFromDefine.isNotEmpty) {
      return keyFromDefine;
    }
    
    // Fallback to .env file (for local development)
    if (kDebugMode) {
      try {
        final key = dotenv.env['GEMINI_API_KEY'];
        if (key != null && key.isNotEmpty) {
          return key;
        }
      } catch (e) {
        // dotenv not loaded yet
      }
    }
    
    return '';
  }
  
  /// Get AI response from Gemini using REST API
  static Future<String> getAIResponse(
    String question,
    ProblemEntity problem,
    List<AIMessage> conversationHistory,
  ) async {
    try {
      final apiKey = _getApiKey();
      
      if (apiKey.isEmpty) {
        if (kDebugMode) {
          print('Warning: GEMINI_API_KEY not set. AI mentor will use fallback responses.');
        }
        return _getFallbackResponse(question, problem);
      }
      
      // Build conversation context
      final systemPrompt = _buildSystemPrompt(problem);
      final conversationContext = _buildConversationContext(conversationHistory);
      
      // Create the full prompt
      final prompt = '''
$systemPrompt

$conversationContext

Student's question: $question

Provide a helpful, concise response as a DSA mentor. Focus on guiding the student without giving away the complete solution. Be encouraging and educational.
''';

      // Use REST API directly - this gives us more control
      // Try different API endpoints and model names
      final modelsToTry = [
        'gemini-1.5-flash',
        'gemini-1.5-pro',
        'gemini-pro',
      ];
      
      for (final modelName in modelsToTry) {
        try {
          final response = await _callGeminiAPI(apiKey, modelName, prompt);
          if (response.isNotEmpty) {
            return response;
          }
        } catch (e) {
          if (kDebugMode) {
            print('Model $modelName failed: $e');
          }
          continue; // Try next model
        }
      }
      
      // All models failed, use fallback
      return _getFallbackResponse(question, problem);
    } catch (e) {
      if (kDebugMode) {
        print('Error calling Gemini API: $e');
      }
      return _getFallbackResponse(question, problem);
    }
  }
  
  /// Call Gemini REST API directly
  static Future<String> _callGeminiAPI(String apiKey, String modelName, String prompt) async {
    // Try v1 API first (more stable), then v1beta as fallback
    final apiVersions = ['v1', 'v1beta'];
    
    for (final version in apiVersions) {
      try {
        final url = Uri.parse('https://generativelanguage.googleapis.com/$version/models/$modelName:generateContent?key=$apiKey');
        
        if (kDebugMode) {
          print('Trying API: $version with model: $modelName');
        }
        
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.7,
              'topK': 40,
              'topP': 0.95,
              'maxOutputTokens': 1024,
            },
          }),
        ).timeout(const Duration(seconds: 30));
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['candidates'] != null && 
              data['candidates'].isNotEmpty &&
              data['candidates'][0]['content'] != null &&
              data['candidates'][0]['content']['parts'] != null &&
              data['candidates'][0]['content']['parts'].isNotEmpty) {
            final text = data['candidates'][0]['content']['parts'][0]['text'];
            if (text != null && text.toString().isNotEmpty) {
              if (kDebugMode) {
                print('Success with API: $version, model: $modelName');
              }
              return text.toString();
            }
          }
          throw Exception('No text in response');
        } else if (response.statusCode == 404) {
          // Model not found for this API version, try next version
          if (kDebugMode) {
            print('Model $modelName not found in $version, trying next API version...');
          }
          continue;
        } else {
          throw Exception('API error: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('API $version failed for model $modelName: $e');
        }
        // If this is the last API version, rethrow
        if (version == apiVersions.last) {
          rethrow;
        }
        continue; // Try next API version
      }
    }
    
    throw Exception('All API versions failed for model $modelName');
  }
  
  /// Build system prompt with problem context
  static String _buildSystemPrompt(ProblemEntity problem) {
    return '''You are an expert DSA (Data Structures and Algorithms) mentor helping a student learn and solve coding problems.

Current Problem Details:
- Title: ${problem.title}
- Difficulty: ${problem.difficulty}
- Description: ${problem.description}
- Tags: ${problem.tags.join(', ')}

${problem.hint != null ? 'Hint: ${problem.hint}' : ''}

Your role:
- Guide students to think through problems step by step
- Provide hints and explanations without giving away complete solutions
- Explain algorithms and data structures concepts
- Help debug code logic issues
- Encourage learning and problem-solving skills

Be concise, clear, and educational. Focus on helping the student understand the approach rather than just giving answers.''';
  }
  
  /// Build conversation context from history
  static String _buildConversationContext(List<AIMessage> conversationHistory) {
    if (conversationHistory.isEmpty) {
      return '';
    }
    
    final context = conversationHistory.map((msg) {
      return (msg.isFromUser) 
          ? 'Student: ${msg.content}'
          : 'Mentor: ${msg.content}';
    }).join('\n\n');
    
    return 'Previous conversation:\n$context';
  }
  
  
  /// Fallback response when API is unavailable
  static String _getFallbackResponse(String question, ProblemEntity problem) {
    final lowerQuestion = question.toLowerCase();
    
    if (lowerQuestion.contains('hint') || lowerQuestion.contains('stuck')) {
      return problem.hint ?? 
             'Think about the problem step by step. What is the core logic you need to implement? Consider the constraints and examples provided.';
    }
    
    if (lowerQuestion.contains('explain') || lowerQuestion.contains('how')) {
      return 'Let me explain the approach:\n\n'
          '1. **Understand the problem**: Read the problem statement carefully and identify what is being asked.\n'
          '2. **Identify patterns**: Look for common algorithms or data structures that might apply.\n'
          '3. **Break it down**: Divide the problem into smaller sub-problems.\n'
          '4. **Implement**: Write your solution step by step.\n'
          '5. **Test**: Verify your solution with the given examples.\n\n'
          'Would you like me to explain any specific part in more detail?';
    }
    
    if (lowerQuestion.contains('complexity') || lowerQuestion.contains('time') || lowerQuestion.contains('space')) {
      return 'For ${problem.title}, think about:\n\n'
          '- **Time Complexity**: How many operations does your algorithm perform?\n'
          '- **Space Complexity**: How much extra memory does your solution use?\n\n'
          'Consider the constraints: ${problem.constraints.join(', ')}\n\n'
          'Would you like help analyzing the complexity of your approach?';
    }
    
    return 'I understand you\'re asking: "$question". '
        'Let me help you with that. '
        'For ${problem.title}, remember to:\n'
        '- Read the problem carefully\n'
        '- Consider the examples provided\n'
        '- Think about the most efficient approach\n\n'
        'Would you like a hint, explanation, or help with a specific part?';
  }
}
