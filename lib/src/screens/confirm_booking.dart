import 'dart:convert';

import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:book_my_spot_frontend/src/screens/make_reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final slotsProviderAmenity = StateProvider<List>((ref) {
  return [];
});

final idProvider = StateProvider<String?>((ref) {
  return "0";
});

final durationProvider = StateProvider<int>((ref) {
  return 15;
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class ConfirmBooking extends ConsumerWidget {
  const ConfirmBooking(this.id, {super.key});
  final String? id;

  Future fetchData() async {
    var response = await http.get(Uri.parse(using + "amenity/getAll?id=$id"));
    var data = jsonDecode(response.body.toString());
    return data;
  }

  Future fetchSlots(WidgetRef ref) async {
    final date = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);
    final post_data = {
      "amenity": id.toString(),
      "duration": duration.toString(),
      "date": "${date.year}-${date.month}-${date.day}"
    };

    var response =
        await http.post(Uri.parse(using + "booking/getSlots"), body: post_data);
    var data = jsonDecode(response.body.toString());
    if (data == "No Slots") {
      return [];
    } else {
      return data;
    }
  }

  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    DateTime selectedDate = DateTime
        .now(); // Initial date, you can set any date you want as the initial date.
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // The earliest date that can be selected.
      lastDate: DateTime.now()
          .add(Duration(days: 7)), // The latest date that can be selected.
    );

    if (picked != null && picked != selectedDate) {
      // Handle the selected date.
      ref.read(selectedDateProvider.notifier).state = picked;
      ref.read(slotsProviderAmenity.notifier).state = await fetchSlots(ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leadingWidth: 220,
        title: const Text(
          "Confirm Slot",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator.
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            // Data has been fetched successfully, use it in your UI.
            var data = snapshot.data;

            return Column(
              children: [
                Row(
                  children: [Text("Amenity :"), Text(data[0]["name"])],
                ),
                Row(
                  children: [Text("Venue :"), Text(data[0]["venue"])],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await selectDate(context, ref);
                        },
                        child: Text("Select date"))
                  ],
                ),
                Row(
                  children: [Text("SELECTED"), Text(date.toString())],
                ),
                DurationDropdown(id),
                ElevatedButton(
                    onPressed: () async {
                      if (duration == 15) {
                        ref.read(slotsProviderAmenity.notifier).state =
                            await fetchSlots(ref);
                      }
                      context.go("/test");
                    },
                    child: Text("Confirm"))
              ],
            );
          }
        },
      ),
    );
  }
}

class DurationDropdown extends ConsumerWidget {
  DurationDropdown(this.id);

  String? id;

  Future fetchSlots(WidgetRef ref) async {
    final date = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);

    final post_data = {
      "amenity": id.toString(),
      "duration": duration.toString(),
      "date": "${date.year}-${date.month}-${date.day}"
    };

    var response =
        await http.post(Uri.parse(using + "booking/getSlots"), body: post_data);
    var data = jsonDecode(response.body.toString());

    if (data == "No Slots") {
      return [];
    } else {
      return data;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedDuration = ref.watch(durationProvider);
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        DropdownButton<String>(
          value: selectedDuration.toString(),
          items: ['15', '30', '45', '60'].map((duration) {
            return DropdownMenuItem<String>(
              value: duration,
              child: Text('$duration minutes'),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null) {
              ref.read(durationProvider.notifier).state = int.parse(value);
              ref.read(slotsProviderAmenity.notifier).state =
                  await fetchSlots(ref);
            }
          },
        ),
      ],
    );
  }
}
