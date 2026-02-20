import '../models/home_model.dart';

/// Remote data source interface for home feature
abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
}

/// Implementation of HomeRemoteDataSource
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeModel> getHomeData() async {
    // TODO: Implement actual API call
    return const HomeModel();
  }
}
