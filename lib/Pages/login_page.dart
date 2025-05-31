import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/Pages/home_page.dart';
import 'package:metrical/Pages/profile_page.dart';
import 'package:metrical/Pages/signup_page.dart';
import 'package:metrical/auth/supabase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In with your Account'),
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
                'Hello!, Please Log In',
                style: TextStyle(fontSize: 24),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
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
                  final email = emailController;
                  final password = passwordController;

                  loadingDialog().then((val) async {
                    EasyLoading.dismiss();
                    try {
                      if (email.text.isEmpty || password.text.isEmpty) {
                        if (mounted) {
                          States.instance.showtheSnackbar(
                            title: 'Email and Password fields cannot be empty!',
                            color: Colors.red,
                          );
                        }
                      } else {
                        final response = await SupabaseAuth.instance
                            .signIn(email.text.trim(), password.text.trim());
                        final user = response.user;
                        if (user != null) {
                          States.instance.showtheSnackbar(
                            title: 'Logged In Successfully!',
                            duration: 5,
                            color: yellowScheme,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                userId: user.id,
                              ),
                            ),
                          );
                        } else {
                          States.instance.showtheSnackbar(
                            title:
                                'Invalid email or password. Please try again.',
                          );
                        }
                      }
                    } on AuthException catch (e) {
                      if (e.message.contains('Invalid login credentials')) {
                        States.instance.showtheSnackbar(
                          title: 'Invalid email or password. Please try again.',
                          color: Colors.red,
                        );
                      } else if (e.message.contains('User not found')) {
                        States.instance.showtheSnackbar(
                          title:
                              'Account does not exist. Please create an account.',
                          color: Colors.red,
                        );
                      } else {
                        States.instance.showtheSnackbar(
                          title: 'An error occurred: ${e.message}',
                          color: Colors.red,
                        );
                      }
                    } catch (e) {
                      States.instance.showtheSnackbar(
                        title:
                            'An unexpected error occurred. Please try again.',
                        color: Colors.red,
                      );
                    }
                  });
                },
                child: const Text('Log In'),
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
                onTap: () {
                  try {
                    SupabaseAuth.instance.signInWithGoogle(context);
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
                    return const SignUpPage();
                  }));
                },
                child: const Text(
                  '\nDon\'t have an account?',
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
