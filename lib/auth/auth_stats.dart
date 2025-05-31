import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Pages/home_page.dart';
import 'package:metrical/Pages/login_page.dart';
import 'package:metrical/Pages/profile_page.dart';
import 'package:metrical/Pages/Modules/set_quota_page.dart';
import 'package:metrical/auth/supabase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStats extends StatefulWidget {
  const AuthStats({super.key});

  @override
  State<AuthStats> createState() => _AuthStatsState();
}

class _AuthStatsState extends State<AuthStats> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: SupabaseAuth.client.auth.onAuthStateChange,
        builder: (context, snaps) {
          if (snaps.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitPianoWave(
                color: yellowScheme,
                size: 27,
              ),
            );
          }

          if (!snaps.hasData) {
            return Center(
              child: SpinKitPianoWave(
                color: yellowScheme,
                size: 27,
              ),
            );
          }
          final sess = snaps.data!.session;
          if (sess != null) {
            return HomePage(
              userId: sess.user.aud,
            );
          } else {
            return const LoginPage();
          }
        });
  }
}
