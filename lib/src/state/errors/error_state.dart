import 'dart:async';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorStreamControllerProvider = StateProvider<StreamController<ErrorTypes>>((ref) {
  StreamController<ErrorTypes> controller = StreamController<ErrorTypes>.broadcast();
  return controller;
});
