import 'package:book_my_spot_frontend/src/screens/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final dataObject = data[index];
                final startTime = dataObject["start_time"];
                final endTime = dataObject["end_time"];
                final isSelected = ref.watch(selectedItemsProvider)[index];
                return InkWell(
                  onTap: () {
                    List<bool> a = [];
                    for (int i = 0; i < ref.watch(datalengthProvider); i++) {
                      a.add(false);
                    }
                    ref.read(selectedItemsProvider.notifier).state = a;
                    ref.read(selectedItemsProvider.notifier).state[index] =
                        !ref.read(selectedItemsProvider.notifier).state[index];
                    ref.read(indexProvider.notifier).state = index;
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
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
                    child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      final date = ref.watch(selectedDateProvider);
                      final data = ref.watch(slotsProviderAmenity);
                      if (ref.read(indexProvider) < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print(data);
                        var post_data = {
                          "id_user": getToken().toString(),
                          "date": "${date.year}-${date.month}-${date.day}",
                          "amenity_id": data[0]["amenity_id"].toString(),
                          "start_time": data[ref.read(indexProvider)]
                                  ["start_time"]
                              .toString(),
                          "end_time": data[ref.read(indexProvider)]["end_time"]
                              .toString(),
                          // "amenity_id" : data[]
                        };
                        print(post_data);
                        var response = await http.post(
                            Uri.parse(using + "booking/individual/bookSlot"),
                            body: post_data);
                        print(response.statusCode);
                        ref.refresh(dataProvider);
                        ref.refresh(currentIndexProvider);
                        ref.refresh(durationProvider);
                        ref.refresh(selectedDateProvider);
                        ref.refresh(timeProvider);
                        context.go("/");
                      }
                    },
                    child: Text("Book")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
