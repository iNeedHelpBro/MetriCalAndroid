// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/Pages/Modules/modules.dart';
import 'package:metrical/Pages/home_page.dart';
import 'package:metrical/auth/google_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final supabaseClient = Supabase.instance.client;
  static SupabaseAuth instance = SupabaseAuth();

  static Future<void> initialize() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final supabaseAnonkey = dotenv.env['SUPABASE_ANONKEY']!;

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonkey,
    );
  }

  /*
  supabase getter
  */
  static SupabaseClient get client => Supabase.instance.client;

  Future<void> createAccountWithGoogle(BuildContext context) async {
    loadingDialog().then((v) async {
      try {
        await SupabaseAuth.instance.signOut();
        await GoogleAuth.instance.googleSignOut();
        final response = await supabaseClient.auth.signInWithOAuth(
            OAuthProvider.google,
            redirectTo: 'io.supabase.metricalandroid://login-callback/',
            queryParams: {'prompt': 'select_account'});
        States.instance.showtheSnackbar(
          title:
              'Continue with Google to complete account creation! if something went wrong, please restart the app!',
          duration: 5,
          color: yellowScheme,
        );
        EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              surfaceTintColor: Colors.black38,
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Something went wrong with your account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Lottie.asset('assets/animations/error_ani.json',
                        fit: BoxFit.fill, height: 170, width: 180),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Click Anywhere to continue',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
    // loadingDialog().then((val) async {
    //   try {
    //     final response = await supabase_client.auth.signInWithOAuth(
    //         OAuthProvider.google,
    //         redirectTo: kIsWeb
    //             ? null
    //             : 'io.supabase.metricalandroid://login-callback');
    //     if (response == true) {
    //       //States.instance.showtheSnackbar(title: 'Account Created!');
    //       EasyLoading.dismiss();
    //     }
    //   } catch (e) {
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return Dialog(
    //             surfaceTintColor: Colors.black38,
    //             elevation: 15,
    //             child: Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   const Text(
    //                     'Something went wrong with your account',
    //                     style: TextStyle(
    //                       fontSize: 18,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   Lottie.asset('assets/animations/error_ani.json',
    //                       fit: BoxFit.fill, height: 170, width: 180),
    //                   //Icon(Icons.check_circle, color: Colors.green, size: 70),
    //                   TextButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                     child: const Text('Click Anywhere to continue',
    //                         style: TextStyle(color: Colors.blue)),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    loadingDialog().then((v) async {
      try {
        await GoogleAuth.instance.googleSignOut();
        final response = await GoogleAuth.instance.googleSignIn();
        final user = response.user;
        if (response.session != null && response.session != null) {
          EasyLoading.dismiss();
          States.instance.showtheSnackbar(
              title: 'Logged In Successfully!',
              duration: 5,
              color: yellowScheme);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Modules(
                userId: user!.id,
              ),
            ),
          );
        } else {
          States.instance.showtheSnackbar(
              title: 'Google Sign-In failed. Please try again.');
          EasyLoading.dismiss();
        }
      } catch (e) {
        States.instance.showtheSnackbar(title: 'Google Sign-In Error at: $e.');
        EasyLoading.dismiss();
      }
    });
  }

/*

Signing with user's account

*/

  Future<AuthResponse> signIn(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

/*

Creating account

*/
  Future<AuthResponse> signUp(String email, String password) async {
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

/*

Logout account

*/
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

/*

Get users account details

*/
  String getCurrentUser() {
    final session = supabaseClient.auth.currentSession;
    final user = session?.user;
    final userDisplayName = user?.userMetadata?['name'] as String?;

    if (userDisplayName != null && userDisplayName.isNotEmpty) {
      return userDisplayName;
    } else if (user != null) {
      return cutTo(user.email);
    } else {
      return 'User';
    }
  }

  void forgotPassword(TextEditingController password) async {
    final newPass = password.text.trim();

    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPass),
      );
      States.instance.showtheSnackbar(title: 'Passowrd updated!');
    } catch (e) {
      States.instance.showtheSnackbar(title: 'Error resetting password');
      print('Error: $e');
    }
  }
}
