import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(80, 207, 246, 1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bookify",
                style: GoogleFonts.handlee(
                    textStyle: TextStyle(fontSize: 62, color: Colors.white))),
            CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
