import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Deleteaccount extends StatefulWidget {
  const Deleteaccount({super.key});

  @override
  State<Deleteaccount> createState() => _DeleteaccountState();
}

class _DeleteaccountState extends State<Deleteaccount> {
  final Uri _url = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSeLfSj9-XhP_xoC826n3JS1W6HIdfUcshOGZ0xXEMosPOHqpA/viewform?usp=sf_link');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Deletion"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchUrl,
          child: Text('Delete Account'),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
