import '../entities/problem_entity.dart';

/// Repository interface for practice labs
abstract class PracticeLabsRepository {
  /// Get a problem by ID
  Future<ProblemEntity> getProblem(String problemId);

  /// Get all problems
  Future<List<ProblemEntity>> getAllProblems();

  /// Submit solution for a problem
  Future<bool> submitSolution(String problemId, String code, String language);
}
