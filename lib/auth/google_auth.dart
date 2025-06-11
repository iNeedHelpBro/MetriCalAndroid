// ignore_for_file: non_constant_identifier_names

import 'package:google_sign_in/google_sign_in.dart';
import 'package:metrical/Notices/states.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuth {
  static GoogleAuth instance = GoogleAuth();
  final GoogleSignIn google_SignIn = GoogleSignIn(
      clientId:
          '963846678327-hkpr2l54n4tuvdpvje0amrc5ihndk5mo.apps.googleusercontent.com',
      serverClientId:
          '963846678327-h8tnn845fe2u2sikr89mf1lve5nnadva.apps.googleusercontent.com');
  GoogleAuth();
  Future<AuthResponse> googleSignIn() async {
    /*

    const webClientId =
        '963846678327-h8tnn845fe2u2sikr89mf1lve5nnadva.apps.googleusercontent.com';
    const iosClientId =
        '963846678327-hkpr2l54n4tuvdpvje0amrc5ihndk5mo.apps.googleusercontent.com';


  */
    final googleUser = await google_SignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> googleSignOut() async {
    try {
      await google_SignIn.signOut();
    } catch (e) {
      States.instance.showtheSnackbar(title: e);
    }
  }
}
