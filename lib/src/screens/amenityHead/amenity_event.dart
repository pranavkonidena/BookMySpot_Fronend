import 'package:book_my_spot_frontend/src/screens/amenityHead/amenityhead_home.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/api/amenity_api.dart';
import 'package:book_my_spot_frontend/src/utils/errors/amenity/amenity_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityEventAdd extends ConsumerStatefulWidget {
  const AmenityEventAdd({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AmenityEventAddState();
}

class _AmenityEventAddState extends ConsumerState<AmenityEventAdd> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final DateFormat _dateTimeFormat = DateFormat('y-MM-d HH:mm:ss');

  String formatDateTime(DateTime dateTime, DateTime time) {
    DateTime finalDateTime = DateTime(dateTime.year, dateTime.month,
        dateTime.day, time.hour, time.minute, time.second);
    return _dateTimeFormat.format(finalDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8, bottom: 8, right: 30),
                  child: FormBuilderTextField(
                    name: 'event_name',
                    decoration: const InputDecoration(
                        labelText: "Event's Name", icon: Icon(Icons.event)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8, bottom: 8, right: 30),
                  child: FormBuilderDateTimePicker(
                    format: DateFormat.yMMMd(),
                    initialDate: DateTime.now(),
                    name: 'start_date',
                    inputType: InputType.date, // Allow date and time selection
                    decoration: const InputDecoration(
                        labelText: 'Start Date',
                        icon: Icon(Icons.calendar_month)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8, bottom: 8, right: 30),
                  child: FormBuilderDateTimePicker(
                    format: DateFormat.yMMMd(),
                    name: 'end_date',
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    inputType: InputType.date,
                    decoration: const InputDecoration(
                        labelText: 'End Date',
                        icon: Icon(Icons.calendar_month)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8, bottom: 8, right: 30),
                  child: FormBuilderDateTimePicker(
                    name: 'start_time',
                    format: DateFormat.Hm(),
                    inputType: InputType.time,
                    initialTime: TimeOfDay.now(),
                    decoration: const InputDecoration(
                        labelText: 'Start Time', icon: Icon(Icons.access_time)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8, bottom: 8, right: 30),
                  child: FormBuilderDateTimePicker(
                    name: 'end_time',
                    format: DateFormat.Hm(),
                    initialTime: TimeOfDay.now(),
                    inputType: InputType.time,
                    decoration: const InputDecoration(
                        labelText: 'End Time', icon: Icon(Icons.access_time)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ref.read(currentIndexHeadProvider.notifier).state =
                                0;
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text("Discard")),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.saveAndValidate()) {
                              final formData = _formKey.currentState!.value;
                              final eventName = formData['event_name'];
                              final startTime =
                                  formatDateTime(formData['start_date'] , formData['start_time']);
                              final endTime =
                                  formatDateTime(formData['end_date'] , formData['end_time']);
                              var postData = {
                                "event_name": eventName.toString(),
                                "token":
                                    StorageManager.getAdminToken().toString(),
                                "time_start": startTime.toString(),
                                "time_end": endTime.toString(),
                              };
                              try {
                                await AmenityAPIEndpoint.createEvent(postData);
                                ref
                                    .read(currentIndexHeadProvider.notifier)
                                    .state = 0;
                              } on AmenityException catch (e) {
                                e.handleError(ref);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor),
                          child: Text(
                            'Create',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
