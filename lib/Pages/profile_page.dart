// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Pages/login_page.dart';

import '../auth/supabase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        elevation: 10,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Profile Page'),
            MaterialButton(
              onPressed: signOut,
              child: Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }

  void signOut() {
    loadingDialog().then((v) async {
      await SupabaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));

      EasyLoading.dismiss();
    });
  }
}
