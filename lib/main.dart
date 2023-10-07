import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './src/app.dart';
void main() {
  runApp(ProviderScope(child: MyApp()));
}


// localhost:8000/api/user/auth/redirect