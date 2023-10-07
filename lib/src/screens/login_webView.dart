import 'dart:convert';

import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WebViewLogin extends StatefulWidget {
  const WebViewLogin({super.key});

  @override
  State<WebViewLogin> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends State<WebViewLogin> {
  final ValueNotifier<int> _loadingState = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(omniportURL),
        ),
        onLoadStop: (_, uri) {
          _loadingState.value = 0;
        },
        onUpdateVisitedHistory: (_, uri, __) async {
          if (uri != null) {
            print(uri);
            if (uri.toString().startsWith(base_url_IMG + "user/auth")) {
              dynamic response = await http.get(uri);
              if (response.statusCode == 200) {
                context.go("/");
                dynamic data = jsonDecode(response.body);
                print(data);
                
              } else {
                context.go("/login");
              }
            }
          }
        },
      ),
    );
  }
}
