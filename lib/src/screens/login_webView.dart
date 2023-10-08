import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../services/storageManager.dart';
import './loadingScreen.dart';

class WebViewLogin extends ConsumerStatefulWidget {
  const WebViewLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends ConsumerState<WebViewLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(omniportURL),
        ),
        onUpdateVisitedHistory: (_, uri, __) async {
          if (uri != null) {
            if (!uri.toString().contains("channeli")) {
              print(uri.toString());
              await closeInAppWebView();
              if (uri.toString().contains("state")) {
                var response = await http.get(uri);
                if (response.statusCode == 200) {
                  dynamic data = jsonDecode(response.body);
                  if (data.toString() != "Error") {
                    saveToken(data);
                    print(data);
                    context.go('/');
                  } else {
                    context.go("/loading");
                  }
                }
              } else {
                context.go("/loading");
              }
            }
          }
        },
      ),
    );
  }
}
