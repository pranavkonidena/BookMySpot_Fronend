import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HorizontalDatePicker extends ConsumerStatefulWidget {
  HorizontalDatePicker({super.key});
  int selectedIndex = 0;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends ConsumerState<HorizontalDatePicker> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, index) {
        final date = DateTime.now().add(Duration(days: index));
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
              onTap: () {
                setState(() {
                  widget.selectedIndex = index;
                });
                ref.read(focusedProvider.notifier).state = date;
              },
              child: Card(
                  color: date.day != ref.watch(focusedProvider).day
                      ? Theme.of(context).cardColor
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(width: 1, color: Colors.black)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(date.day.toString() +
                              months[date.month].toString()),
                        ),
                      ),
                      Text(
                        days[date.weekday].toString(),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ))),
        );
      },
    );
  }
}
