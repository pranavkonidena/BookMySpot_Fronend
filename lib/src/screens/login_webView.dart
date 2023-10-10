import 'dart:convert';
import 'package:book_my_spot_frontend/src/routes/router_config.dart';
import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

const snackBar = SnackBar(
  content: Text('Error while logging u in, please try later'),
);

final dataProvider = FutureProvider<String>((ref) async {
  Uri uri = ref.watch(uriProvider);
  if (!uri.toString().contains("channeli")) {
    var response = await http.get(uri);
    print(response.statusCode);
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

final statusProvider = StateProvider<int>((ref) {
  return 1;
});

final uriProvider = StateProvider<Uri>((ref) {
  return Uri.parse("channeli");
});

class WebViewLogin extends ConsumerStatefulWidget {
  const WebViewLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends ConsumerState<WebViewLogin> {
  initState() {
      ref.refresh(statusProvider);
      ref.refresh(dataProvider);
      ref.refresh(uriProvider);
      print("REFRESHED");
    } 
  @override
  Widget build(BuildContext context) {
    
    final status = ref.watch(statusProvider);
    final uri = ref.watch(uriProvider);
    var uri_as_string = uri.toString();
    // print(uri.toString());

    AsyncValue<String> token = ref.watch(dataProvider);
    token.when(loading: () {
      return const CircularProgressIndicator();
    }, error: (err, stack) {
      return Text("Error occoured");
    }, data: (token) {
      print(token);
      if (token != "not done") {
        if (token.toString() != "failed") {
          Future.microtask(() => {saveToken(token), context.go("/")});
        } else {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.go("/login");
            ref.refresh(dataProvider);
            ref.refresh(uriProvider);
            ref.refresh(statusProvider);
          });
        }
      }
    });
    return Scaffold(
      body: uri_as_string.contains("channeli")
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
          : CircularProgressIndicator(),
    );
  }
}
