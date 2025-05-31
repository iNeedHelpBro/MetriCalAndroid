import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/auth/auth_stats.dart';
import 'package:metrical/auth/supabase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseAuth.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigate,
        scaffoldMessengerKey: snackbar,
        builder: EasyLoading.init(),
        theme: ThemeData(useMaterial3: true),
        title: 'MetriCal App',
        home: AuthStats());
  }
}
