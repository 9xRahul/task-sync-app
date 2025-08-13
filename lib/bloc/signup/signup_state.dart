part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final bool loading;
  final bool error;
  final String message;
  final bool isEmailVerified;
  final bool verificationLoading;

  SignupState({
    this.loading = false,
    this.error = false,
    this.message = "",
    this.isEmailVerified = false,
    this.verificationLoading = false,
  });

  @override
  List<Object> get props => [loading, error, message, isEmailVerified];

  SignupState copyWith({
    bool? loading,
    bool? error,
    String? message,
    bool? isEmailVerified,
    bool? verificationLoading,
  }) {
    return SignupState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      message: message ?? this.message,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      verificationLoading: verificationLoading ?? this.verificationLoading,
    );
  }
}
