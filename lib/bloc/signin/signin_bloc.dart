import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/repository/auth_methods.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  AuthRepository authRepository;

  SigninBloc({required this.authRepository})
    : super(
        SigninState(
          loading: false,
          error: false,
          message: "",
          isResettingPassword: false,
          passwordResettoken: "",
        ),
      ) {
    on<LoginSubmitted>(_loginSubmitted);
    on<ResetPasswordEvent>(_resetPasswordEvent);
    on<UpdatePasswordEvent>(_updatePasswordEvent);
    on<LogoutUserEvent>(_logout);
  }

  void _logout(LogoutUserEvent event, Emitter<SigninState> emit) async {
    emit(state.copyWith(logoutLoading: true));
    try {
      print("Logout triggered");
      final data = await AuthStorage.getUserInfo();
      print(data.name);
      print(" email :${data.name}");
      final response = authRepository.logoutUser(email: data.email!);
      print(response);
      emit(state.copyWith(logoutLoading: false));
    } catch (e) {}
  }

  void _loginSubmitted(LoginSubmitted event, Emitter<SigninState> emit) async {
    emit(
      state.copyWith(loading: true, error: false, message: "", authToken: ""),
    );
    try {
      final response = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      print("Login Response: $response");

      if (response["status"] == true) {
        // ✅ Store login data in SharedPreferences
        await AuthStorage.saveLoginData(
          loginData: response['user'],
          token: response['token'],
        );

        // ✅ Fetch from storage to keep consistency
        final token = await AuthStorage.getToken();
        final data = await AuthStorage.getUserInfo();

        // ✅ Update signin state

        emit(
          state.copyWith(
            loading: false,
            error: false,
            message: response["message"],
            authToken: token,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: true,
            message: response["message"],
            authToken: "",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: true,
          message: e.toString(),
          authToken: "",
        ),
      );
    }
  }

  void _updatePasswordEvent(
    UpdatePasswordEvent event,
    Emitter<SigninState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: false,
        error: false,
        message: "",
        buttonIsLoading: true,
      ),
    );
    try {
      final response = await authRepository.updatePassword(
        resetToken: state.passwordResettoken,
        newPassword: event.newPassword,
      );

      if (response["status"] == true) {
        emit(
          state.copyWith(
            loading: false,
            error: false,
            message: response["message"],
            buttonIsLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: true,
            message: response["message"],
            buttonIsLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: true,
          message: e.toString(),
          buttonIsLoading: false,
        ),
      );
    }
  }

  void _resetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<SigninState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: false,
        buttonIsLoading: true,
        error: false,
        message: "",
        passwordResettoken: "",
        isResettingPassword: false,
      ),
    );
    try {
      final response = await authRepository.resetPassword(email: event.email);
      if (response["status"] == true) {
        emit(
          state.copyWith(
            loading: false,
            error: false,
            message: response["message"],
            isResettingPassword: true,
            passwordResettoken: response["resettoken"],
            buttonIsLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: true,
            message: response["message"],
            isResettingPassword: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: true,
          message: e.toString(),
          buttonIsLoading: false,
        ),
      );
    }
  }
}
