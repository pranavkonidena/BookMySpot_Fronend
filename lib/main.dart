import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './src/app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  /// The main method first initializes the local storage for retrieving token details and then runs the app
  await GetStorage.init();
  runApp(const ProviderScope(child: Bookify()));
}
