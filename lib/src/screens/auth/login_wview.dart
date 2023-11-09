import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/models/response.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/login_errors.dart';

final _initialdataProvider = FutureProvider<Response?>((ref) async {
  Uri uri = ref.watch(uriProvider);
  if (!uri.toString().contains("channeli")) {
    Response response =
        await HttpHelper.getRequest(RequestGroup.other, uri.toString());
    return Response(response.statusCode, response.data);
  } else {
    return null;
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
    final uri = ref.watch(uriProvider);
    AsyncValue<Response?> response = ref.watch(_initialdataProvider);
    response.whenData((response) {
      if (response == null) {
      } else {
        if (response.statusCode == 200) {
          saveToken(response.data);
          Future.microtask(() => context.go("/"));
        } else {
          throw new LoginError(response.data);
        }
      }
    });
    // token.when(loading: () {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }, error: (err, stack) {
    //   return const Text("Error occoured");
    // }, data: (token) {
    //   if (token != "not done") {
    //     if (token.toString() != "failed") {
    //       Future.microtask(() => {saveToken(token), context.go("/")});
    //     } else {
    //       Future.microtask(() {
    //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //         context.go("/login");
    //         ref.refresh(_initialdataProvider);
    //         ref.refresh(uriProvider);
    //         ref.refresh(statusProvider);
    //       });
    //     }
    //   }
    // });
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
