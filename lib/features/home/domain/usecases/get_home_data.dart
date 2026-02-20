import '../../../../core/utils/result.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for getting home data
class GetHomeData {
  final HomeRepository repository;

  GetHomeData(this.repository);

  Future<Result<HomeEntity>> call() async {
    return await repository.getHomeData();
  }
}
