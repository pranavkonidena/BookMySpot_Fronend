import 'package:book_my_spot_frontend/src/screens/baseUser/home/custompainter_bottomnav.dart';
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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedIconTheme:
          Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
      selectedFontSize: 12,
      unselectedIconTheme:
          Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
      onTap: (value) {
        ref.read(currentIndexProvider.notifier).state = value;
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 0,
              color: Colors.white,
            ),
            label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Teams"),
      ],
    );
  }
}
