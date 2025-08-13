part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends SigninEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class ResetPasswordEvent extends SigninEvent {
  final String email;

  ResetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class UpdatePasswordEvent extends SigninEvent {
  final String newPassword;

  UpdatePasswordEvent({required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}
