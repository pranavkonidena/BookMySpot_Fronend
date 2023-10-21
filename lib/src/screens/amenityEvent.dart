import 'package:book_my_spot_frontend/src/screens/amenityheadHome.dart';
import 'package:book_my_spot_frontend/src/screens/eventsList.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'package:go_router/go_router.dart';
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

  String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
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
                FormBuilderTextField(
                  name: 'event_name',
                  decoration: InputDecoration(labelText: 'Event Name'),
                ),
                FormBuilderDateTimePicker(
                  name: 'start_time',
                  inputType: InputType.both, // Allow date and time selection
                  decoration: InputDecoration(labelText: 'Start Time'),
                ),
                FormBuilderDateTimePicker(
                  name: 'end_time',
                  inputType: InputType.both, // Allow date and time selection
                  decoration: InputDecoration(labelText: 'End Time'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      print(formData);
                      final eventName = formData['event_name'];
                      final startTime = formatDateTime(formData['start_time']);
                      final endTime = formatDateTime(formData['end_time']);
                      print(eventName);
                      print(startTime);
                      print(endTime);
                      var post_data = {
                        "event_name": eventName.toString(),
                        "token": getAdminToken().toString(),
                        "time_start": startTime.toString(),
                        "time_end": endTime.toString(),
                      };
                      var response = await http.post(
                          Uri.parse(using + "amenity/head/makeEvent"),
                          body: post_data);
                      print(response.statusCode);
                      if (response.statusCode == 200) {
                        ref.refresh(eventsListProvider);
                        ref.read(currentIndexHeadProvider.notifier).state = 0;
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
