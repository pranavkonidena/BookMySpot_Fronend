import 'package:book_my_spot_frontend/src/screens/baseUser/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/initial_screen.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams_page.dart';
import 'package:book_my_spot_frontend/src/screens/loading/loading_screen.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:book_my_spot_frontend/src/screens/auth/login.dart';
import 'package:flutter/material.dart';
import '../../services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/string_extension.dart';
import '../../models/user.dart';
import '../../constants/constants.dart';
import '../../models/date.dart';

final _selectedProvider = StateProvider<DateTime?>((ref) {
  DateTime? _selectedDay;
  return _selectedDay;
});

final focusedProvider = StateProvider<DateTime>((ref) {
  DateTime _focusedDay = DateTime.now();
  return _focusedDay;
});

final dateProvider = Provider<Date>((ref) {
  final now = ref.watch(focusedProvider);
  String year = "";
  year += "${now.year % 100}";

  Date _date = Date();
  _date.date = "${now.day}th ${months[now.month]} '$year";
  _date.day = days[now.weekday];
  return _date;
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarStateProvider);
    final bodywidgetsProvider = Provider<List<Widget>>((ref) {
      List<Widget> l = [];
      DateTime? _focusedDay = ref.watch(focusedProvider);
      DateTime? _selectedDay = ref.watch(_selectedProvider);
      l.add(
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
                    color: Color.fromRGBO(25,23,23,1),
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
                  child: TableCalendar(
                    focusedDay: ref.watch(selectedDateProvider),
                    firstDay: DateTime(2023, 10, 1),
                    lastDay: DateTime.now().add(Duration(days: 7)),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        ref.read(calendarStateProvider.notifier).state = false;
                        ref.read(focusedProvider.notifier).state = focusedDay;
                        ref.read(_selectedProvider.notifier).state =
                            selectedDay;
                      }
                    },
                  ),
                  visible: calendarState,
                ),
                const BookingsListView(),
              ],
            ),
          ),
        ),
      );
      l.add(const MakeReservationPage());
      l.add(const TeamScreen());
      l.add(const ProfileScreen());
      return l;
    });
    final date = ref.watch(dateProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final calendarStatus = ref.watch(calendarStateProvider);
    final appBarProvider = Provider<List<AppBar>>((ref) {
      List<AppBar> l = [];
      l.add(
        AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          backgroundColor: Color.fromARGB(168, 35, 187, 233),
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
                    color: Color.fromRGBO(37,42,52,1),
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
                        ref.read(calendarStateProvider.notifier).state =
                            !calendarStatus;
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
      l.add(
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
      l.add(AppBar(
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
      l.add(AppBar(
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
      return l;
    });
    String token = getToken();
    if (token == "null") {
      return const LoginScreen();
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(234,234,234,1),
        appBar: ref.read(appBarProvider)[currentIndex],
        body: currentIndex == 0
            ? SingleChildScrollView(
                child: ref.read(bodywidgetsProvider)[currentIndex])
            : ref.read(bodywidgetsProvider)[currentIndex],
        bottomNavigationBar: const BottomNavBar(),
      );
    }
  }
}

class BookingsListView extends ConsumerWidget {
  const BookingsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userBookingsProvider);
    Future<User> futureUser = ref.watch(userFutureProvider.future);
    futureUser.then(
      (value) {
        ref.read(userProvider.notifier).state = value;
      },
    );
    return data.when(data: (value) {
      if ((value as List).isEmpty) {
        return const Padding(
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
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 30,
            );
          },
          shrinkWrap: true,
          itemCount: value.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                ref.read(groupidProvider.notifier).state = value[index]["id"];
                ref.read(dataIndexProvider.notifier).state = value[index]["id"];
                if (value[index]["type"] == "individual") {
                  context.go("/booking/individual/${value[index]["id"]}");
                } else {
                  context.go("/booking/group/${value[index]["id"]}");
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
                          value[index]["amenity"]["name"],
                          style: const TextStyle(
                            color: Color(0xFF606C5D),
                            fontSize: 30,
                            fontFamily: 'Thasadith',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${value[index]["time_of_slot"].hour}:${value[index]["time_of_slot"].minute}-${value[index]["end_time"].hour}:${value[index]["end_time"].minute}",
                          style: const TextStyle(
                            color: Color(0xFF606C5D),
                            fontSize: 25,
                            fontFamily: 'Thasadith',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          value[index]["amenity"]["venue"],
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
                          value[index]["type"].toString().capitalize(),
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
    }, error: (error, stackTrace) {
      return const SizedBox();
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: const Color(0xFFF6F1F1)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Color.fromRGBO(241, 239, 239,1),
        selectedItemColor: Color.fromRGBO(33, 42, 62, 1),
        selectedFontSize: 0,
        unselectedItemColor: Color.fromRGBO(113, 111, 111, 1),
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
