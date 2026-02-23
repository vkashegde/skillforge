/// Service for formatting/beautifying code
class CodeFormatterService {
  /// Format JavaScript code
  static String formatJavaScript(String code) {
    try {
      // Use JavaScript's built-in formatting via a formatter library
      // For now, implement a basic formatter
      return _formatJavaScriptBasic(code);
    } catch (e) {
      return code; // Return original code if formatting fails
    }
  }

  /// Basic JavaScript formatter
  static String _formatJavaScriptBasic(String code) {
    final lines = code.split('\n');
    final formatted = <String>[];
    int indentLevel = 0;
    const indentSize = 4;

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }

      // Decrease indent before closing braces
      if (trimmed.startsWith('}') || trimmed.startsWith(']') || trimmed.startsWith(')')) {
        indentLevel = (indentLevel - 1).clamp(0, double.infinity).toInt();
      }

      // Add indented line
      formatted.add(' ' * (indentLevel * indentSize) + trimmed);

      // Increase indent after opening braces
      if (trimmed.endsWith('{') || trimmed.endsWith('[')) {
        indentLevel++;
      }
      // Special case: if/else/for/while statements
      if (trimmed.startsWith('if ') ||
          trimmed.startsWith('else ') ||
          trimmed.startsWith('for ') ||
          trimmed.startsWith('while ') ||
          trimmed.startsWith('function ') ||
          trimmed.startsWith('const ') ||
          trimmed.startsWith('let ') ||
          trimmed.startsWith('var ')) {
        if (trimmed.endsWith('{')) {
          // Already handled above
        } else if (!trimmed.endsWith(';') && !trimmed.endsWith('}')) {
          // Might need indent on next line
        }
      }
    }

    return formatted.join('\n');
  }

  /// Format Dart code
  static String formatDart(String code) {
    try {
      // Basic Dart formatter
      return _formatDartBasic(code);
    } catch (e) {
      return code; // Return original code if formatting fails
    }
  }

  /// Basic Dart formatter
  static String _formatDartBasic(String code) {
    final lines = code.split('\n');
    final formatted = <String>[];
    int indentLevel = 0;
    const indentSize = 2; // Dart uses 2 spaces

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }

      // Decrease indent before closing braces
      if (trimmed.startsWith('}') || trimmed.startsWith(']') || trimmed.startsWith(')')) {
        indentLevel = (indentLevel - 1).clamp(0, double.infinity).toInt();
      }

      // Add indented line
      formatted.add(' ' * (indentLevel * indentSize) + trimmed);

      // Increase indent after opening braces
      if (trimmed.endsWith('{') || trimmed.endsWith('[')) {
        indentLevel++;
      }
      // Special case: if/else/for/while statements
      if (trimmed.startsWith('if ') ||
          trimmed.startsWith('else ') ||
          trimmed.startsWith('for ') ||
          trimmed.startsWith('while ') ||
          trimmed.startsWith('void ') ||
          trimmed.startsWith('int ') ||
          trimmed.startsWith('String ') ||
          trimmed.startsWith('bool ') ||
          trimmed.startsWith('List') ||
          trimmed.startsWith('final ') ||
          trimmed.startsWith('const ')) {
        if (trimmed.endsWith('{')) {
          // Already handled above
        }
      }
    }

    return formatted.join('\n');
  }

  /// Format code based on language
  static String formatCode(String code, String language) {
    switch (language.toLowerCase()) {
      case 'javascript':
      case 'js':
        return formatJavaScript(code);
      case 'dart':
        return formatDart(code);
      default:
        return code;
    }
  }
}
