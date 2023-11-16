import 'dart:convert';
import 'package:book_my_spot_frontend/src/screens/amenityHead/events_list.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_detail.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';

final _allTeamsInEventProvider = FutureProvider<dynamic>((ref) async {
  List<dynamic> teams = ref.watch(selectedEventIDProvider);
  List<dynamic> teamDetails = [];
  for (int i = 0; i < teams.length; i++) {
    var response = await http.get(Uri.parse("${using}team/i?id=${teams[i]}"));
    var data = jsonDecode(response.body.toString());
    teamDetails.add(data);
  }

  return teamDetails;
});

class AmenityEventTeamsList extends ConsumerWidget {
  const AmenityEventTeamsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams_details = ref.watch(_allTeamsInEventProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leading: IconButton(
            onPressed: () {
              context.go("/head");
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.grey[700],
            )),
        title: const Text(
          "Registered Teams",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
      ),
      body: teams_details.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return const SizedBox();
        },
        data: (data) {
          return Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 30,
                  );
                },
                shrinkWrap: true,
                itemCount: data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      
                      ref.watch(teamIDProvider.notifier).state =
                          data[index][0]["id"];
                          
                      context.go("/teamDetails${data[index][0]["id"]}");
                      ref.refresh(teamdetailsProvider);
                    },
                    tileColor: Color.fromRGBO(217, 217, 217, 0.3),
                    title: Center(
                        child: Text(
                      data[index][0]["name"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: 'Thasadith',
                      ),
                    )),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
