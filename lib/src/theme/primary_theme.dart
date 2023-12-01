import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData primaryTheme = ThemeData(
  primarySwatch: Colors.blue,
  cardColor: const Color.fromRGBO(234, 234, 234, 1),
  iconTheme: const IconThemeData(color: Colors.black, size: 30),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.thasadith(
        color: const Color.fromRGBO(37, 42, 52, 1),
        fontSize: 30,
        fontWeight: FontWeight.w600),
    backgroundColor: Color(0xff06BCC1),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.poppins(
        color: Colors.black, fontSize: 29, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
    labelMedium: GoogleFonts.poppins(
      color: const Color(0xFF747474),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.poppins(
      color: const Color(0xFF747474),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    headlineLarge: GoogleFonts.thasadith(
        color: const Color.fromRGBO(37, 42, 52, 1),
        fontSize: 35,
        fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.thasadith(
        color: const Color.fromRGBO(37, 42, 52, 1),
        fontSize: 25,
        fontWeight: FontWeight.bold),
    headlineSmall:
        GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
    bodyLarge: GoogleFonts.thasadith(
        fontSize: 30,
        color: const Color(0xFF606C5D),
        fontWeight: FontWeight.w600),
    bodyMedium: GoogleFonts.thasadith(
        fontSize: 25,
        color: const Color(0xFF606C5D),
        fontWeight: FontWeight.w600),
    bodySmall: GoogleFonts.thasadith(
        fontSize: 15,
        color: const Color(0xFF606C5D),
        fontWeight: FontWeight.w400),
    displayMedium: GoogleFonts.thasadith(fontSize: 20)
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(241, 239, 239, 1),
    selectedItemColor: Color.fromRGBO(33, 42, 62, 1),
    unselectedItemColor: Color.fromRGBO(113, 111, 111, 1),
  ),
);
