import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/get_home_data.dart';

part 'home_state.dart';

/// Cubit for managing home page state
class HomeCubit extends Cubit<HomeState> {
  final GetHomeData getHomeData;

  HomeCubit(this.getHomeData) : super(HomeInitial());

  /// Load home data
  Future<void> loadHomeData() async {
    emit(HomeLoading());
    
    final result = await getHomeData();
    
    result.fold(
      (failure) => emit(HomeError(failure.errorMessage)),
      (entity) => emit(HomeLoaded(entity)),
    );
  }
}
