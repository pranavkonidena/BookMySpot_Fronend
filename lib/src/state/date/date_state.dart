import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/models/date.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';

final focusedProvider = StateProvider<DateTime>((ref) {
  DateTime focusedDay = DateTime.now();
  return focusedDay;
});

final dateProvider = Provider<Date>((ref) {
  final now = ref.watch(focusedProvider);
  String year = "";
  year += "${now.year % 100}";

  Date date = Date();
  date.date = "${now.day}th ${months[now.month]} '$year";
  date.day = days[now.weekday];
  return date;
});
