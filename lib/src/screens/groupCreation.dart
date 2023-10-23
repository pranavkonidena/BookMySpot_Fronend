import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

final currentStringProvider = StateProvider<String>((ref) {
  return "";
});

final filtereditemsProvider = StateProvider<List<String>>((ref) {
  return ref.read(itemsProvider);
});

final itemsProvider = StateProvider<List<String>>((ref) {
  List<String> l = [];
  return l;
});

final usersAllProvider = FutureProvider<dynamic>((ref) async {
  var response = await http.get(Uri.parse(using + "user"));
  var data = jsonDecode(response.body.toString());
  for (int i = 0; i < data.length; i++) {
    ref.read(itemsProvider.notifier).state.add(data[i]["name"]);
  }
  return data;
});

class GroupCreatePage extends ConsumerStatefulWidget {
  const GroupCreatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupCreatePageState();
}

class _GroupCreatePageState extends ConsumerState<GroupCreatePage> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersAllProvider);
    final List<String> _suggestions = ref.watch(itemsProvider);
    return data.when(
      data: (data) {
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 12,
              elevation: 0,
              backgroundColor: const Color.fromARGB(168, 35, 187, 233),
              leading: IconButton(
                  onPressed: () {
                    context.go("/checkSlots");
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[700],
                  )),
              title: Text(
                "Add Participants",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Thasadith',
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Thasadith',
                          fontWeight: FontWeight.w400,
                          height: 0.05,
                        ),
                      )),
                )
              ],
            ),
            body: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Search name",
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    var all_players = ref.read(itemsProvider);
                    List<String> filtered_players = [];
                    for (int i = 0; i < all_players.length; i++) {
                      print(all_players[i]);
                    }
                    if (value.isEmpty) {
                      filtered_players = all_players;
                    } else {
                      filtered_players = all_players
                          .where((element) =>
                              element.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    }
                    ref.read(filtereditemsProvider.notifier).state =
                        filtered_players;
                    print(filtered_players);
                    print("VAL" + value);
                    
                  },
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: ref.watch(filtereditemsProvider).length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(ref.watch(filtereditemsProvider)[index]),
                    );
                  },
                ))
              ],
            ));
      },
      error: (error, stackTrace) {
        return SizedBox();
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
