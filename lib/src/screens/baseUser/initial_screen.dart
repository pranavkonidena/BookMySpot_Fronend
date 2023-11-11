import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    String token = getToken();
    if (token != 'null') {
      Future.microtask(() => context.go("/"));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFCEF6FF),
        body: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 2 / 3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Welcome to Bookify!",
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        color: Color(0xFF4898C6),
                        fontSize: 42,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      )),
                    )
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 1000),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4898C6)),
                        onPressed: () {},
                        child: Text(
                          "Get Started",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFEDF8FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
