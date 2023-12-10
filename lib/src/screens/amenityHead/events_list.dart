import 'package:book_my_spot_frontend/src/models/event.dart';
import 'package:book_my_spot_frontend/src/state/events/events_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final selectedEventIDProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

class EventsList extends ConsumerWidget {
  const EventsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<AmenityEvent>?> events =
        ref.watch(eventsProviderFinal.notifier).fetchallEvents(ref);
    return FutureBuilder(
      future: events,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AmenityEvent>? events = snapshot.data;
          if (events != null) {
            return Scaffold(
                body: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 8, right: 8),
              child: events.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 30,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            ref.read(selectedEventIDProvider.notifier).state =
                                events[index].teams;
                            context.go("/head/event/teams/${events[index].id}");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            color: const Color.fromRGBO(247, 230, 196, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      events[index].name,
                                      style: const TextStyle(
                                        color: Color(0xFF606C5D),
                                        fontSize: 30,
                                        fontFamily: 'Thasadith',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          events[index]
                                              .timeOfOccourenceStart
                                              .toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF606C5D),
                                            fontSize: 25,
                                            fontFamily: 'Thasadith',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Text(
                                          "  to  ",
                                          style: TextStyle(
                                            color: Color(0xFF606C5D),
                                            fontSize: 25,
                                            fontFamily: 'Thasadith',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          events[index]
                                              .timeOfOccourenceEnd
                                              .toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF606C5D),
                                            fontSize: 25,
                                            fontFamily: 'Thasadith',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No events found",
                          style: TextStyle(
                            color: Color(0xFF606C5D),
                            fontSize: 25,
                            fontFamily: 'Thasadith',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
            ));
          } else {
            return const SpinKitFadingCircle(
              color: Color(0xff0E6BA8),
              size: 50.0,
            );
          }
        } else {
          return const SpinKitFadingCircle(
            color: Color(0xff0E6BA8),
            size: 50.0,
          );
        }
      },
    );
  }
}
