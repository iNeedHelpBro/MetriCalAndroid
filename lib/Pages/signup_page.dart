// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/Pages/login_page.dart';
import 'package:metrical/auth/supabase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final emailText = email;
                  final passwordText = password;

                  loadingDialog().then((val) async {
                    try {
                      if (isAGmailProvider(emailText.text)) {
                        await SupabaseAuth.instance.signUp(
                          emailText.text.trim(),
                          passwordText.text.trim(),
                        );
                        States.instance.showtheSnackbar(
                          title:
                              'Account Created! Start Logging with your account!',
                          duration: 5,
                          color: yellowScheme,
                        );
                        EasyLoading.dismiss();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      } else {
                        States.instance.showtheSnackbar(
                          title: 'Use @gmail.com instead and try again',
                          duration: 5,
                        );
                        EasyLoading.dismiss();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error creating account'),
                          ),
                        );
                        print(e);
                        EasyLoading.dismiss();
                      }
                    }
                  });
                },
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 147, 147, 147),
                      height: 10,
                      thickness: 1,
                      endIndent: 10,
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 147, 147, 147),
                      height: 10,
                      thickness: 1,
                      indent: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    SupabaseAuth.instance.createAccountWithGoogle(context);
                  } catch (e) {
                    print('Error during sign-in: $e');
                  }
                },
                child: Container(
                  //margin: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    'assets/images/google_icon.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                child: const Text(
                  '\nAlready Created an Account? Log In Here!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
