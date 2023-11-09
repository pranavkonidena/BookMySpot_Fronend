import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/state/auth/auth_state.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/models/response.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/auth_helper.dart';

class WebViewLogin extends ConsumerStatefulWidget {
  const WebViewLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends ConsumerState<WebViewLogin> {
  @override
  initState() {
    ref.refresh(authTokenProvider);
    ref.refresh(uriProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uri = ref.watch(uriProvider);
    AsyncValue<Response?> response = ref.watch(authTokenProvider);
    response.whenData((response) {
      if (response == null) {
      } else {
        try {
          AuthHelper.UserAuth(response);
          Future.microtask(() => context.go("/"));
        } on AuthException catch (e) {
          e.errorHandler(context , ref);
        }
      }
    });
  
    return Scaffold(
      body: uri.toString().contains("channeli")
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(omniportURL),
              ),
              onUpdateVisitedHistory: (_, uri, __) async {
                if (uri != null) {
                  if (!uri.toString().contains("channeli")) {
                    ref.read(uriProvider.notifier).state = uri;
                  }
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

