import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home/bookings_list.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home/bottom_nav.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/profile/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/error_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import '../../../services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leadingWidth: 220,
        leading: Padding(
          padding: const EdgeInsets.only(left: 22.0, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                date.date.toString(),
                style: Theme.of(context).appBarTheme.titleTextStyle,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
              AutoSizeText(
                date.day.toString(),
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
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
                    color: Theme.of(context).iconTheme.color,
                    iconSize: Theme.of(context).iconTheme.size,
                    ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: TextButton(
                  child: Text(
                    "Reserve",
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                  onPressed: () {
                    context.go("/new");
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
    appBarWidgets.add(AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 12,
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            context.go("/grpcreate/home");
          },
          child: Text("New team",
              style: Theme.of(context).textTheme.headlineSmall),
        )
      ],
      title: Text("Teams", style: Theme.of(context).textTheme.headlineLarge),
    ));
    appBarWidgets.add(AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 12,
      elevation: 0,
      backgroundColor: const Color.fromARGB(168, 35, 187, 233),
      leadingWidth: 220,
      title: Text(
        "Profile",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    ));
    bodyWidgets.add(SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 28, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Bookings",
                    style: Theme.of(context).textTheme.headlineLarge),
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
        ],
      ),
    ));
    bodyWidgets.add(const TeamScreen());
    bodyWidgets.add(const ProfileScreen());

    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
      appBar: appBarWidgets[currentIndex],
      body: bodyWidgets[currentIndex],
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
