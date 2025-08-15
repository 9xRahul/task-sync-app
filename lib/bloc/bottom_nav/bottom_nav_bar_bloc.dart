import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(BottomNavBarState(bottomNavIndex: 0)) {
    on<BottomnavItemChangeEvent>(_bottomNavChange);
  }

  void _bottomNavChange(
    BottomnavItemChangeEvent event,
    Emitter<BottomNavBarState> emit,
  ) {
    try {
      emit(state.copyWith(bottomNavIndex: event.index));
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
