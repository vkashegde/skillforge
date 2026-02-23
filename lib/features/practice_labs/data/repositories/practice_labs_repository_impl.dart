import '../../domain/entities/problem_entity.dart';
import '../../domain/repositories/practice_labs_repository.dart';
import '../models/problem_model.dart';

/// Implementation of PracticeLabsRepository
/// For now, returns hardcoded data. Later, this will connect to backend.
class PracticeLabsRepositoryImpl implements PracticeLabsRepository {
  @override
  Future<ProblemEntity> getProblem(String problemId) async {
    // For now, return hardcoded binary search problem
    // Later, this will fetch from backend/API
    if (problemId == 'binary-search') {
      return _getBinarySearchProblem();
    }
    throw Exception('Problem not found: $problemId');
  }

  @override
  Future<List<ProblemEntity>> getAllProblems() async {
    // For now, return single hardcoded problem
    // Later, this will fetch from backend/API
    return [_getBinarySearchProblem()];
  }

  @override
  Future<bool> submitSolution(String problemId, String code, String language) async {
    // For now, just return true
    // Later, this will submit to backend/API
    return true;
  }

  /// Hardcoded binary search problem
  ProblemEntity _getBinarySearchProblem() {
    return const ProblemModel(
      id: 'binary-search',
      title: '704. Binary Search',
      description: '''
Given an array of integers nums which is sorted in ascending order, and an integer target, write a function to search target in nums. If target exists, then return its index. Otherwise, return -1.

You must write an algorithm with O(log n) runtime complexity.
''',
      examples: [
        'Input: nums = [-1,0,3,5,9,12], target = 9\nOutput: 4\nExplanation: 9 exists in nums and its index is 4',
        'Input: nums = [-1,0,3,5,9,12], target = 2\nOutput: -1\nExplanation: 2 does not exist in nums so return -1',
      ],
      constraints: [
        '1 <= nums.length <= 10^4',
        '-10^4 < nums[i], target < 10^4',
        'All the integers in nums are unique.',
        'nums is sorted in ascending order.',
      ],
      tags: ['Array', 'Binary Search'],
      difficulty: 'Easy',
      starterCodeByLanguage: {
        'javascript': '''function main() {
    console.log("Hi");
}''',
        'dart': '''void main() {
    print("Hi");
}''',
      },
      testCases: [
        TestCase(
          input: 'nums = [-1,0,3,5,9,12], target = 9',
          expectedOutput: '4',
          explanation: '9 exists in nums at index 4',
        ),
        TestCase(
          input: 'nums = [-1,0,3,5,9,12], target = 2',
          expectedOutput: '-1',
          explanation: '2 does not exist in nums',
        ),
        TestCase(
          input: 'nums = [5], target = 5',
          expectedOutput: '0',
          explanation: 'Single element array',
        ),
      ],
      hint: 'Think about the properties of a sorted array. How can you eliminate half of the search space in each iteration?',
      acceptanceRate: 55,
      totalSubmissions: 1200000,
    );
  }
}
