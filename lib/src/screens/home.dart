import 'dart:convert';
import '../models/user.dart';
import 'package:book_my_spot_frontend/src/screens/login.dart';
import 'package:book_my_spot_frontend/src/screens/login_webView.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';
import '../services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Date {
  String? date;
  String? day;
}

final dateProvider = Provider<Date>((ref) {
  final now = DateTime.now();
  String year = "";
  year += "${now.year % 100}";

  Date _date = Date();
  _date.date = "${now.day}th ${months[now.month]} '$year";
  _date.day = days[now.weekday];
  return _date;
});
final tokenProvider = Provider<String>((ref) {
  String token = getToken();
  return token;
});

final userProvider = FutureProvider<String>((ref) async {
  User u = User();
  u.token = getToken();
  return await u.userFromJSON();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    String token = getToken();
    if (token == "null") {
      return LoginScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          backgroundColor: const Color.fromARGB(168, 35, 187, 233),
          leadingWidth: 220,
          leading: Padding(
            padding: const EdgeInsets.only(left: 22.0, bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date.date.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Thasadith',
                  ),
                ),
                Text(
                  date.day.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Thasadith',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_month_outlined),
                      iconSize: 30,
                      color: Colors.grey.shade700),
                )
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 48, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Bookings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Thasadith',
                    fontWeight: FontWeight.w400,
                    height: 0.03,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                BookingsListView()
              ],
            ),
          ),
        ),
      );
    }
  }
}

final dataProvider = FutureProvider<dynamic>((ref) async {
  String token = getToken();
  dynamic response = await http
      .get(Uri.parse(base_url_IITR_WIFI + "user/getBooking?id=${token}"));
  dynamic data = jsonDecode(response.body);
  for (int i = 0; i < data.length; i++) {
    data[i] = jsonDecode(data[i].toString());
    data[i]["time_of_slot"] = DateTime.parse(data[i]["time_of_slot"]);
    data[i]["end_time"] = data[i]["time_of_slot"]
        .add(Duration(minutes: data[i]["duration_of_booking"]));
  }
  return data;
});

class BookingsListView extends ConsumerWidget {
  const BookingsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    return data.when(data: (value) {
      if ((value as List).isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: Text(
            "Go, get some bookings to see them here!",
            style: TextStyle(
              fontFamily: "Thasadith",
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 130,
              color: Color.fromRGBO(247, 230, 196, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [Text("IMG HERE")],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value[index]["amenity"]["name"],
                        style: const TextStyle(
                          color: Color(0xFF606C5D),
                          fontSize: 30,
                          fontFamily: 'Thasadith',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                        value[index]["amenity"]["venue"],
                        style: const TextStyle(
                          color: Color(0xFF606C5D),
                          fontSize: 15,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value[index]["type"],
                        style: TextStyle(
                          color: Color(0xFF606C5D),
                          fontSize: 25,
                          fontFamily: 'Thasadith',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      }
    }, error: (error, stackTrace) {
      return const SizedBox();
    }, loading: () {
      return const CircularProgressIndicator();
    });
  }
}
