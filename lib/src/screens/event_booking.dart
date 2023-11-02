import 'package:book_my_spot_frontend/src/screens/amenityhead_home.dart';
import 'package:book_my_spot_frontend/src/screens/events_list.dart';
import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:book_my_spot_frontend/src/screens/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/teams_page.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class EventBookingPage extends ConsumerWidget {
  const EventBookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(finalTeamsProvider);
    print(data);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leading: IconButton(
            onPressed: () {
              context.go("/");
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[700],
            )),
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            data != null
                ? data.length != 0
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemCount: data.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: ListTile(
                              onTap: () async {
                                var post_data = {
                                  "id": getToken(),
                                  "team_id": data[index]["id"].toString(),
                                  "name": data[index]["name"].toString(),
                                  "event_id": ref
                                      .read(selectedEventProvider)
                                      .toString(),
                                };
                                var response = await http.post(
                                    Uri.parse(using + "event/register"),
                                    body: post_data);
                                if (response.statusCode == 500) {
                                  SnackBar snackBar = SnackBar(
                                      content: Text("You are not an admin!"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  SnackBar snackBar = SnackBar(
                                      content: Text(
                                          "Registration for Team ${data[index]["name"]} succesfull"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  ref.refresh(currentIndexProvider);
                                  ref.refresh(finalTeamsProvider);
                                  ref.refresh(eventsProvider);
                                  context.go("/");
                                }

                                print(post_data);
                              },
                              tileColor: Color.fromRGBO(217, 217, 217, 0.3),
                              title: Center(
                                  child: Text(
                                data[index]["name"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontFamily: 'Thasadith',
                                ),
                              )),
                            ),
                          );
                        },
                      )
                    : Text("Please create a new team to register")
                : Text("Please create a new team to register!")
          ],
        ),
      ),
    );
  }
}
