import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart';
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
  }
  void _loginSubmitted(LoginSubmitted event, Emitter<SigninState> emit) async {
    emit(state.copyWith(loading: true, error: false, message: ""));
    try {
      final response = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      if (response["status"] == true) {
        emit(
          state.copyWith(
            loading: false,
            error: false,
            message: response["message"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: true,
            message: response["message"],
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: true, message: e.toString()));
    }
  }

  void _updatePasswordEvent(
    UpdatePasswordEvent event,
    Emitter<SigninState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: false, message: ""));
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
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: true,
            message: response["message"],
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: true, message: e.toString()));
    }
  }

  void _resetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<SigninState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
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
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: true,
            message: response["message"],
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: true, message: e.toString()));
    }
  }
}
