part of 'signin_bloc.dart';

class SigninState extends Equatable {
  final bool loading;
  final bool error;
  final String message;
  final bool isResettingPassword;
  final String passwordResettoken;
  final bool buttonIsLoading;
  final String authToken;

  SigninState({
    this.loading = false,
    this.error = false,
    this.message = "",
    this.isResettingPassword = false,
    this.passwordResettoken = "",
    this.buttonIsLoading = false,
    this.authToken = "",
  });

  @override
  List<Object> get props => [
    loading,
    error,
    message,
    isResettingPassword,
    passwordResettoken,
    buttonIsLoading,
    authToken,
  ];
  SigninState copyWith({
    bool? loading,
    bool? error,
    String? message,
    bool? isResettingPassword,
    String? passwordResettoken,
    bool? buttonIsLoading,
    String? authToken,
  }) {
    return SigninState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message,
      isResettingPassword: isResettingPassword ?? this.isResettingPassword,
      passwordResettoken: passwordResettoken ?? this.passwordResettoken,
      buttonIsLoading: buttonIsLoading ?? this.buttonIsLoading,
      authToken: authToken ?? this.authToken,
    );
  }
}
