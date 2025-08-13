part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupSumbitted extends SignupEvent {
  final String email;
  final String password;
  final String name;

  const SignupSumbitted({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class EmailVerify extends SignupEvent {
  final String verificationCode;

  const EmailVerify({required this.verificationCode});

  @override
  List<Object> get props => [verificationCode];
}
