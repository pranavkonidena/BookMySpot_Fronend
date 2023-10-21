import 'dart:convert';

import 'package:book_my_spot_frontend/src/screens/individualBookingDetails.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

final allBookingsProvider = FutureProvider<dynamic>((ref) async {
  var response = await http
      .get(Uri.parse(using + "amenity/getAllBookings?id=${getAdminToken()}"));
  var data = jsonDecode(response.body);
  for (int i = 0; i < data.length; i++) {
    data[i]["time_of_slot"] = DateTime.parse(data[i]["time_of_slot"]);
    data[i]["end_time"] = data[i]["time_of_slot"]
        .add(Duration(minutes: data[i]["duration_of_booking"]));
  }
  print(data);
  return data;
});

class AmenityHeadHome extends ConsumerWidget {
  const AmenityHeadHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String admintoken = getAdminToken();
    if (admintoken == "null") {
      context.go("/login");
    }
    final data = ref.watch(allBookingsProvider);
    return data.when(
      data: (value) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 12,
            elevation: 0,
            backgroundColor: const Color.fromARGB(168, 35, 187, 233),
            leadingWidth: 220,
            title: const Text(
              "Admin Home",
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Thasadith',
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0, left: 8),
              child: Column(children: [
                const Text(
                  "Upcoming Reservations",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Thasadith',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                value.length != 0
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 30,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 18),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 130,
                                color: Color.fromRGBO(247, 230, 196, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                            "https://github-production-user-asset-6210df.s3.amazonaws.com/122373207/275466089-4e5a891c-8afd-4e9b-a0da-04ff0c39687c.png",
                                            height: 30)
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${value[index]["time_of_slot"].hour}:${value[index]["time_of_slot"].minute}-${value[index]["end_time"].hour}:${value[index]["end_time"].minute}",
                                          style: const TextStyle(
                                            color: Color(0xFF606C5D),
                                            fontSize: 25,
                                            fontFamily: 'Thasadith',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${value[index]["type"]}",
                                          style: const TextStyle(
                                            color: Color(0xFF606C5D),
                                            fontSize: 25,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              if (value[index]["type"] ==
                                                  "Individual") {
                                                print(value[index]["id"]);
                                                var response = await http.get(
                                                    Uri.parse(using +
                                                        "booking/individual/cancelSlot?booking_id=${value[index]["id"]}"));
                                                ref.refresh(
                                                    allBookingsProvider);
                                              } else {
                                                var response = await http.get(
                                                    Uri.parse(using +
                                                        "booking/group/cancelSlot?booking_id=${value[index]["id"]}"));
                                                ref.refresh(
                                                    allBookingsProvider);
                                              }
                                            },
                                            child: Text("Revoke"))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Text(
                        "No one has booked amenity!",
                        style: TextStyle(
                          fontFamily: "Thasadith",
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                // ElevatedButton(
                //     onPressed: () {
                //       deleteAdminToken();
                //       context.go("/login");
                //     },
                //     child: Text("Logout"))
              ]),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return const SizedBox();
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}
