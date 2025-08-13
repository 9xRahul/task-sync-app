part of 'app_bloc.dart';

class AppState {
  final bool isLoading;
  final String? token;

  AppState({required this.isLoading, this.token});

  AppState copyWith({bool? isLoading, String? token}) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
    );
  }
}
