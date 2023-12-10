import 'package:book_my_spot_frontend/src/models/event.dart';
import 'package:book_my_spot_frontend/src/screens/loading/loading_widget.dart';
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
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5,
                        mainAxisExtent: MediaQuery.of(context).size.height / 4,
                      ),
                      itemCount: events.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            ref.read(selectedEventIDProvider.notifier).state =
                                events[index].teams;
                            context.go("/head/event/teams/${events[index].id}");
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(20)),
                            // color: Theme.of(context).secondaryHeaderColor,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(events[index].name),
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                              Text(
                                  events[index]
                                      .timeOfOccourenceStart
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_downward),
                              ),
                              Text(events[index].timeOfOccourenceEnd.toString(),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ]),
                          ),
                        );
                      })
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No events found",
                            style: Theme.of(context).textTheme.bodyMedium),
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
          return const LoadingWidget();
        }
      },
    );
  }
}
