import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      String? token = getToken();
      String? admintoken = getAdminToken();
      if (admintoken != "null") {
        context.go("/head");
      } else if (token != "null") {
        context.go("/");
      } else {
        context.go("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(80, 207, 246, 1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bookify",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: 62, color: Colors.white))),
            Text(
              "Making Life easy , One booking at a time",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 18, color: Color.fromRGBO(224, 244, 255, 1))),
            ),
            const SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}