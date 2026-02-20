import '../../../../core/utils/result.dart';
import '../entities/home_entity.dart';

/// Home repository interface
/// This defines the contract for data operations
abstract class HomeRepository {
  Future<Result<HomeEntity>> getHomeData();
}
