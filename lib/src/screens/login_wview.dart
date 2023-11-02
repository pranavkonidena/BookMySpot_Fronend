import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final _initialdataProvider = FutureProvider<String>((ref) async {
  Uri uri = ref.watch(uriProvider);
  if (!uri.toString().contains("channeli")) {
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body).toString();
      return token;
    } else {
      return "failed";
    }
  } else {
    return "not done";
  }
});

const snackBar = SnackBar(
  content: Text('Error while logging u in, please try later'),
);

final statusProvider = StateProvider<int>((ref) {
  return 1;
});

class WebViewLogin extends ConsumerStatefulWidget {
  const WebViewLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends ConsumerState<WebViewLogin> {
  initState() {
    ref.refresh(statusProvider);
    ref.refresh(_initialdataProvider);
    ref.refresh(uriProvider);
  }

  @override
  Widget build(BuildContext context) {
    final countProvider = StateProvider<int>((ref) {
      return 0;
    });

    final uri = ref.watch(uriProvider);
    var uriasString = uri.toString();
    AsyncValue<String> token = ref.watch(_initialdataProvider);
    token.when(loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }, error: (err, stack) {
      return const Text("Error occoured");
    }, data: (token) {
      print(token);
      if (token != "not done") {
        if (token.toString() != "failed") {
          Future.microtask(() => {saveToken(token), context.go("/")});
        } else {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.go("/login");
            ref.refresh(_initialdataProvider);
            ref.refresh(uriProvider);
            ref.refresh(statusProvider);
          });
        }
      }
    });
    return Scaffold(
      body: uriasString.contains("channeli")
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(omniportURL),
              ),
              onUpdateVisitedHistory: (_, uri, __) async {
                if (uri != null) {
                  if (!uri.toString().contains("channeli")) {
                    ref.read(uriProvider.notifier).state = uri;
                    ref.read(countProvider.notifier).state++;
                  }
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
