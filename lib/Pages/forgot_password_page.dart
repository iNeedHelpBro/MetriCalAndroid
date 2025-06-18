// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:metrical/auth/supabase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(23),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                label: Text('Enter your email'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                SupabaseAuth.instance.forgotPassword(email);
              },
              child: Text('Send reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
