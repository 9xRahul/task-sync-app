import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/models/user_model.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
    : super(
        AppState(isLoading: true, token: null, user: UserModel(), userName: ""),
      ) {
    on<LoadToken>((event, emit) async {
      final token = await AuthStorage.getToken();
      final data = await AuthStorage.getUserInfo();
      final userName = data.name;
      emit(
        AppState(
          isLoading: false,
          token: token,
          user: data,
          userName: userName ?? "",
        ),
      );
    });

    on<UpdateAppState>((event, emit) async {
      final updatedUser = event.user;
      final token = await AuthStorage.getToken();

      // Save updated user info to storage
      await AuthStorage.saveLoginData(
        loginData: updatedUser,
        token: token ?? '',
      );

      emit(state.copyWith(user: updatedUser, token: token));
    });
    add(LoadToken());
  }
}
