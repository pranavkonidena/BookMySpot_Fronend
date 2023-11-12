import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/profile/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/screens/loading/loading_screen.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/state/bookings/booking_state.dart';
import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/error_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import '../../../services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/string_extension.dart';
import '../../../models/user.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isCalendarOpen = false;
  DateTime _selectedDay = DateTime.now();
  String year = "";

  @override
  void initState() {
    String token = getToken();
    if (token == "null") {
      context.go("/login");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ErrorManager.errorHandler(ref, context);
    final date = ref.watch(dateProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    List<Widget> bodyWidgets = [];
    List<AppBar> appBarWidgets = [];
    appBarWidgets.add(
      AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leadingWidth: 220,
        leading: Padding(
          padding: const EdgeInsets.only(left: 22.0, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date.date.toString(),
                style: const TextStyle(
                  color: Color.fromRGBO(37, 42, 52, 1),
                  fontSize: 30,
                  fontFamily: 'Thasadith',
                ),
              ),
              Text(
                date.day.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Thasadith',
                ),
              ),
            ],
          ),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isCalendarOpen = !isCalendarOpen;
                      });
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    iconSize: 30,
                    color: Colors.grey.shade700),
              )
            ],
          )
        ],
      ),
    );
    appBarWidgets.add(
      AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leadingWidth: 220,
        title: const Text(
          "Make a Reservation",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
      ),
    );
    appBarWidgets.add(AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 12,
      elevation: 0,
      backgroundColor: const Color.fromARGB(168, 35, 187, 233),
      actions: [
        TextButton(
          onPressed: () {
            context.go("/grpcreate/home");
          },
          child: const Text(
            "New team",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Thasadith',
            ),
          ),
        )
      ],
      title: const Text(
        "Teams",
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontFamily: 'Thasadith',
        ),
      ),
    ));
    appBarWidgets.add(AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 12,
      elevation: 0,
      backgroundColor: const Color.fromARGB(168, 35, 187, 233),
      leadingWidth: 220,
      title: const Text(
        "Profile",
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontFamily: 'Thasadith',
        ),
      ),
    ));
    bodyWidgets.add(
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 48, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Bookings",
                style: TextStyle(
                  color: Color.fromRGBO(25, 23, 23, 1),
                  fontSize: 35,
                  fontFamily: 'Thasadith',
                  fontWeight: FontWeight.w400,
                  height: 0.03,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 32,
              ),
              Visibility(
                  visible: isCalendarOpen,
                  child: TableCalendar(
                    focusedDay: _selectedDay,
                    firstDay: DateTime(2023, 10, 1),
                    lastDay: DateTime.now().add(const Duration(days: 7)),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        ref.read(focusedProvider.notifier).state = focusedDay;
                        setState(() {
                          isCalendarOpen = false;
                          _selectedDay = selectedDay;
                        });
                      }
                    },
                  )),
              const BookingsListView(),
            ],
          ),
        ),
      ),
    );
    bodyWidgets.add(const MakeReservationPage());
    bodyWidgets.add(const TeamScreen());
    bodyWidgets.add(const ProfileScreen());

    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
      appBar: appBarWidgets[currentIndex],
      body: currentIndex == 0
          ? SingleChildScrollView(child: bodyWidgets[currentIndex])
          : bodyWidgets[currentIndex],
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BookingsListView extends ConsumerWidget {
  const BookingsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<Booking>?> bookings =
        ref.watch(userBookingsProvider.notifier).getUserBookings(context, ref);
    Future<User> futureUser = ref.watch(userFutureProvider.future);
    futureUser.then(
      (value) {
        ref.read(userProvider.notifier).state = value;
      },
    );
    Widget bookingsWidget;
    return FutureBuilder(
      future: bookings,
      builder: (context, userBookings) {
        if (userBookings.hasData) {
          List<Booking> bookings = userBookings.data as List<Booking>;
          if ((bookings).isEmpty) {
            bookingsWidget = const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Text(
                "Go, get some bookings to see them here!",
                style: TextStyle(
                  fontFamily: "Thasadith",
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            bookingsWidget = ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 30,
                );
              },
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ref.read(groupidProvider.notifier).state =
                        bookings[index].id;
                    ref.read(dataIndexProvider.notifier).state =
                        bookings[index].id;
                    if (bookings[index].type == "individual") {
                      context.go("/booking/individual/${bookings[index].id}");
                    } else {
                      context.go("/booking/group/${bookings[index].id}");
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    color: const Color.fromRGBO(247, 230, 196, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                                "https://github-production-user-asset-6210df.s3.amazonaws.com/122373207/275466089-4e5a891c-8afd-4e9b-a0da-04ff0c39687c.png",
                                height: 30)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookings[index].amenityName,
                              style: const TextStyle(
                                color: Color(0xFF606C5D),
                                fontSize: 30,
                                fontFamily: 'Thasadith',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "${bookings[index].timeOfSlot.hour}:${bookings[index].timeOfSlot.minute}-${bookings[index].endOfSlot.hour}:${bookings[index].endOfSlot.minute}",
                              style: const TextStyle(
                                color: Color(0xFF606C5D),
                                fontSize: 25,
                                fontFamily: 'Thasadith',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              bookings[index].amenityVenue,
                              style: const TextStyle(
                                color: Color(0xFF606C5D),
                                fontSize: 15,
                                fontFamily: 'Thasadith',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        const VerticalDivider(
                          color: Color(0xFF606C5D),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bookings[index].type.toString().capitalize(),
                              style: const TextStyle(
                                color: Color(0xFF606C5D),
                                fontSize: 25,
                                fontFamily: 'Thasadith',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          bookingsWidget =
              const Center(child: CircularProgressIndicator.adaptive());
        }
        return bookingsWidget;
      },
    );
  }
}

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: const Color(0xFFF6F1F1)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: const Color.fromRGBO(241, 239, 239, 1),
        selectedItemColor: const Color.fromRGBO(33, 42, 62, 1),
        selectedFontSize: 0,
        unselectedItemColor: const Color.fromRGBO(113, 111, 111, 1),
        onTap: (value) {
          ref.read(currentIndexProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                // color: Color.fromRGBO(113, 111, 111, 1),
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_rounded,
              ),
              label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "")
        ],
      ),
    );
  }
}
