import 'package:community_build/firebase_options.dart';
import 'package:community_build/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

//AIzaSyCVDDSAGXxwsJtrUXdyltggbvFp6sd5bwg

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
  final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: "AIzaSyCVDDSAGXxwsJtrUXdyltggbvFp6sd5bwg");
  final content = [
    Content.text('Where is Harcourt Butler Technical university')
  ];
  final response = await model.generateContent(content);
  print(response.text);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Build',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 56, 24, 111)),
      ),
      home: const LoginPage(),
    );
  }
}
