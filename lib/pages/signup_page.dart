// import 'package:community_build/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:community_build/uihelper.dart';
// import 'package:flutter/widgets.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();

//   signUp(String email, String password) async {
//     if (email == "" && password == "") {
//       UiHelper.customAlertBox(context, "Enter required fields");
//       return;
//     } else {
//       UserCredential? usercredential;
//       try {
//         usercredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password)
//             .then((value) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => MyHomePage()));
//           return null;
//         });
//         return;
//       } on FirebaseAuthException catch (ex) {
//         return UiHelper.customAlertBox(context, ex.code.toString());
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Up Page"),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           UiHelper.customTextField(emailController, "Email", Icons.mail, false),
//           UiHelper.customTextField(
//               passwordcontroller, "Password", Icons.password, true),
//           const SizedBox(
//             height: 30,
//           ),
//           UiHelper.customButton(() {
//             signUp(emailController.text.toString(),
//                 passwordcontroller.text.toString());
//           }, "Sign Up")
//         ],
//       ),
//     );
//   }
// }

// import 'package:community_build/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:community_build/uihelper.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   signUp(String email, String password) async {
//     if (email.isEmpty || password.isEmpty) {
//       UiHelper.customAlertBox(context, "Enter required fields");
//       return;
//     } else {
//       try {
//         await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password);
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => MyHomePage()));
//       } on FirebaseAuthException catch (ex) {
//         UiHelper.customAlertBox(context, ex.code.toString());
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Up Page"),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           UiHelper.customTextField(emailController, "Email", Icons.mail, false),
//           UiHelper.customTextField(
//               passwordController, "Password", Icons.password, true),
//           const SizedBox(
//             height: 30,
//           ),
//           UiHelper.customButton(() {
//             signUp(emailController.text.trim(), passwordController.text.trim());
//           }, "Sign Up")
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_build/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community_build/uihelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  late bool _passwordVisible;

  Future<void> signUp(String name, String email, String password) async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          print("Account created successfully");
          user.user!.updateDisplayName(name);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(uid: _auth.currentUser!.uid)));

          await _firestore.collection("users").doc(_auth.currentUser?.uid).set(
            {
              "name": name,
              "email": email,
              "status": "Unavailable",
              "uid": _auth.currentUser?.uid
            },
          );
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
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Page"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.customTextField(
              nameController,
              "Full Name",
              Icons.man,
              false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
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
            UiHelper.customTextFieldP(
              passwordController,
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
            UiHelper.customButton(() {
              signUp(nameController.text.trim(), emailController.text.trim(),
                  passwordController.text.trim());
            }, "Sign Up")
          ],
        ),
      ),
    );
  }
}
