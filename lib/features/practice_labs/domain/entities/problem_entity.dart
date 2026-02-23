import 'package:equatable/equatable.dart';

/// Problem entity representing a coding problem
class ProblemEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> examples;
  final List<String> constraints;
  final List<String> tags;
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final String? starterCode;
  final Map<String, String>? starterCodeByLanguage; // language -> code
  final List<TestCase> testCases;
  final String? hint;
  final String? solution;
  final int? acceptanceRate;
  final int? totalSubmissions;

  const ProblemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
    required this.constraints,
    required this.tags,
    required this.difficulty,
    this.starterCode,
    this.starterCodeByLanguage,
    required this.testCases,
    this.hint,
    this.solution,
    this.acceptanceRate,
    this.totalSubmissions,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        examples,
        constraints,
        tags,
        difficulty,
        starterCode,
        starterCodeByLanguage,
        testCases,
        hint,
        solution,
        acceptanceRate,
        totalSubmissions,
      ];
}

/// Test case for a problem
class TestCase extends Equatable {
  final String input;
  final String expectedOutput;
  final String? explanation;

  const TestCase({
    required this.input,
    required this.expectedOutput,
    this.explanation,
  });

  @override
  List<Object?> get props => [input, expectedOutput, explanation];
}
