import 'package:book_my_spot_frontend/src/screens/error/404_screen.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/amenity_eventteams.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/amenityhead_home.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/chat_screen.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/check_slots.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/event_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/bookingDetails/group_bookingdetails.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/group_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/group_creation.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/bookingDetails/individual_bookingdetails.dart';
import 'package:book_my_spot_frontend/src/screens/auth/login.dart';
import 'package:book_my_spot_frontend/src/screens/loading/loading_screen.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/profile/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_detail.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/baseUser/home/home.dart';
import '../screens/auth/login_wview.dart';

final router = GoRouter(
    initialLocation: "/loadingscreen",
    errorBuilder: (context, state) {
      return GoRouteNotFoundPage();
    },
    routes: [
      GoRoute(
        path: "/initial",
        builder: (context, state) {
          return InitialScreen();
        },
      ),
      GoRoute(
          name: "home", path: "/", builder: (context, state) => HomeScreen()),
      GoRoute(
          name: "new", path: "/new", builder: (context, state) => MakeReservationPage()),
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
          path: "/new",
          builder: (context, state) => const MakeReservationPage()),
      GoRoute(path: "/team", builder: (context, state) => const TeamScreen()),
      GoRoute(
          path: "/profile", builder: (context, state) => const ProfileScreen()),
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
      GoRoute(
        path: "/loadingscreen",
        builder: (context, state) {
          return LoadingScreen();
        },
      ),
    ]);
