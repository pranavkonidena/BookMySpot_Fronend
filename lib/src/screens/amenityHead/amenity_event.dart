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
                  decoration: const InputDecoration(labelText: 'Event Name'),
                ),
                FormBuilderDateTimePicker(
                  name: 'start_time',
                  inputType: InputType.both, // Allow date and time selection
                  decoration: const InputDecoration(labelText: 'Start Time'),
                ),
                FormBuilderDateTimePicker(
                  name: 'end_time',
                  inputType: InputType.both, // Allow date and time selection
                  decoration: const InputDecoration(labelText: 'End Time'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      final eventName = formData['event_name'];
                      final startTime = formatDateTime(formData['start_time']);
                      final endTime = formatDateTime(formData['end_time']);
                      var postData = {
                        "event_name": eventName.toString(),
                        "token": StorageManager.getAdminToken().toString(),
                        "time_start": startTime.toString(),
                        "time_end": endTime.toString(),
                      };
                      try {
                        await AmenityAPIEndpoint.createEvent(postData);
                        
                        ref.read(currentIndexHeadProvider.notifier).state = 0;
                      } on AmenityException catch (e) {
                        e.handleError(ref);
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
