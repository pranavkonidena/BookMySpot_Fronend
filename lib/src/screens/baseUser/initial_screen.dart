import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCEF6FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Bookify!',
            textAlign: TextAlign.center,
            style : GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color(0xFF4898C6),
              fontSize: 42,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              )
            )
          )

        ],
      ),
    );
  }
}
