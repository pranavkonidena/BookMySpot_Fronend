import 'dart:convert';

import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './home.dart';
import '../models/slot.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
final slotsProvider = FutureProvider<dynamic>((ref) async {
  var post_data = {"duration": "30", "date": "2023-10-17"};
  var response = await http.get(Uri.parse(using + "amenity/getAll"));
  dynamic data = response.body;
  data = jsonDecode(response.body.toString());
  return data;
});

class MakeReservationPage extends ConsumerWidget {
  const MakeReservationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 18, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Make a Reservation",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Thasadith',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SlotsListWidget(),
          ],
        ),
      ),
    );
  }
}

class SlotsListWidget extends ConsumerWidget {
  const SlotsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(slotsProvider);
    return data.when(
      data: (value) {
        if ((value as List).isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Text(
              "Please check after some time",
              style: TextStyle(
                fontFamily: "Thasadith",
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 30,
              );
            },
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  color: Color.fromRGBO(247, 230, 196, 1),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                              "https://github-production-user-asset-6210df.s3.amazonaws.com/122373207/275466089-4e5a891c-8afd-4e9b-a0da-04ff0c39687c.png",
                              height: 30)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
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
                            Text(
                              value[index]["venue"],
                              style: const TextStyle(
                                color: Color(0xFF606C5D),
                                fontSize: 15,
                                fontFamily: 'Thasadith',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ]),
                    ),
                    const VerticalDivider(
                      color: Color(0xFF606C5D),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          
                          context.go("/new/${value[index]["id"]}");
                        },
                        child:  Text(
                          "Book Now",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Thasadith',
                              fontWeight: FontWeight.w400,
                      
                            ),
                          
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB8DCE7)),
                      ),
                    )
                  ]));
            },
          );
        }
      },
      error: (error, stackTrace) {
        return const SizedBox();
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
