import 'dart:convert';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../models/user.dart';
var finalTeams = [];

final _slotsProvider = FutureProvider<dynamic>((ref) async {
  var response = await http.get(Uri.parse("${using}amenity/getAll"));
  dynamic data = response.body;
  data = jsonDecode(response.body.toString());
  return data;
});

class MakeReservationPage extends ConsumerWidget {
  const MakeReservationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 18, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Amenities",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'Thasadith',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SlotsListWidget(),
              SizedBox(
                height: 30,
              ),
              Text(
                "Events",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: 'Thasadith',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              EventsLister(),
            ],
          ),
        ),
      ),
    );
  }
}

class SlotsListWidget extends ConsumerWidget {
  const SlotsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(_slotsProvider);
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
              return const SizedBox(
                height: 30,
              );
            },
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  color: const Color.fromRGBO(247, 230, 196, 1),
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
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Thasadith',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8DCE7)),
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
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

final _eventsProvider = FutureProvider<dynamic>((ref) async {
  var response = await http.get(Uri.parse("${using}event/getAll"));
  var data = jsonDecode(response.body.toString());
  return data;
});

class EventsLister extends ConsumerWidget {
  const EventsLister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(_eventsProvider);
    return data.when(
      data: (value) {
        return ListView.separated(
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  color: const Color.fromRGBO(247, 230, 196, 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(children: [
                              Text(
                                value[index]["name"],
                                style: const TextStyle(
                                  color: Color(0xFF606C5D),
                                  fontSize: 25,
                                  fontFamily: 'Thasadith',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ]),
                            Text(
                              "${DateTime.parse(value[index]["time_of_occourence_start"]).day} ${months[DateTime.parse(value[index]["time_of_occourence_start"]).month]} ${DateTime.parse(value[index]["time_of_occourence_start"]).year} - ${DateTime.parse(value[index]["time_of_occourence_end"]).day} ${months[DateTime.parse(value[index]["time_of_occourence_end"]).month]} ${DateTime.parse(value[index]["time_of_occourence_end"]).year} ",
                              style: const TextStyle(
                                color: Color(0xFF606C5D),
                                fontSize: 25,
                                fontFamily: 'Thasadith',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Color(0xFF606C5D),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            ref.read(selectedEventProvider.notifier).state =
                                value[index]["id"];
                            ref.read(finalTeamsProvider.notifier).state = [];
                            User user = ref.watch(userProvider);
                            var teamsasAdmin = await http.get(Uri.parse(
                                "${using}teamasadmin?id=${user.token}"));
                            var teams = jsonDecode(teamsasAdmin.body);
                            finalTeams.clear();
                            for (int i = 0; i < teams.length; i++) {
                              if (!value[index]["team"]
                                  .contains(teams[i]["id"])) {
                                finalTeams.add(teams[i]);
                              }
                            }
                            ref.read(finalTeamsProvider.notifier).state =
                                finalTeams;
                            context.go("/event/book");
                          },
                          child: Text(
                            "Book",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Thasadith',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB8DCE7)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      error: (error, stackTrace) {
        return const SizedBox();
      },
      loading: () => const Center(child:  CircularProgressIndicator()),
    );
  }
}
