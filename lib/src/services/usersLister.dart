import 'dart:convert';

import 'package:book_my_spot_frontend/src/screens/group_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class CustomUserList extends ConsumerStatefulWidget {
  CustomUserList(this.visibleProvider, {super.key});
  final StateProvider<bool> visibleProvider;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomUserListState();
}

class _CustomUserListState extends ConsumerState<CustomUserList> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersAllProvider);
    return data.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        return const SizedBox();
      },
      data: (data) {
        return Visibility(
          visible: ref.watch(widget.visibleProvider),
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              for (int i = 0;
                  i < data.length;
                  i++)
                data[i]["dp"].contains("github")
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.network(
                              data[i]
                                  ["dp"],
                              height: 56,
                              width: 56,
                            ),
                            Text(data[i]["name"])
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                "https://channeli.in" +
                                    data[i]["dp"],
                                height: 56,
                                width: 56,
                              ),
                            ),
                            Text(data[i]["name"])
                          ],
                        ),
                      )
            ],
          ),
        );
      },
    );
  }
}
