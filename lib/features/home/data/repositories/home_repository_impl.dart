import 'package:dartz/dartz.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_model.dart';

/// Implementation of HomeRepository
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<HomeEntity>> getHomeData() async {
    try {
      final model = await remoteDataSource.getHomeData();
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
