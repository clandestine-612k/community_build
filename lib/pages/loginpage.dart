// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'package:community_build/pages/homepage.dart';
import 'package:community_build/pages/signup_page.dart';
import 'package:community_build/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late bool _passwordVisible;
  final _formKey = GlobalKey<FormState>();

  Future<void> Login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MyHomePage(uid: _auth.currentUser!.uid)));
          print("LoggedIn successfully!");
        }
      } on FirebaseAuthException catch (ex) {
        UiHelper.customAlertBox(context, ex.code.toString());
      } catch (e) {
        UiHelper.customAlertBox(context, 'An error occurred');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.customTextField(
              emailController,
              "Email",
              Icons.mail,
              false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            // UiHelper.customTextField(
            //   passwordcontroller,
            //   "Password",
            //   Icons.password,
            //   true,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a password';
            //     }
            //     if (value.length < 8) {
            //       return 'Please enter a password with at least 8 characters';
            //     }
            //     return null;
            //   },
            // ),
            UiHelper.customTextFieldP(
              passwordcontroller,
              "Password",
              IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              _passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Please enter a password with at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            UiHelper.customButton(() async {
              Login(
                  emailController.text.trim(), passwordcontroller.text.trim());
            }, "Login"),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an Account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
