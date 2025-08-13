import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(isLoading: true, token: null)) {
    on<LoadToken>((event, emit) async {
      final token = await AuthStorage.getToken();
      emit(AppState(isLoading: false, token: token));
    });

    // Dispatch LoadToken event immediately
    add(LoadToken());
  }
}
