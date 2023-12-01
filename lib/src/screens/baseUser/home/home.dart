import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home/bookings_list.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home/bottom_nav.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home/horizontal_calendar.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/profile/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
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
    final currentIndex = ref.watch(currentIndexProvider);
    List<Widget> bodyWidgets = [];
    List<AppBar> appBarWidgets = [];
    appBarWidgets.add(
      AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        title: Text("Bookify"),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: InkWell(
          //     onTap: () {},
          //     child: Container(
          //       clipBehavior: Clip.antiAlias,
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //       ),
          //       child: Image.network(
          //         ref.watch(userProvider).profilePic,
          //         height: 56,
          //         width: 56,
          //       ),
          //     ),
          //   ),
          // ),
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
    bodyWidgets.add(Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 70, child: HorizontalDatePicker()),
        SingleChildScrollView(
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
                              ref.read(focusedProvider.notifier).state =
                                  focusedDay;
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
        ),
      ],
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
