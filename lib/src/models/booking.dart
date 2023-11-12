import 'user.dart';

class Booking {
  late int id;
  late String type;
  late DateTime timeOfSlot;
  late DateTime endOfSlot;
  late int durationOfBooking;
  late DateTime timestampOfBooking;
  late String amenityName;
  late String amenityVenue;
  List<User>? groupMembers;

  Future<Booking> bookingFromJson(dynamic data) async {
    Booking b = Booking();
    b.id = data["id"];
    b.type = data["type"];
    b.timeOfSlot = data["time_of_slot"];
    b.durationOfBooking = data["duration_of_booking"];
    b.timestampOfBooking = DateTime.parse(data["timestamp_of_booking"]);
    b.amenityName = data["amenity"]["name"];
    b.amenityVenue = data["amenity"]["venue"];
    b.endOfSlot =
        b.timeOfSlot.add(Duration(minutes: data["duration_of_booking"]));
    if (b.type != "individual") {
      for (int i = 0; i < data["group"]["members"].length; i++) {
        String uid = data["group"]["members"][i].toString();
        User user = User(uid);
        user = await user.userFromJSON();
        b.groupMembers?.add(user);
      }
    }

    return b;
  }
}
