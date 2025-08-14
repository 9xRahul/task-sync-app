part of 'app_bloc.dart';

class AppState {
  final bool isLoading;
  final UserModel user;
  final String? token;

  AppState({required this.isLoading, this.token, required this.user});

  AppState copyWith({bool? isLoading, String? token, UserModel? user}) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}
