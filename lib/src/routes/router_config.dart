import 'package:book_my_spot_frontend/src/screens/baseUser/amenity_eventteams.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/amenityhead_home.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/chat_screen.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/check_slots.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/event_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/group_bookingdetails.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/group_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/group_creation.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/individual_bookingdetails.dart';
import 'package:book_my_spot_frontend/src/screens/auth/login.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams_detail.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams_page.dart';
import 'package:go_router/go_router.dart';
import '../screens/baseUser/home.dart';
import '../screens/auth/login_wview.dart';

final router = GoRouter(routes: [
  GoRoute(name: "home", path: "/", builder: (context, state) => HomeScreen()),
  GoRoute(path: "/home", builder: (context, state) => HomeScreen()),
  GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) {
        return LoginScreen();
      }),
  GoRoute(
      name: "webview",
      path: "/webview",
      builder: (context, state) => const WebViewLogin()),
  GoRoute(
      name: "loading",
      path: "/loading",
      builder: (context, state) => const WebViewLogin()),
  GoRoute(
      path: "/new", builder: (context, state) => const MakeReservationPage()),
  GoRoute(path: "/team", builder: (context, state) => const TeamScreen()),
  GoRoute(path: "/profile", builder: (context, state) => const ProfileScreen()),
  GoRoute(
    path: "/new/:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return ConfirmBooking(id);
    },
  ),
  GoRoute(
    path: "/checkSlots",
    builder: (context, state) {
      return BookingPageFinal();
    },
  ),
  GoRoute(
    path: "/booking/individual/:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return IndividualBookingDetails(id.toString());
    },
  ),
  GoRoute(
    path: "/booking/group/:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return GroupBookingDetails(id.toString());
    },
  ),
  GoRoute(
    path: "/head",
    builder: (context, state) {
      return AmenityHeadHome();
    },
  ),
  GoRoute(
    path: "/grpcreate/:fallBack",
    builder: (context, state) {
      final fallBack = '/' + state.pathParameters["fallBack"]!;

      return GroupCreatePage(fallBack);
    },
  ),
  GoRoute(
    path: "/grpbooking",
    builder: (context, state) {
      return GroupBookingFinalPage();
    },
  ),
  GoRoute(
    path: "/teamDetails:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return TeamDetails(id);
    },
  ),
  GoRoute(
    path: "/event/book",
    builder: (context, state) {
      return EventBookingPage();
    },
  ),
  GoRoute(
    path: "/head/event/teams",
    builder: (context, state) {
      return AmenityEventTeamsList();
    },
  ),
  GoRoute(
    path: "/chat/:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return ChatPage(id.toString());
    },
  ),
]);
