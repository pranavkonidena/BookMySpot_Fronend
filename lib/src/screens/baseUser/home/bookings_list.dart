import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/state/bookings/booking_state.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class BookingsListView extends ConsumerWidget {
  const BookingsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<Booking>?> bookings =
        ref.watch(userBookingsProvider.notifier).getUserBookings(context, ref);

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
                return Stack(alignment: Alignment.center, children: [
                  InkWell(
                    onTap: () {
                      ref.read(groupidProvider.notifier).state =
                          bookings[index].id;
                      ref.read(dataIndexProvider.notifier).state =
                          bookings[index].id;
                      if (bookings[index].type.toLowerCase() == "individual") {
                        context.go("/booking/individual/${bookings[index].id}");
                      } else {
                        context.go("/booking/group/${bookings[index].id}");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    bookings[index].amenityName,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  AutoSizeText(
                                    "${bookings[index].timeOfSlot.hour}:${bookings[index].timeOfSlot.minute}-${bookings[index].endOfSlot.hour}:${bookings[index].endOfSlot.minute}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  AutoSizeText(
                                    bookings[index].amenityVenue,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                          // const VerticalDivider(

                          //   color: Color(0xFF606C5D),
                          // ),
                          const Dash(
                              direction: Axis.vertical,
                              length: 130,
                              dashLength: 15,
                              dashColor: Colors.grey),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    bookings[index].type.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    minFontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      right: -5,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(234, 234, 234, 1),
                            shape: BoxShape.circle),
                      )),
                ]);
              },
            );
          }
        } else {
          bookingsWidget = const SpinKitFadingCircle(
            color: Color(0xff0E6BA8),
            size: 50.0,
          );
        }
        return bookingsWidget;
      },
    );
  }
}
