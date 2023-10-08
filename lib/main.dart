import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './src/app.dart';
import 'package:get_storage/get_storage.dart';
void main() async{
  await GetStorage.init();
  runApp(ProviderScope(child: MyApp()));
}


// localhost:8000/api/user/auth/redirect