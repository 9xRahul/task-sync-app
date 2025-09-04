part of 'privacy_policy_bloc.dart';

class PolicyWebViewState {
  final bool isLoading;
  final bool isError;
  final String url;

  const PolicyWebViewState({
    required this.isLoading,
    required this.isError,
    required this.url,
  });

  PolicyWebViewState copyWith({bool? isLoading, bool? isError, String? url}) {
    return PolicyWebViewState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      url: url ?? this.url,
    );
  }
}
