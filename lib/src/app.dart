import 'package:book_my_spot_frontend/src/theme/primary_theme.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/error_handler.dart';
import 'package:flutter/material.dart';
import 'routes/router_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bookify extends ConsumerWidget {
  const Bookify({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///The build fn returns a material app router with the theme defined and the debug banner removed 
    ///It also initializes my ErrorManagementSystem and then proceeds to move to the home screen
    return MaterialApp.router(
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        ErrorManager.errorHandler(ref, context);
        return child!;
      },
    );
  }
}
