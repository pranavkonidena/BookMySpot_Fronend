import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final selectedEventIDProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

final eventsListProvider = FutureProvider<dynamic>((ref) async {
  var token = StorageManager.getAdminToken().toString();
  var response = await http.get(Uri.parse(using + "event/getAll?id=${token}"));
  var data = jsonDecode(response.body);
  // value[index]["time_of_occourence_start"] =
  //                 DateTime.parse(value[index]["time_of_occourence_start"]);
  //             value[index]["time_of_occourence_end"] =
  //                 DateTime.parse(value[index]["time_of_occourence_end"]);
  for (int i = 0; i < data.length; i++) {
    final outputFormat = DateFormat("d MMM''yy HH:mm");
    data[i]["time_of_occourence_start"] =
        DateTime.parse(data[i]["time_of_occourence_start"]);
    data[i]["time_of_occourence_start"] =
        outputFormat.format(data[i]["time_of_occourence_start"]);
    data[i]["time_of_occourence_end"] =
        DateTime.parse(data[i]["time_of_occourence_end"]);
    data[i]["time_of_occourence_end"] =
        outputFormat.format(data[i]["time_of_occourence_end"]);
  }
  return data;
});

class EventsList extends ConsumerWidget {
  const EventsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(eventsListProvider);
    return data.when(data: (value) {
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 8, right: 8),
        child: value.length != 0
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 30,
                  );
                },
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  print(value[index]);
                  return InkWell(
                    onTap: () {
                      ref.read(selectedEventIDProvider.notifier).state =
                          value[index]["team"];
                      context.go("/head/event/teams");
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
                                value[index]["name"],
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
                                    value[index]["time_of_occourence_start"]
                                        .toString(),
                                    style: TextStyle(
                                      color: Color(0xFF606C5D),
                                      fontSize: 25,
                                      fontFamily: 'Thasadith',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "  to  ",
                                    style: TextStyle(
                                      color: Color(0xFF606C5D),
                                      fontSize: 25,
                                      fontFamily: 'Thasadith',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    value[index]["time_of_occourence_end"]
                                        .toString(),
                                    style: TextStyle(
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
            : Row(
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
    }, error: (error, stackTrace) {
      return const SizedBox();
    }, loading: () {
      return const SpinKitFadingCircle(
            color: Color(0xff0E6BA8),
            size: 50.0,
          );
    });
  }
}
