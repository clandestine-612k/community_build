import 'dart:developer';
import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiAIService {
  final Gemini gemini = Gemini.instance;
  //final List<Map<String, String>> messages = [];

  // Future<String> isArtPromptAPI(String prompt) async {

  // }

  Future<String> geminiAPIf(String prompt) async {
    var content;
    gemini.streamGenerateContent(prompt).listen((value) {
      print(value.output);
      content = value.output;
      print(content);
    }).onError((e) {
      log('streamGenerateContent exception', error: e);
    });
    return content;
  }

  Future<String> imagedescription(String prompt, String imageurl) async {
    final file = File(imageurl);
    var content;
    gemini
        .textAndImage(
            text: prompt,

            /// text
            images: [file.readAsBytesSync()]

            /// list of images
            )
        .then((value) => content = value?.content?.parts?.last.text ?? '')
        .catchError((e) => log('textAndImageInput', error: e));
    return content;
  }
}
