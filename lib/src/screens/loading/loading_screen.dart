import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bookify",
                style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 62, color: Colors.white))),
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
