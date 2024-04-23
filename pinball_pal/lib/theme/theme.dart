import 'package:flutter/material.dart';

class PinballPalTheme {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.blue, // Primary color for the app
      scaffoldBackgroundColor: Colors.white, // Background color for scaffold
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue, // Background color for app bar
        elevation: 0, // No shadow
        titleTextStyle: TextStyle(
          color: Colors.white, // Text color for app bar title
          fontSize: 20.0, // Font size for app bar title
          fontWeight: FontWeight.bold, // Font weight for app bar title
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24.0, // Font size for headline 1
          fontWeight: FontWeight.bold, // Font weight for headline 1
          color: Colors.black, // Text color for headline 1
        ),
        displayMedium: TextStyle(
          fontSize: 16.0, // Font size for body text
          color: Colors.black87, // Text color for body text
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue, // Background color for buttons
        textTheme: ButtonTextTheme.primary, // Text color for buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Button border radius
        ),
      ),
    );
  }
}
