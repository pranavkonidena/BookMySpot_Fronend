import 'package:flutter/material.dart';

class GoRouteNotFoundPage extends StatelessWidget {
  const GoRouteNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Oops , we didn't find that page!"),
      ),
    );
  }
}
