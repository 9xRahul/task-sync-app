part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class LoadToken extends AppEvent {}

class UpdateAppState extends AppEvent {
  final String? token;
  final UserModel user;

  UpdateAppState({this.token, required this.user});

  @override
  List<Object> get props => [token ?? '', user];
}
