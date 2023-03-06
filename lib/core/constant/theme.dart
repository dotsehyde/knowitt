import 'package:flutter/material.dart';

const darkBlue = Color(0xFF121E39);
const primaryColor = Color(0xFFE32609);
const accentColor = Color(0xFF216F74);

ThemeData customTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  accentColor: accentColor,
  scaffoldBackgroundColor: darkBlue,
  appBarTheme: AppBarTheme(
    backgroundColor: darkBlue,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
);
