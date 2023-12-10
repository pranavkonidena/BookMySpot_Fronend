// ignore_for_file: unused_result

import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/booking_api.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final indiDetailsProvider = StateProvider<dynamic>((ref) {
  return;
});

const snackBar = SnackBar(
  content: Text("Please select before proceeding"),
);

final indexProvider = StateProvider<int>((ref) {
  return -1;
});

final datalengthProvider = Provider<int>((ref) {
  return ref.watch(slotsProviderAmenity).length;
});

final selectedItemsProvider = StateProvider<List<bool>>((ref) {
  final dataLength = ref.watch(datalengthProvider);
  return List.generate(dataLength, (index) => false);
});

class BookingPageFinal extends ConsumerStatefulWidget {
  const BookingPageFinal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingPageFinalState();
}

class _BookingPageFinalState extends ConsumerState<BookingPageFinal> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(slotsProviderAmenity);
    final type = ref.watch(boolListProvider);
    if (type[0] == true) {
      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              data.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final dataObject = data[index];
                        final startTime = dataObject["start_time"];
                        final endTime = dataObject["end_time"];
                        final isSelected =
                            ref.watch(selectedItemsProvider)[index];
                        return InkWell(
                          onTap: () {
                            List<bool> a = [];
                            for (int i = 0;
                                i < ref.watch(datalengthProvider);
                                i++) {
                              a.add(false);
                            }
                            ref.read(selectedItemsProvider.notifier).state = a;
                            ref
                                    .read(selectedItemsProvider.notifier)
                                    .state[index] =
                                !ref
                                    .read(selectedItemsProvider.notifier)
                                    .state[index];
                            ref.read(indexProvider.notifier).state = index;
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(168, 35, 187, 233)
                                  : Colors.white,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text('$startTime - $endTime'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child:
                          const Text("We are sorry , but no slots were found"),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        ref.read(currentIndexProvider.notifier).state = 0;
                        ref.invalidate(durationProvider);
                        ref.invalidate(selectedDateProvider);
                        ref.invalidate(timeProvider);
                        ref.invalidate(boolListProvider);
                        context.go("/");
                      },
                      child: const Text("Cancel")),
                  data.isNotEmpty
                      ? ElevatedButton(
                          onPressed: () async {
                            try {
                              await BookingAPIEndpoint.makeBooking(ref);
                              ref.invalidate(currentIndexProvider);
                              ref.invalidate(durationProvider);
                              ref.invalidate(selectedDateProvider);
                              ref.invalidate(timeProvider);
                              Future.microtask(() => context.go("/"));
                            } on UserException catch (e) {
                              debugPrint(e.errorMessage());
                              e.errorHandler(ref);
                            }
                          },
                          child: const Text("Book"))
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              data.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final dataObject = data[index];
                        final startTime = dataObject["start_time"];
                        final endTime = dataObject["end_time"];
                        final isSelected =
                            ref.watch(selectedItemsProvider)[index];
                        return InkWell(
                          onTap: () {
                            List<bool> a = [];
                            for (int i = 0;
                                i < ref.watch(datalengthProvider);
                                i++) {
                              a.add(false);
                            }
                            ref.read(selectedItemsProvider.notifier).state = a;
                            ref
                                    .read(selectedItemsProvider.notifier)
                                    .state[index] =
                                !ref
                                    .read(selectedItemsProvider.notifier)
                                    .state[index];
                            ref.read(indexProvider.notifier).state = index;
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(168, 35, 187, 233)
                                  : Colors.white,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text('$startTime - $endTime'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child:
                          const Text("We are sorry , but no slots were found"),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        ref.read(currentIndexProvider.notifier).state = 0;
                        ref.refresh(durationProvider);
                        ref.refresh(selectedDateProvider);
                        ref.refresh(timeProvider);
                        context.go("/");
                      },
                      child: const Text("Cancel")),
                  data.isNotEmpty
                      ? ElevatedButton(
                          onPressed: () async {
                            if (ref.read(indexProvider) < 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              context.go("/grpcreate/checkSlots");
                            }
                          },
                          child: const Text("Create Group"))
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
