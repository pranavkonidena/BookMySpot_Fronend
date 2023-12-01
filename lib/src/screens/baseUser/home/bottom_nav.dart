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
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedIconTheme: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
      selectedFontSize: 0,
      unselectedIconTheme: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
      onTap: (value) {
        ref.read(currentIndexProvider.notifier).state = value;
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: ""),
      ],
    );
  }
}
