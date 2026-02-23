import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/practice_labs_cubit.dart';
import '../cubit/practice_labs_state.dart';
import '../widgets/problem_panel.dart';
import '../widgets/code_editor_panel.dart';
import '../widgets/ai_mentor_panel.dart';

class PracticeLabsPage extends StatelessWidget {
  final String? problemId;

  const PracticeLabsPage({
    super.key,
    this.problemId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PracticeLabsCubit()..loadProblem(problemId ?? 'binary-search'),
      child: const _PracticeLabsView(),
    );
  }
}

class _PracticeLabsView extends StatelessWidget {
  const _PracticeLabsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<PracticeLabsCubit, PracticeLabsState>(
        builder: (context, state) {
          if (state is PracticeLabsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PracticeLabsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading problem',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<PracticeLabsCubit>().loadProblem('binary-search'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PracticeLabsLoaded) {
            return Row(
              children: [
                // Left Panel - Problem Description
                SizedBox(
                  width: 400,
                  child: ProblemPanel(problem: state.problem),
                ),
                // Vertical Divider
                Container(
                  width: 1,
                  color: Colors.grey[800],
                ),
                // Center Panel - Code Editor
                Expanded(
                  child: CodeEditorPanel(
                    problem: state.problem,
                    initialCode: state.currentCode,
                    language: state.selectedLanguage,
                    onCodeChanged: (code) {
                      context.read<PracticeLabsCubit>().updateCode(code);
                    },
                    onLanguageChanged: (language) {
                      context.read<PracticeLabsCubit>().changeLanguage(language);
                    },
                    onRunCode: (code, language) {
                      context.read<PracticeLabsCubit>().runCode(code, language);
                    },
                  ),
                ),
                // Vertical Divider
                Container(
                  width: 1,
                  color: Colors.grey[800],
                ),
                // Right Panel - AI Mentor
                SizedBox(
                  width: 400,
                  child: AIMentorPanel(
                    problem: state.problem,
                    onAskQuestion: (question) {
                      context.read<PracticeLabsCubit>().askAIMentor(question);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
