import 'package:bloc/bloc.dart';

import 'package:tasksync/bloc/privacy_policy/privacy_policy_event.dart';

part 'privacy_policy_state.dart';

class PolicyWebViewBloc extends Bloc<PolicyWebViewEvent, PolicyWebViewState> {
  PolicyWebViewBloc(String url)
    : super(PolicyWebViewState(isLoading: true, isError: false, url: url)) {
    on<LoadStarted>((event, emit) {
      emit(state.copyWith(isLoading: true, isError: false));
    });

    on<LoadFinished>((event, emit) {
      emit(state.copyWith(isLoading: false, isError: false));
    });

    on<LoadFailed>((event, emit) {
      emit(state.copyWith(isLoading: false, isError: true));
    });

    on<SetUrl>((event, emit) {
      emit(state.copyWith(url: event.url, isLoading: true, isError: false));
    });
  }
}
