import 'user.dart';

class Booking {
  late String type;
  late DateTime timeOfSlot;
  late int durationOfBooking;
  late DateTime timestampOfBooking;
  late String amenityName;
  late String amenityVenue;
  List<User>? groupMembers;

  bookingFromJSON(String type, DateTime timeOfSlot, int durationOfBooking,
      DateTime timestampOfBooking, Map amenity, List<User> groupMembers) {
    Booking b = Booking();
    b.type = type;
    b.timeOfSlot = timeOfSlot;
    b.durationOfBooking = durationOfBooking;
    b.timestampOfBooking = timestampOfBooking;
    b.amenityName = amenity["name"];
    b.amenityVenue = amenity["venue"];
    b.groupMembers = groupMembers;

    return b;
  }
}
