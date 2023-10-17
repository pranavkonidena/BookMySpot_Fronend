import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './home.dart';
import '../models/slot.dart';
import 'package:http/http.dart' as http;

final slotsProvider = FutureProvider<Slot>((ref) async {
  var post_data = {"duration": 30, "date": "Oct 17 2023"};
  var response = await http.post(
      Uri.parse(base_url_IITR_WIFI + "booking/getSlots"),
      body: post_data);
  print(response.body.toString());
  Slot s = Slot();
  return s;
});

class MakeReservationPage extends ConsumerWidget {
  const MakeReservationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(slotsProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 18, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Make a Reservation",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Thasadith',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                  color: const Color.fromARGB(255, 96, 94, 94),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Available Slots",
              style: TextStyle(
                color: Color(0xFF606C5D),
                fontSize: 32,
                fontFamily: 'Thasadith',
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
