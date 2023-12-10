import 'dart:convert';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

const List<DropdownMenuItem> slotDurations = [
  DropdownMenuItem(child: Text('15')),
  DropdownMenuItem(child: Text('30')),
];

const List<Widget> bookingTypes = <Widget>[
  Text(
    '  Individual  ',
    style: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'Thasadith',
      fontWeight: FontWeight.w400,
    ),
  ),
  Text(
    '     Group    ',
    style: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'Thasadith',
      fontWeight: FontWeight.w400,
    ),
  ),
];

final timeProvider = StateProvider<TimeOfDay>((ref) {
  return TimeOfDay.now();
});

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
    var response = await http.get(Uri.parse("${using}amenity/getAll?id=$id"));
    var data = jsonDecode(response.body.toString());
    return data;
  }

  Future fetchSlots(WidgetRef ref) async {
    final date = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);
    final postData = {
      "amenity": id.toString(),
      "duration": duration.toString(),
      "date": "${date.year}-${date.month}-${date.day}"
    };
    if (duration != 0) {
      var response = await http.post(Uri.parse("${using}booking/getSlots"),
          body: postData);
      var data = jsonDecode(response.body.toString());
      if (data == "No Slots") {
        return [];
      } else {
        return data;
      }
    }
  }

  Future<void> selectTime(BuildContext context, WidgetRef ref) async {
    TimeOfDay? selectedTime = TimeOfDay.now();
    final TimeOfDay? pickedS = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedS != null) {
      ref.watch(timeProvider.notifier).state = pickedS;
      var slots = ref.read(slotsProviderAmenity);
      var newSlots = [];
      for (int i = 0; i < slots.length; i++) {
        var hour = int.parse(slots[i]["start_time"].toString().substring(0, 2));
        if (pickedS.hour == hour) {
          newSlots.add(slots[i]);
        }
      }
      ref.read(slotsProviderAmenity.notifier).state = newSlots;
    } else {
      var slots = ref.read(slotsProviderAmenity);
      var newSlots = [];
      for (int i = 0; i < slots.length; i++) {
        var hour = int.parse(slots[i]["start_time"].toString().substring(0, 2));

        if (TimeOfDay.now().hour == hour) {
          newSlots.add(slots[i]);
        }
      }
      ref.read(slotsProviderAmenity.notifier).state = newSlots;
    }
  }

  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    DateTime selectedDate = DateTime
        .now(); // Initial date, you can set any date you want as the initial date.
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // The earliest date that can be selected.
      lastDate: DateTime.now().add(
          const Duration(days: 7)), // The latest date that can be selected.
    );

    if (picked != null && picked != selectedDate) {
      // Handle the selected date.
      ref.read(selectedDateProvider.notifier).state = picked;
      List<dynamic> slots = await fetchSlots(ref);
      if (slots != []) {
        ref.read(slotsProviderAmenity.notifier).state = await fetchSlots(ref);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
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
            return const SpinKitFadingCircle(
              color: Color(0xff0E6BA8),
              size: 50.0,
            ); // Show a loading indicator.
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            // Data has been fetched successfully, use it in your UI.
            var data = snapshot.data;
            return Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ToggleButtonWidget(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data[0]["name"],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontFamily: 'Thasadith',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          data[0]["venue"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Thasadith',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Select Date"),
                        IconButton(
                            onPressed: () async {
                              await selectDate(context, ref);
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: Colors.grey.shade700,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Select Time"),
                        IconButton(
                            onPressed: () async {
                              await selectTime(context, ref);
                            },
                            icon: Icon(
                              Icons.access_time,
                              color: Colors.grey[700],
                            ))
                      ],
                    ),
                    DurationDropdown(id.toString()),
                    Padding(
                      padding: const EdgeInsets.only(right: 22.0, top: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                context.go("/");
                                ref.read(currentIndexProvider.notifier).state =
                                    1;
                              },
                              child: const Text("    Cancel    ")),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                var pickedSS = ref.watch(timeProvider);
                                if (pickedSS != TimeOfDay.now()) {
                                  var slots = ref.read(slotsProviderAmenity);
                                  var newSlots = [];
                                  for (int i = 0; i < slots.length; i++) {
                                    var hour = int.parse(slots[i]["start_time"]
                                        .toString()
                                        .substring(0, 2));
                                    if (pickedSS.hour == hour) {
                                      newSlots.add(slots[i]);
                                    }
                                  }
                                  ref
                                      .read(slotsProviderAmenity.notifier)
                                      .state = newSlots;
                                }

                                context.go("/checkSlots");
                              },
                              child: const Text("Check Slots"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class DurationDropdown extends ConsumerWidget {
  const DurationDropdown(this.id, {super.key});

  final String id;

  Future fetchSlots(WidgetRef ref) async {
    final date = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);
    final postData = {
      "amenity": id,
      "duration": duration.toString(),
      "date": "${date.year}-${date.month}-${date.day}",
    };

    var response =
        await http.post(Uri.parse("${using}booking/getSlots"), body: postData);
    var data = jsonDecode(response.body.toString());

    if (data == "No Slots") {
      return [];
    } else {
      return data;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // onTap: () async {
    //             ref.read(durationProvider.notifier).state = int.parse(duration);
    //             ref.read(slotsProviderAmenity.notifier).state =
    //                 await fetchSlots(ref);
    //           },

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     Wrap(
    //       direction: Axis.horizontal,
    //       children: ['15', '30', '45', '60'].map((duration) {
    //         final isSelected = int.parse(duration) == selectedDuration;
    //         return GestureDetector(

    //           child: Container(
    //             margin: EdgeInsets.only(right: 16, bottom: 20),
    //             padding: EdgeInsets.all(8),
    //             decoration: BoxDecoration(
    //               border: Border.all(
    //                 color: isSelected ? Colors.blue : Colors.grey,
    //               ),
    //               borderRadius: BorderRadius.circular(8),
    //             ),
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Checkbox(
    //                   value: isSelected,
    //                   onChanged: (bool? value) async {
    //                     if (value != null && value) {
    //                       ref.read(durationProvider.notifier).state =
    //                           int.parse(duration);
    //                       ref.read(slotsProviderAmenity.notifier).state =
    //                           await fetchSlots(ref);
    //                     }
    //                   },
    //                 ),
    //                 Text('$duration minutes'),
    //               ],
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   ],
    // );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text("Duration"),
        ),
        DropdownButton(
          items: <DropdownMenuItem>[
            DropdownMenuItem(
              value: 15,
              child: const Text('15'),
              onTap: () async {
                ref.read(durationProvider.notifier).state = 15;
                ref.read(slotsProviderAmenity.notifier).state =
                    await fetchSlots(ref);
              },
            ),
            DropdownMenuItem(
              value: 30,
              child: const Text('30'),
              onTap: () async {
                ref.read(durationProvider.notifier).state = 30;
                ref.read(slotsProviderAmenity.notifier).state =
                    await fetchSlots(ref);
              },
            ),
            DropdownMenuItem(
              value: 45,
              child: const Text('45'),
              onTap: () async {
                ref.read(durationProvider.notifier).state = 45;
                ref.read(slotsProviderAmenity.notifier).state =
                    await fetchSlots(ref);
              },
            ),
            DropdownMenuItem(
              value: 60,
              child: const Text('60'),
              onTap: () async {
                ref.read(durationProvider.notifier).state = 60;
                ref.read(slotsProviderAmenity.notifier).state =
                    await fetchSlots(ref);
              },
            ),
          ],
          onChanged: (value) async {
            ref.read(slotsProviderAmenity.notifier).state =
                await fetchSlots(ref);
          },
        ),
      ],
    );
  }
}

final boolListProvider = StateProvider<List<bool>>((ref) {
  List<bool> selectedFruits = <bool>[true, false];
  return selectedFruits;
});

class ToggleButtonWidget extends ConsumerStatefulWidget {
  const ToggleButtonWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends ConsumerState<ToggleButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final a = ref.watch(boolListProvider);
        return ToggleButtons(
          isSelected: a,
          fillColor: const Color.fromRGBO(80, 207, 246, 1),
          onPressed: (index) {
            ref.read(boolListProvider.notifier).state = [
              index == 0,
              index != 0
            ];
          },
          borderColor: Colors.black.withOpacity(0.3100000023841858),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          constraints: const BoxConstraints(
            minHeight: 50,
            minWidth: 140.0,
          ),
          children: bookingTypes,
        );
      },
    );
  }
}
