import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/check_slots.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';

class BookingAPIEndpoint {
  BookingAPIEndpoint._();

  static makeBooking(WidgetRef ref) async {
    final date = ref.watch(selectedDateProvider);
    final data = ref.watch(slotsProviderAmenity);
    if (ref.read(indexProvider) < 0) {
      throw UserException(ErrorTypes.noSlotSelected, "No slot selected");
    } else {
      var postData = {
        "id_user": getToken().toString(),
        "date": "${date.year}-${date.month}-${date.day}",
        "amenity_id": data[0]["amenity_id"].toString(),
        "start_time": data[ref.read(indexProvider)]["start_time"].toString(),
        "end_time": data[ref.read(indexProvider)]["end_time"].toString(),
        // "amenity_id" : data[]
      };
      Response response = await HttpHelper.makeRequest(RequestTypes.post,
          RequestGroup.booking, "individual/bookSlot", postData);
      if (response.statusCode == 412) {
        throw UserException(
            ErrorTypes.insufficientCredits, "Insufficient Credits");
      } else {
        if (response.statusCode == 200) {
          return response;
        } else {
          throw UserException(ErrorTypes.unknown, response.data);
        }
      }
    }
  }

  static cancelBooking(int bookingId) async {
    var deleteData = {"booking_id": bookingId.toString()};
    Response response = await HttpHelper.makeRequest(
        RequestTypes.delete, RequestGroup.booking, "individual/cancelSlot", deleteData);
    if (response.statusCode != 200) {
      throw UserException(ErrorTypes.unknown, "Unknown Error occoured!");
    }
  }
}
