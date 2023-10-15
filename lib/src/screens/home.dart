import 'dart:convert';

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
            padding: EdgeInsets.only(left: 20.0, top: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upcoming Bookings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Thasadith',
                    fontWeight: FontWeight.w400,
                    height: 0.03,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 52,
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
  dynamic data = jsonDecode(response.body.toString());
  return data;
});

class BookingsListView extends ConsumerWidget {
  const BookingsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    data.when(data: (value) {
      print(value);
      if ((value as List).length == 0) {
        return const Text(
          "Go, get some bookings to see them here!",
          style: TextStyle(
            fontFamily: "Thasadith",
            fontSize: 20,
          ),
        );
      } else {
        return Text("OK bity ${value}");
      }
    }, error: (error, stackTrace) {
      return const SizedBox();
    }, loading: () {
      return const CircularProgressIndicator();
    });

    return const Text("OK");
  }
}
