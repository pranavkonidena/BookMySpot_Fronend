import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/state/bookings/booking_state.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/services/string_extension.dart';

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
            bookingsWidget = Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                "Go, get some bookings to see them here!",
                style: Theme.of(context).textTheme.bodyMedium,
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
