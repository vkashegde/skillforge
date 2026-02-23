import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/highlight.dart' show Mode;
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart' as monokai;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/problem_entity.dart';
import '../../data/services/code_formatter_service.dart';
import '../cubit/practice_labs_cubit.dart';
import '../cubit/practice_labs_state.dart';

class CodeEditorPanel extends StatefulWidget {
  final ProblemEntity problem;
  final String initialCode;
  final String language;
  final Function(String) onCodeChanged;
  final Function(String) onLanguageChanged;
  final Function(String, String) onRunCode;

  const CodeEditorPanel({
    super.key,
    required this.problem,
    required this.initialCode,
    required this.language,
    required this.onCodeChanged,
    required this.onLanguageChanged,
    required this.onRunCode,
  });

  @override
  State<CodeEditorPanel> createState() => _CodeEditorPanelState();
}

class _CodeEditorPanelState extends State<CodeEditorPanel> {
  late CodeController _codeController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    final language = _getLanguageFromString(widget.language);
    _codeController = CodeController(
      text: widget.initialCode,
      language: language,
    );
    _codeController.addListener(() {
      // Only notify parent if controller text actually changed
      // This prevents unnecessary rebuilds
      widget.onCodeChanged(_codeController.text);
    });
  }

  @override
  void didUpdateWidget(CodeEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only recreate controller if language changes, not when code changes
    // This prevents cursor from jumping when user is editing
    if (oldWidget.language != widget.language) {
      final currentSelection = _codeController.selection;
      _codeController.dispose();
      _initializeController();
      // Try to restore cursor position if possible
      if (currentSelection.isValid) {
        // Set selection after a frame to ensure controller is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _codeController.text.length >= currentSelection.end) {
            _codeController.selection = currentSelection;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Mode? _getLanguageFromString(String language) {
    switch (language.toLowerCase()) {
      case 'javascript':
      case 'js':
        return javascript;
      case 'dart':
        return dart;
      default:
        return null;
    }
  }

  Future<void> _handleRunCode() async {
    await widget.onRunCode(_codeController.text, widget.language);
  }

  void _handleFormatCode() {
    final currentCode = _codeController.text;
    final formattedCode = CodeFormatterService.formatCode(currentCode, widget.language);
    
    // Save cursor position
    final selection = _codeController.selection;
    
    // Update code
    _codeController.text = formattedCode;
    
    // Try to restore cursor position (at least at the start)
    if (selection.isValid && formattedCode.length >= selection.start) {
      final newSelection = TextSelection.collapsed(offset: selection.start.clamp(0, formattedCode.length));
      _codeController.selection = newSelection;
    }
    
    // Notify parent of change
    widget.onCodeChanged(formattedCode);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code formatted successfully'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Language selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButton<String>(
                    value: widget.language,
                    dropdownColor: Colors.grey[900],
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'javascript', child: Text('JavaScript')),
                      DropdownMenuItem(value: 'dart', child: Text('Dart')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        widget.onLanguageChanged(value);
                      }
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const Spacer(),
                // Format/Beautify button
                IconButton(
                  onPressed: _handleFormatCode,
                  icon: const Icon(Icons.format_indent_increase, size: 20),
                  tooltip: 'Format Code',
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 4),
                // Run button
                BlocBuilder<PracticeLabsCubit, PracticeLabsState>(
                  builder: (context, state) {
                    final isRunning = state is PracticeLabsLoaded && state.isRunning;
                    return ElevatedButton.icon(
                      onPressed: isRunning ? null : _handleRunCode,
                      icon: isRunning
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.play_arrow, size: 20),
                      label: Text(isRunning ? 'Running...' : 'Run Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Submit button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement submit functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Submit functionality coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
          // Code Editor
          Expanded(
            child: CodeTheme(
              data: CodeThemeData(styles: monokai.monokaiSublimeTheme),
              child: CodeField(
                controller: _codeController,
                textStyle: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                gutterStyle: const GutterStyle(
                  showLineNumbers: true,
                  showErrors: false,
                  showFoldingHandles: false,
                ),
              ),
            ),
          ),
          // Output Panel
          BlocBuilder<PracticeLabsCubit, PracticeLabsState>(
            builder: (context, state) {
              if (state is PracticeLabsLoaded) {
                final hasOutput = state.output != null || state.isRunning;
                if (!hasOutput) return const SizedBox.shrink();

                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.terminal, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Output',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: state.isRunning
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : SingleChildScrollView(
                                  child: Text(
                                    state.output ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
