import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ui {
  static double? width;
  static double? height;
  static void setwh(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.openSans(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          textStyle: const TextStyle(color: Colors.black),
        ),
        bodySmall: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          textStyle: const TextStyle(color: Colors.black),
        ),
        displayMedium: GoogleFonts.openSans(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: BeveledRectangleBorder()),
      ),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Color.fromARGB(34, 124, 124, 124),
          filled: true,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Set border radius as desired
            borderSide: BorderSide(width: 2.0),
            // Set border color and width
          ),
          contentPadding: EdgeInsets.all(20)),
    );
  }
}
