part of 'app_bloc.dart';

class AppState {
  final bool isLoading;
  final UserModel user;
  final String? token;
  final String userName;

  AppState({
    required this.isLoading,
    this.token,
    required this.user,
    required this.userName,
  });

  AppState copyWith({
    bool? isLoading,
    String? token,
    UserModel? user,
    String? userName,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      user: user ?? this.user,
      userName: userName ?? this.userName,
    );
  }
}
