abstract class PolicyWebViewEvent {}

class LoadStarted extends PolicyWebViewEvent {}

class LoadFinished extends PolicyWebViewEvent {}

class LoadFailed extends PolicyWebViewEvent {}

class SetUrl extends PolicyWebViewEvent {
  final String url;
  SetUrl(this.url);
}
