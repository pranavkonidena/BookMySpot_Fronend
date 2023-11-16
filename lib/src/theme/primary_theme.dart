import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData primaryTheme = ThemeData(
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.thasadith(
        color: const Color.fromRGBO(37, 42, 52, 1),
        fontSize: 30,
        fontWeight: FontWeight.w400),
    backgroundColor: const Color.fromARGB(168, 35, 187, 233),
  ),
  textTheme: TextTheme(
      titleLarge: GoogleFonts.thasadith(
          color: const Color.fromRGBO(37, 42, 52, 1),
          fontSize: 30,
          fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.thasadith(
          color: const Color.fromRGBO(37, 42, 52, 1),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      displayLarge: GoogleFonts.thasadith(
          color: const Color.fromRGBO(37, 42, 52, 1),
          fontSize: 40,
          fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.thasadith(color: Colors.black, fontSize: 20),
      bodyLarge: GoogleFonts.thasadith(
          color: const Color.fromRGBO(37, 42, 52, 1), fontSize: 35),
      bodyMedium: GoogleFonts.thasadith(fontSize: 20)),
);
