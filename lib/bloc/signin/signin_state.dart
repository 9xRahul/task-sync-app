part of 'signin_bloc.dart';

class SigninState extends Equatable {
  final bool loading;
  final bool error;
  final String message;
  final bool isResettingPassword;
  final String passwordResettoken;

  SigninState({
    this.loading = false,
    this.error = false,
    this.message = "",
    this.isResettingPassword = false,
    this.passwordResettoken = "",
  });

  @override
  List<Object> get props => [
    loading,
    error,
    message,
    isResettingPassword,
    passwordResettoken,
  ];
  SigninState copyWith({
    bool? loading,
    bool? error,
    String? message,
    bool? isResettingPassword,
    String? passwordResettoken,
  }) {
    return SigninState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message,
      isResettingPassword: isResettingPassword ?? this.isResettingPassword,
      passwordResettoken: passwordResettoken ?? this.passwordResettoken,
    );
  }
}
