import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/repository/auth_methods.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  AuthRepository authRepository;
  SignupBloc({required this.authRepository})
    : super(
        SignupState(
          loading: false,
          error: false,
          message: '',
          isEmailVerified: false,
        ),
      ) {
    on<SignupSumbitted>(_signupSumbmitEvent);
    on<EmailVerify>(_emailVerifiedEvent);
  }

  void _emailVerifiedEvent(EmailVerify event, Emitter<SignupState> emit) async {
    try {
      emit(
        state.copyWith(
          loading: false,
          error: false,
          message: "",
          isEmailVerified: false,
          verificationLoading: true,
        ),
      );
      final response = await authRepository.verifyEmail(
        verificationCode: event.verificationCode,
      );

      if (response["status"] == true) {
        emit(
          state.copyWith(
            loading: false,
            verificationLoading: false,
            error: false,
            message: response["message"],
            isEmailVerified: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            verificationLoading: false,
            error: true,
            message: response["message"],
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          verificationLoading: false,
          error: true,
          message: e.toString(),
        ),
      );
    }
  }

  void _signupSumbmitEvent(
    SignupSumbitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: false, message: ""));
    try {
      final response = await authRepository.signup(
        email: event.email,
        password: event.password,
        name: event.name,
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
}
