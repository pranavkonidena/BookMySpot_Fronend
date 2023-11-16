import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: const Color(0xFFF6F1F1)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: const Color.fromRGBO(241, 239, 239, 1),
        selectedItemColor: const Color.fromRGBO(33, 42, 62, 1),
        selectedFontSize: 0,
        unselectedItemColor: const Color.fromRGBO(113, 111, 111, 1),
        onTap: (value) {
          ref.read(currentIndexProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                // color: Color.fromRGBO(113, 111, 111, 1),
              ),
              label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "")
        ],
      ),
    );
  }
}