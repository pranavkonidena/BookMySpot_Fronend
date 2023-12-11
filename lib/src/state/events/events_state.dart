import 'package:book_my_spot_frontend/src/models/event.dart';
import 'package:book_my_spot_frontend/src/services/storage_manager.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EventNotifier extends StateNotifier<List<AmenityEvent>> {
  EventNotifier() : super([]);

  Future<List<AmenityEvent>?> fetchallEvents(WidgetRef ref) async {
    var token = StorageManager.getAdminToken().toString();
    Response response = await HttpHelper.makeRequest(
        RequestTypes.get, RequestGroup.event, "getAll?id=$token");
    var data = response.data;
    for (int i = 0; i < data.length; i++) {
      final outputFormat = DateFormat("d MMM''yy HH:mm");
      data[i]["time_of_occourence_start"] =
          DateTime.parse(data[i]["time_of_occourence_start"]);
      data[i]["time_of_occourence_start"] =
          outputFormat.format(data[i]["time_of_occourence_start"]);
      data[i]["time_of_occourence_end"] =
          DateTime.parse(data[i]["time_of_occourence_end"]);
      data[i]["time_of_occourence_end"] =
          outputFormat.format(data[i]["time_of_occourence_end"]);
    }

    List<AmenityEvent> list = [];
    for (int i = 0; i < data.length; i++) {
      AmenityEvent e = AmenityEvent();
      e = await e.fromJson(data[i], ref);
      list.add(e);
    }
    state = list;
    return list;
  }

  AmenityEvent? getEventDetails(int id) {
    for (AmenityEvent event in state) {
      if (event.id == id) {
        return event;
      }
    }
    return null;
  }
}

final eventsProviderFinal =
    StateNotifierProvider<EventNotifier, List<AmenityEvent>>((ref) {
  return EventNotifier();
});
