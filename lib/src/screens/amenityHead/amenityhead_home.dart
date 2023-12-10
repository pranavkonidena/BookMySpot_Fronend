import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/amenity_event.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/events_list.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/amenity_profile.dart';
import 'package:book_my_spot_frontend/src/screens/loading/loading_widget.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/state/amenityhead/amenityhead_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/amenity_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmenityHeadHome extends ConsumerWidget {
  const AmenityHeadHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyWidgetProvider = Provider<List<Widget>>((ref) {
      List<Widget> l = [];
      l.add(const AmenityEventAdd());
      l.add(const EventsList());
      l.add(const AmenityHeadProfile());
      return l;
    });
    final appBarProvider = Provider<List<AppBar>>((ref) {
      List<AppBar> l = [];
      l.add(
        AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          leadingWidth: 220,
          title: Text("New Event",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
      );
      l.add(
        AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          leadingWidth: 220,
          title:
              Text("Events", style: Theme.of(context).textTheme.headlineLarge),
        ),
      );
      l.add(
        AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          leadingWidth: 220,
          title: Text("Profile Page",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
      );
      return l;
    });
    String admintoken = StorageManager.getAdminToken();
    if (admintoken == "null") {
      context.go("/login");
    }
    final index = ref.watch(currentIndexHeadProvider);
    Future<List<Booking>> bookings =
        ref.watch(amenityHeadProvider.notifier).fetchAmenityBookings();
    return FutureBuilder(
      future: bookings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List<Booking>? bookings = snapshot.data;
            return Scaffold(
              appBar: index == 0
                  ? AppBar(
                      toolbarHeight: MediaQuery.of(context).size.height / 12,
                      elevation: 0,
                      leadingWidth: 220,
                      title: Text("Admin Home",
                          style: Theme.of(context).textTheme.headlineLarge),
                    )
                  : ref.read(appBarProvider)[index - 1],
              body: index == 0
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Upcoming Reservations",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                              const SizedBox(
                                height: 30,
                              ),
                              bookings!.isNotEmpty
                                  ? ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          height: 30,
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: bookings.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 18),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 130,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "${bookings[index].timeOfSlot.hour}:${bookings[index].timeOfSlot.minute}-${bookings[index].endOfSlot.hour}:${bookings[index].endOfSlot.minute}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                      Text(
                                                          // ignore: unnecessary_string_interpolations
                                                          "${bookings[index].type}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium)
                                                    ],
                                                  ),
                                                  const VerticalDivider(
                                                    color: Color(0xFF606C5D),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                          onPressed: () async {
                                                            var deleteData = {
                                                              "booking_id":
                                                                  bookings[
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                            };
                                                            if (bookings[index]
                                                                    .type ==
                                                                "Individual") {
                                                              await AmenityAPIEndpoint
                                                                  .revokeIndividualBooking(
                                                                      deleteData);
                                                            } else {
                                                              await AmenityAPIEndpoint
                                                                  .revokeGroupBooking(
                                                                      deleteData);
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Revoke"))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Text("No active booking in amenity",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium)
                            ]),
                      ),
                    )
                  : ref.read(bodyWidgetProvider)[index - 1],
              bottomNavigationBar: const BottomNavWidget(),
            );
          } else {
            return const LoadingWidget();
          }
        } else {
          return const LoadingWidget();
        }
      },
    );
  }
}

class BottomNavWidget extends ConsumerStatefulWidget {
  const BottomNavWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavWidgetState();
}

final currentIndexHeadProvider = StateProvider<int>((ref) {
  return 0;
});

class _BottomNavWidgetState extends ConsumerState<BottomNavWidget> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexHeadProvider);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: const Color(0xFFF6F1F1)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromRGBO(33, 42, 62, 1),
        selectedFontSize: 12,
        unselectedItemColor: const Color.fromRGBO(113, 111, 111, 1),
        onTap: (value) {
          ref.read(currentIndexHeadProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                // color: Color.fromRGBO(113, 111, 111, 1),
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_rounded,
              ),
              label: "New Event"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
    );
  }
}
