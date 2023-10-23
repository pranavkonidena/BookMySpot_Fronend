import 'dart:convert';

import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'package:go_router/go_router.dart';
final specificgrpbkngProvider = FutureProvider<dynamic>((ref) async {
  String id = ref.watch(groupidProvider).toString();
  var response = await http
      .get(Uri.parse(using + "booking/group/specificBooking?id=${id}"));
  var data = jsonDecode(response.body);
  return data;
});

class GroupBookingDetails extends ConsumerWidget {
  GroupBookingDetails(this.id, {super.key});
  String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(specificgrpbkngProvider);
    return data.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        return const SizedBox();
      },
      data: (data) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Text(data.toString()),
                ElevatedButton(
                  onPressed: () async {
                    await http.get(Uri.parse(
                        using + "booking/group/cancelSlot?booking_id=${id}"));
                    ref.refresh(dataProvider);
                    context.go("/");
                  },
                  child: Text("Cancel"))
              ],
            ),
          ),
        );
      },
    );
  }
}
