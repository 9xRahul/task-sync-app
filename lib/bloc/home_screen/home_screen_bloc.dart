import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/config/app_config/enums.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenState(selectedCategoryIndex: 0)) {
    on<CategoryChangeEvent>(_categoryChangeEvent);
    on<SelectTasksWithItsStatusEvent>(_selectTaskStstus);
  }

  void _categoryChangeEvent(
    CategoryChangeEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    try {
      emit(
        state.copyWith(
          error: false,
          selectedCategoryIndex: event.categoryItemIndex,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: true));
    }
  }

  void _selectTaskStstus(
    SelectTasksWithItsStatusEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    try {
      emit(state.copyWith(taskStatus: event.taskStatus));
    } catch (e) {
      emit(state.copyWith(error: true));
    }
  }
}
