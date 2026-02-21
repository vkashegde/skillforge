import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/topic_entity.dart';

/// Topic repository interface
abstract class TopicRepository {
  /// Get all topics
  Future<Either<Failure, List<TopicEntity>>> getTopics({
    String? category,
    String? difficulty,
    bool? publishedOnly,
  });

  /// Get topic by slug
  Future<Either<Failure, TopicEntity?>> getTopicBySlug(String slug);

  /// Get topic by ID
  Future<Either<Failure, TopicEntity?>> getTopicById(String id);

  /// Get topics by category
  Future<Either<Failure, List<TopicEntity>>> getTopicsByCategory(String category);
}
