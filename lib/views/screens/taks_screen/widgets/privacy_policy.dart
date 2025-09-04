import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/privacy_policy/privacy_policy_bloc.dart';
import 'package:tasksync/bloc/privacy_policy/privacy_policy_event.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyWebViewPage extends StatelessWidget {
  bool isPrivacy;
  PolicyWebViewPage({super.key, required this.url, required this.isPrivacy});
  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PolicyWebViewBloc(url),
      child: _PolicyWebViewView(isPrivacy: isPrivacy),
    );
  }
}

class _PolicyWebViewView extends StatefulWidget {
  bool isPrivacy;
  _PolicyWebViewView({required this.isPrivacy});

  @override
  State<_PolicyWebViewView> createState() => _PolicyWebViewViewState();
}

class _PolicyWebViewViewState extends State<_PolicyWebViewView> {
  late final WebViewController _controller;

  NavigationDelegate _navigationDelegate(PolicyWebViewBloc bloc) {
    return NavigationDelegate(
      onPageStarted: (_) => bloc.add(LoadStarted()),
      onProgress: (_) {}, // minimal state: we don't track progress %
      onUrlChange: (_) => bloc.add(LoadStarted()), // reflect client-side nav
      onPageFinished: (_) => bloc.add(LoadFinished()),
      onWebResourceError: (error) {
        // Only mark error if the MAIN frame failed (avoid favicon/ads noise)
        if (error.isForMainFrame == true) {
          bloc.add(LoadFailed());
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebViewPlatform.instance;
    final bloc = context.read<PolicyWebViewBloc>();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(_navigationDelegate(bloc))
      ..loadRequest(Uri.parse(bloc.state.url));
  }

  Future<void> _reload() async {
    context.read<PolicyWebViewBloc>().add(LoadStarted());
    await _controller.reload();
  }

  Future<bool> _handleWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: SizeConfig().appBarFontSize,
      fontWeight: FontWeight.bold,
      color: ColorConfig.appBArIconColor,
    );

    return BlocBuilder<PolicyWebViewBloc, PolicyWebViewState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: _handleWillPop,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Top custom header (replaces AppBar)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageConfig.splashBg),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Back button (since no AppBar)
                        IconButton(
                          tooltip: 'Back',
                          icon: const Icon(Icons.arrow_back_ios),
                          color: ColorConfig.appBArIconColor,
                          onPressed: () async {
                            if (await _controller.canGoBack()) {
                              _controller.goBack();
                            } else {
                              if (mounted) Navigator.of(context).maybePop();
                            }
                          },
                        ),

                        // Title
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: textWidget(
                              text: widget.isPrivacy
                                  ? "Privacy Policy"
                                  : "About",
                              color: ColorConfig.appBArIconColor,
                              fontSize: SizeConfig().appBarFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Reload button
                        IconButton(
                          tooltip: 'Reload',
                          icon: const Icon(Icons.refresh),
                          color: ColorConfig.appBArIconColor,
                          onPressed: _reload,
                        ),
                      ],
                    ),
                  ),

                  // Body: WebView + overlays
                  Expanded(
                    child: Stack(
                      children: [
                        WebViewWidget(controller: _controller),

                        if (state.isLoading)
                          Center(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/searching.json',
                                    width: 200,
                                    height: 200,
                                    repeat: true,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (state.isError && !state.isLoading)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline, size: 48),
                                  const SizedBox(height: 12),
                                  const Text('Failed to load page'),
                                  const SizedBox(height: 16),
                                  FilledButton.icon(
                                    onPressed: _reload,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
