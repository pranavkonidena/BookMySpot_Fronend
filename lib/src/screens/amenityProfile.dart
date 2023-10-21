import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityHeadProfile extends ConsumerStatefulWidget {
  const AmenityHeadProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AmenityHeadProfileState();
}

class _AmenityHeadProfileState extends ConsumerState<AmenityHeadProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("This is the profile page for amenity heads")),
    );
  }
}
