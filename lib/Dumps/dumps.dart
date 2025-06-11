import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

/*

App Theme Scheme Color

*/
Color yellowScheme = const Color.fromARGB(255, 236, 255, 128);
Color primaryColor = const Color.fromARGB(255, 224, 255, 215);
Color darkScheme = const Color.fromARGB(255, 49, 52, 39);
ColorScheme metricalColors = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF8E44AD), // Purple (30%)
  secondary: Color(0xFF27AE60), // Green (10%)
  tertiary: Color.fromARGB(255, 188, 210, 216), // Light gray (60%)
  surface: Colors.white,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onTertiary: Colors.black,
  onSurface: Colors.black,
  error: Colors.red,
  onError: Colors.white,
);

/*

Use for email as a username

*/
String cutTo(String? input) {
  if (input == null || !input.contains('@gmail.com')) {
    return '';
  }
  final index = input.indexOf('@gmail.com');
  return index != -1 ? input.substring(0, index) : input;
}

/*

loading dialog

*/
Future<void> loadingDialog() {
  final loading = EasyLoading.show(
    indicator: Column(mainAxisSize: MainAxisSize.min, children: [
      SpinKitDualRing(color: yellowScheme),
      SizedBox(
        height: 15,
      ),
      Text(
        'Loading please wait...',
        style: GoogleFonts.poppins(
            color: Colors.amberAccent, fontSize: 10, letterSpacing: 3),
      )
    ]),
  );
  return loading;
}

/*

Check if the user creates an account with the @gmail.com as their provider

*/

bool isAGmailProvider(String? email) {
  return email != null && email.endsWith('@gmail.com');
}

TextTheme themes = TextTheme(
    headlineLarge: GoogleFonts.sora(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(252, 71, 74, 68),
    ),
    labelMedium: GoogleFonts.urbanist(
        fontSize: 20,
        color: metricalColors.tertiary,
        fontWeight: FontWeight.bold));
