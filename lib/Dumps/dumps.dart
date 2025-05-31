import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*

App Theme Scheme Color

*/
Color yellowScheme = const Color.fromARGB(255, 236, 255, 128);
Color darkScheme = const Color.fromARGB(255, 49, 52, 39);

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
  final loading =
      EasyLoading.show(indicator: SpinKitDualRing(color: yellowScheme));
  return loading;
}

/*

Check if the user creates an account with the @gmail.com as their provider

*/

bool isAGmailProvider(String? email) {
  return email != null && email.endsWith('@gmail.com');
}
