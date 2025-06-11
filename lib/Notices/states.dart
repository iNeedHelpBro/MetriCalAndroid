import 'package:flutter/material.dart';

final snackbar = GlobalKey<ScaffoldMessengerState>();
final navigate = GlobalKey<NavigatorState>();

class States {
  static States instance = States();

  void showtheSnackbar(
      {required title, int duration = 2, Color color = Colors.red}) {
    snackbar.currentState?.showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  Future<dynamic> pushAndReplaceName(String route) {
    return navigate.currentState!.pushReplacementNamed('/$route');
  }
}
