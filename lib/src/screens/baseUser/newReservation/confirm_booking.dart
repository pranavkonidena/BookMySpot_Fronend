import 'dart:convert';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

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
  return 0;
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
    print(post_data);
    if (duration != 0) {
      var response = await http.post(Uri.parse(using + "booking/getSlots"),
          body: post_data);
      var data = jsonDecode(response.body.toString());
      if (data == "No Slots") {
        return [];
      } else {
        print(data);
        return data;
      }
    }
  }

  Future<void> selectTime(BuildContext context, WidgetRef ref) async {
    TimeOfDay? selectedTime = TimeOfDay.now();
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked_s != null) {
      ref.watch(timeProvider.notifier).state = picked_s;
      var slots = ref.read(slotsProviderAmenity);
      var new_slots = [];
      for (int i = 0; i < slots.length; i++) {
        var hour = int.parse(slots[i]["start_time"].toString().substring(0, 2));

        print("PICKED" + picked_s.hour.toString());
        if (picked_s.hour == hour) {
          new_slots.add(slots[i]);
        }
      }
      ref.read(slotsProviderAmenity.notifier).state = new_slots;
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
      lastDate: DateTime.now()
          .add(const Duration(days: 7)), // The latest date that can be selected.
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
        actions: [
          IconButton(
              onPressed: () async {
                await selectDate(context, ref);
              },
              icon: Icon(
                Icons.calendar_month,
                color: Colors.grey.shade700,
              )),
          IconButton(
              onPressed: () {
                selectTime(context, ref);
              },
              icon: Icon(
                Icons.access_time,
                color: Colors.grey[700],
              ))
        ],
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator.
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            // Data has been fetched successfully, use it in your UI.
            var data = snapshot.data;
            final date = ref.watch(selectedDateProvider);
            final time = ref.watch(timeProvider);
            return Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ToggleButtonWidget(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 14),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Wrap(
                        children: [
                          Text(
                            "${date.day}th ${months[date.month]} ${date.year}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Thasadith',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 38.0),
                      child: DurationDropdown(id.toString()),
                    ),
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
                              child: Text("    Cancel    ")),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                var picked_s = ref.watch(timeProvider);
                                if (picked_s != TimeOfDay.now()) {
                                  var slots = ref.read(slotsProviderAmenity);
                                  var new_slots = [];
                                  for (int i = 0; i < slots.length; i++) {
                                    var hour = int.parse(slots[i]["start_time"]
                                        .toString()
                                        .substring(0, 2));
                                    if (picked_s.hour == hour) {
                                      new_slots.add(slots[i]);
                                    }
                                  }
                                  ref
                                      .read(slotsProviderAmenity.notifier)
                                      .state = new_slots;
                                }

                                context.go("/checkSlots");
                              },
                              child: Text("Check Slots"))
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
  DurationDropdown(this.id);

  final String id;

  Future fetchSlots(WidgetRef ref) async {
    final date = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);
    final post_data = {
      "amenity": id,
      "duration": duration.toString(),
      "date": "${date.year}-${date.month}-${date.day}",
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          direction: Axis.horizontal,
          children: ['15', '30', '45', '60'].map((duration) {
            final isSelected = int.parse(duration) == selectedDuration;
            return GestureDetector(
              onTap: () async {
                ref.read(durationProvider.notifier).state = int.parse(duration);
                ref.read(slotsProviderAmenity.notifier).state =
                    await fetchSlots(ref);
              },
              child: Container(
                margin: EdgeInsets.only(right: 16, bottom: 20),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) async {
                        if (value != null && value) {
                          ref.read(durationProvider.notifier).state =
                              int.parse(duration);
                          ref.read(slotsProviderAmenity.notifier).state =
                              await fetchSlots(ref);
                        }
                      },
                    ),
                    Text('$duration minutes'),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

final boolListProvider = StateProvider<List<bool>>((ref) {
  List<bool> _selectedFruits = <bool>[true, false];
  return _selectedFruits;
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
    final a = ref.watch(boolListProvider);
    return Consumer(
      builder: (context, ref, child) {
        final a = ref.watch(boolListProvider);
        return ToggleButtons(
          children: bookingTypes,
          isSelected: a,
          fillColor: Color.fromRGBO(80, 207, 246, 1),
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
        );
      },
    );
  }
}
