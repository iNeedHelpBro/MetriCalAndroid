import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/Pages/forgot_password_page.dart';
import 'package:metrical/Pages/login_page.dart';
import 'package:metrical/auth/auth_stats.dart';
import 'package:metrical/auth/supabase_auth.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:metrical/services/services.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseAuth.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? sub;

  @override
  void initState() {
    super.initState();
    Services.services.sessionUniLink();
    Services.services.forgotPasswordUniLinks(sub!);
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/login': (context) => const LoginPage(),
          '/forgotpass': (context) => const ForgotPasswordPage()
        },
        navigatorKey: navigate,
        scaffoldMessengerKey: snackbar,
        builder: EasyLoading.init(),
        theme: ThemeData(
            useMaterial3: true, textTheme: themes, colorScheme: metricalColors),
        title: 'MetriCal App',
        home: const AuthStats());
  }
}
