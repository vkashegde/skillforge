import 'dart:js' as js;
import '../../domain/entities/problem_entity.dart';

/// Service for executing code in different languages
class CodeExecutionService {
  /// Execute JavaScript code
  static Future<String> executeJavaScript(String code, ProblemEntity problem) async {
    try {
      // Create a unique output array name to avoid conflicts
      final outputVarName = '__output_${DateTime.now().millisecondsSinceEpoch}';
      
      // Wrap code to capture console.log, console.error, etc.
      final wrappedCode = '''
        (function() {
          var $outputVarName = [];
          
          // Save original console methods
          var originalLog = console.log;
          var originalError = console.error;
          var originalWarn = console.warn;
          
          // Override console methods to capture output
          console.log = function() {
            var args = Array.prototype.slice.call(arguments);
            var message = args.map(function(arg) {
              if (typeof arg === 'object') {
                try {
                  return JSON.stringify(arg, null, 2);
                } catch(e) {
                  return String(arg);
                }
              }
              return String(arg);
            }).join(' ');
            $outputVarName.push(message);
            originalLog.apply(console, arguments);
          };
          
          console.error = function() {
            var args = Array.prototype.slice.call(arguments);
            var message = 'Error: ' + args.map(String).join(' ');
            $outputVarName.push(message);
            originalError.apply(console, arguments);
          };
          
          console.warn = function() {
            var args = Array.prototype.slice.call(arguments);
            var message = 'Warning: ' + args.map(String).join(' ');
            $outputVarName.push(message);
            originalWarn.apply(console, arguments);
          };
          
          try {
            // Execute user code
            $code
            
            // If main function exists, call it
            if (typeof main === 'function') {
              main();
            }
            
            // Restore original console methods
            console.log = originalLog;
            console.error = originalError;
            console.warn = originalWarn;
            
            // Return the output array
            return $outputVarName;
          } catch (e) {
            // Restore original console methods
            console.log = originalLog;
            console.error = originalError;
            console.warn = originalWarn;
            
            // Add error to output
            var errorMsg = 'Runtime Error: ' + (e.message || e.toString());
            if (e.stack) {
              errorMsg += '\\nStack: ' + e.stack;
            }
            $outputVarName.push(errorMsg);
            return $outputVarName;
          }
        })();
      ''';

      // Execute the code
      try {
        final result = js.context.callMethod('eval', [wrappedCode]);
        
        // Extract output from the result
        if (result != null) {
          final output = <String>[];
          
          // Check if result is a JsArray
          if (result is js.JsArray) {
            final length = result['length'] as int? ?? 0;
            for (var i = 0; i < length; i++) {
              final item = result[i];
              if (item != null) {
                output.add(item.toString());
              }
            }
          } else {
            // Try to convert to string
            output.add(result.toString());
          }
          
          if (output.isEmpty) {
            return 'Code executed successfully.\n(No output - add console.log() statements to see results)';
          }
          
          return output.join('\n');
        }
        
        return 'Code executed successfully.\n(No output captured)';
      } catch (e) {
        return 'Runtime Error: ${e.toString()}';
      }
    } catch (e) {
      return 'Error executing JavaScript: ${e.toString()}';
    }
  }

  /// Execute Dart code
  static Future<String> executeDart(String code, ProblemEntity problem) async {
    // Dart code execution on web is more complex
    // For now, return a placeholder
    return 'Dart code execution is not yet implemented for web platform.\n'
        'This would require a Dart VM or compilation to JavaScript.\n\n'
        'Test Case: ${problem.testCases.first.input}\n'
        'Expected: ${problem.testCases.first.expectedOutput}';
  }

  /// Execute code based on language
  static Future<String> executeCode(
    String code,
    String language,
    ProblemEntity problem,
  ) async {
    switch (language.toLowerCase()) {
      case 'javascript':
      case 'js':
        return executeJavaScript(code, problem);
      case 'dart':
        return executeDart(code, problem);
      default:
        return 'Language not supported: $language';
    }
  }
}
