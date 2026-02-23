import 'package:equatable/equatable.dart';
import '../../domain/entities/problem_entity.dart';

abstract class PracticeLabsState extends Equatable {
  const PracticeLabsState();

  @override
  List<Object?> get props => [];
}

class PracticeLabsInitial extends PracticeLabsState {}

class PracticeLabsLoading extends PracticeLabsState {}

class PracticeLabsLoaded extends PracticeLabsState {
  final ProblemEntity problem;
  final String currentCode;
  final String selectedLanguage;
  final String? output;
  final bool isRunning;
  final List<AIMessage> aiMessages;

  const PracticeLabsLoaded({
    required this.problem,
    required this.currentCode,
    required this.selectedLanguage,
    this.output,
    this.isRunning = false,
    this.aiMessages = const [],
  });

  PracticeLabsLoaded copyWith({
    ProblemEntity? problem,
    String? currentCode,
    String? selectedLanguage,
    String? output,
    bool? isRunning,
    List<AIMessage>? aiMessages,
  }) {
    return PracticeLabsLoaded(
      problem: problem ?? this.problem,
      currentCode: currentCode ?? this.currentCode,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      output: output,
      isRunning: isRunning ?? this.isRunning,
      aiMessages: aiMessages ?? this.aiMessages,
    );
  }

  @override
  List<Object?> get props => [
        problem,
        currentCode,
        selectedLanguage,
        output,
        isRunning,
        aiMessages,
      ];
}

class PracticeLabsError extends PracticeLabsState {
  final String message;

  const PracticeLabsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AIMessage {
  final String content;
  final bool isFromUser;
  final DateTime timestamp;

  AIMessage({
    required this.content,
    required this.isFromUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
