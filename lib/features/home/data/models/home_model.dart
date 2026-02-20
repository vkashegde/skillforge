import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_entity.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

/// Home data model
@freezed
class HomeModel with _$HomeModel {
  const factory HomeModel() = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);
}

/// Extension to convert model to entity
extension HomeModelX on HomeModel {
  HomeEntity toEntity() {
    return const HomeEntity();
  }
}
