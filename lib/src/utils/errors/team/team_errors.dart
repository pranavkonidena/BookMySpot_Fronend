import 'package:book_my_spot_frontend/src/state/errors/error_state.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamException implements Exception {
  ErrorTypes error;
  TeamException(this.error);

  void handleError(WidgetRef ref) {
    ref.watch(errorStreamControllerProvider.notifier).state.add(error);
  }
}
