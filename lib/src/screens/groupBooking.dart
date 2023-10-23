import 'dart:convert';

import 'package:book_my_spot_frontend/src/screens/checkSlots.dart';
import 'package:book_my_spot_frontend/src/screens/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/screens/groupCreation.dart';
import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

final groupNameProvider = StateProvider<String>((ref) {
  return "";
});

class GroupBookingFinalPage extends ConsumerWidget {
  const GroupBookingFinalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grp_name = ref.watch(groupNameProvider);
    final date = ref.watch(selectedDateProvider);
    final data = ref.watch(slotsProviderAmenity);
    var initial_post_data = {
      "date": "${date.year}-${date.month}-${date.day}",
      "amenity_id": data[0]["amenity_id"].toString(),
      "start_time": data[ref.read(indexProvider)]["start_time"].toString(),
      "end_time": data[ref.read(indexProvider)]["end_time"].toString(),
    };
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              ref.refresh(groupNameProvider);

              context.go("/grpcreate");
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[700],
            )),
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        title: const Text(
          "New Group  ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                List grpMembers = [];
                for (int i = 0;
                    i < ref.read(groupselectedProvider.notifier).state.length;
                    i++) {
                  var id = ref.read(groupselectedProvider)[i]["id"];
                  print(id);
                  grpMembers.add(id);
                }
                print(grpMembers);
                grpMembers.add(getToken());
                var grp_data = {
                  "name": grp_name,
                  "id": jsonEncode(grpMembers).toString(),
                };
                print(grp_data);
                var grp_response = await http
                    .post(Uri.parse(using + "group/add"), body: grp_data);
                var grp_id = jsonDecode(grp_response.body.toString());
                print(data);
                initial_post_data["group_id"] = grp_id.toString();
                var response = await http.post(
                    Uri.parse(using + "booking/group/bookSlot"),
                    body: initial_post_data);
                if (response.statusCode == 200) {
                  ref.refresh(groupNameProvider);
                  ref.refresh(groupselectedProvider);
                  ref.refresh(dataProvider);
                  ref.refresh(currentIndexProvider);
                  context.go("/");
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  "Reserve",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Thasadith',
                  ),
                ),
              ))
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration:
                InputDecoration(label: Center(child: Text("Enter group name"))),
            onChanged: (value) {
              ref.read(groupNameProvider.notifier).state = value;
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
