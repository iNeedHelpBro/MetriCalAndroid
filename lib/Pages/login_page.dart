import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/Pages/Modules/modules.dart';
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
  final confirmPasswordController = TextEditingController();
  //final nameController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLogin = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Metrical',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLogin = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLogin
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.urbanist(
                                  letterSpacing: 3,
                                  color:
                                      isLogin ? Colors.white : Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLogin = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !isLogin
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              'Register',
                              style: GoogleFonts.urbanist(
                                  letterSpacing: 3,
                                  color: !isLogin
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(isLogin ? 'Welcome back' : 'Create account',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    isLogin
                        ? 'Please enter your details to sign in'
                        : 'Please enter your details to register',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.blue[900]!, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.grey[600]),
                    ),
                    style: TextStyle(color: Colors.grey[800]),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.blue[900]!, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.grey[600]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.grey[800]),
                    obscureText: obscurePassword,
                  ),
                  if (!isLogin) ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.blue[900]!, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.grey[800]),
                      obscureText: obscureConfirmPassword,
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (isLogin) {
                          await _handleLogin();
                        } else {
                          await _handleRegister();
                        }
                      },
                      child: Text(isLogin ? 'Log In' : 'Sign Up',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          !isLogin
                              ? 'or create account with'
                              : 'or continue with',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      onPressed: () {
                        try {
                          if (!isLogin) {
                            SupabaseAuth.instance
                                .createAccountWithGoogle(context);
                          } else {
                            SupabaseAuth.instance.signInWithGoogle(context);
                          }
                        } catch (e) {
                          print('Error during sign-in: $e');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_icon.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isLogin
                                ? 'Log in with Google'
                                : 'Sign in with Google',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                          if (!isLogin) {
                            confirmPasswordController.clear();
                          }
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          text: isLogin
                              ? 'Don\'t have an account? '
                              : 'Already have an account? ',
                          style: TextStyle(color: Colors.grey[600]),
                          children: [
                            TextSpan(
                              text: isLogin ? 'Sign up' : 'Sign in',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
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
              color: Colors.yellow,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Modules(
                  userId: user.id,
                ),
              ),
            );
          } else {
            States.instance.showtheSnackbar(
              title: 'Invalid email or password. Please try again.',
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
            title: 'Account does not exist. Please create an account.',
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
          title: 'An unexpected error occurred. Please try again.',
          color: Colors.red,
        );
      }
    });
  }

  Future<void> _handleRegister() async {
    final email = emailController;
    final password = passwordController;
    final confirmPassword = confirmPasswordController;

    if (password.text != confirmPassword.text) {
      States.instance.showtheSnackbar(
        title: 'Passwords do not match',
        color: Colors.red,
      );
      return;
    }

    loadingDialog().then((val) async {
      EasyLoading.dismiss();
      try {
        final response = await SupabaseAuth.instance.signUp(
          email.text.trim(),
          password.text.trim(),
        );

        if (response.user != null) {
          States.instance.showtheSnackbar(
            title: 'Registration successful! You can now Login!',
            duration: 5,
            color: Colors.green,
          );
          setState(() {
            isLogin = true;
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
          });
        }
      } on AuthException catch (e) {
        States.instance.showtheSnackbar(
          title: e.message,
          color: Colors.red,
        );
      } catch (e) {
        States.instance.showtheSnackbar(
          title: 'An unexpected error occurred. Please try again.',
          color: Colors.red,
        );
      }
    });
  }
}
