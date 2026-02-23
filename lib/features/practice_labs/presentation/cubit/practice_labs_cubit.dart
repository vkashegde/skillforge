import 'package:flutter_bloc/flutter_bloc.dart';
import 'practice_labs_state.dart';
import '../../data/repositories/practice_labs_repository_impl.dart';
import '../../domain/repositories/practice_labs_repository.dart';
import '../../data/services/code_execution_service.dart';
import '../../data/services/ai_mentor_service.dart';

class PracticeLabsCubit extends Cubit<PracticeLabsState> {
  final PracticeLabsRepository _repository = PracticeLabsRepositoryImpl();

  PracticeLabsCubit() : super(PracticeLabsInitial());

  Future<void> loadProblem(String problemId) async {
    emit(PracticeLabsLoading());
    try {
      final problem = await _repository.getProblem(problemId);
      final defaultLanguage = 'javascript';
      final starterCode = problem.starterCodeByLanguage?[defaultLanguage] ??
          problem.starterCode ??
          '';

      emit(PracticeLabsLoaded(
        problem: problem,
        currentCode: starterCode,
        selectedLanguage: defaultLanguage,
        aiMessages: [
          AIMessage(
            content:
                "Hello! I'm your DSA Mentor. Stuck on the approach? I can help guide you through the solution logic.",
            isFromUser: false,
          ),
        ],
      ));
    } catch (e) {
      emit(PracticeLabsError(e.toString()));
    }
  }

  void updateCode(String code) {
    final currentState = state;
    if (currentState is PracticeLabsLoaded) {
      emit(currentState.copyWith(currentCode: code));
    }
  }

  void changeLanguage(String language) {
    final currentState = state;
    if (currentState is PracticeLabsLoaded) {
      final problem = currentState.problem;
      final newCode = problem.starterCodeByLanguage?[language] ??
          problem.starterCode ??
          '';

      emit(currentState.copyWith(
        selectedLanguage: language,
        currentCode: newCode,
      ));
    }
  }

  Future<void> runCode(String code, String language) async {
    final currentState = state;
    if (currentState is PracticeLabsLoaded) {
      emit(currentState.copyWith(isRunning: true, output: null));

      try {
        // Execute code based on language
        final output = await _executeCode(code, language, currentState.problem);
        final updatedState = currentState.copyWith(
          isRunning: false,
          output: output,
        );
        emit(updatedState);
      } catch (e) {
        final updatedState = currentState.copyWith(
          isRunning: false,
          output: 'Error: ${e.toString()}',
        );
        emit(updatedState);
      }
    }
  }

  Future<String> _executeCode(
      String code, String language, problem) async {
    return CodeExecutionService.executeCode(code, language, problem);
  }

  Future<void> askAIMentor(String question) async {
    final currentState = state;
    if (currentState is PracticeLabsLoaded) {
      // Add user message
      final updatedMessages = [
        ...currentState.aiMessages,
        AIMessage(content: question, isFromUser: true),
      ];

      emit(currentState.copyWith(aiMessages: updatedMessages));

      try {
        // Call Gemini AI service
        final aiResponse = await AIMentorService.getAIResponse(
          question,
          currentState.problem,
          updatedMessages,
        );
        
        final finalMessages = [
          ...updatedMessages,
          AIMessage(content: aiResponse, isFromUser: false),
        ];

        emit(currentState.copyWith(aiMessages: finalMessages));
      } catch (e) {
        // On error, use a simple fallback response
        final fallbackResponse = 'I understand you\'re asking: "$question". '
            'Let me help you with that. '
            'For ${currentState.problem.title}, remember to think about the problem step by step. '
            'Would you like a hint or explanation?';
        final finalMessages = [
          ...updatedMessages,
          AIMessage(content: fallbackResponse, isFromUser: false),
        ];
        emit(currentState.copyWith(aiMessages: finalMessages));
      }
    }
  }
}
