import 'package:dartz/dartz.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/topic_repository.dart';
import '../models/topic_model.dart';

/// Topic repository implementation
class TopicRepositoryImpl implements TopicRepository {
  @override
  Future<Either<Failure, List<TopicEntity>>> getTopics({
    String? category,
    String? difficulty,
    bool? publishedOnly,
  }) async {
    try {
      var query = supabase.from('topics').select();

      if (publishedOnly ?? true) {
        query = query.eq('is_published', true);
      }

      if (category != null) {
        query = query.eq('category', category);
      }

      if (difficulty != null) {
        query = query.eq('difficulty', difficulty);
      }

      final response = await query.order('order_index', ascending: true);

      final topics = (response as List)
          .map((json) => TopicModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();

      return Right(topics);
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TopicEntity?>> getTopicBySlug(String slug) async {
    try {
      final response = await supabase
          .from('topics')
          .select()
          .eq('slug', slug)
          .eq('is_published', true)
          .maybeSingle();

      if (response == null) {
        return const Right(null);
      }

      final model = TopicModel.fromJson(response);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TopicEntity?>> getTopicById(String id) async {
    try {
      final response = await supabase
          .from('topics')
          .select()
          .eq('id', id)
          .eq('is_published', true)
          .maybeSingle();

      if (response == null) {
        return const Right(null);
      }

      final model = TopicModel.fromJson(response);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TopicEntity>>> getTopicsByCategory(
      String category) async {
    return getTopics(category: category, publishedOnly: true);
  }
}
