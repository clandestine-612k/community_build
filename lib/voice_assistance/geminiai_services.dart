import 'dart:developer';
import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiAIService {
  final Gemini gemini = Gemini.instance;
  Future<String> geminiAPIf(String prompt) async {
    try {
      String content = '';

      // Using await to collect the complete response
      await for (var value in gemini.streamGenerateContent(prompt)) {
        content += value.output!; // Accumulate output if it's streamed
        print(value.output);
      }

      return content.isNotEmpty ? content : 'No content available';
    } catch (e) {
      log('streamGenerateContent exception', error: e);
      return 'Error occurred while generating content';
    }
  }

  Future<String> imagedescription(String prompt, File imageurl) async {
    try {
      final fileBytes = imageurl.readAsBytesSync();
      final response = await gemini.textAndImage(
        text: prompt,
        images: [fileBytes],
      );

      // Check for a valid response and extract content
      final content =
          response?.content?.parts?.last.text ?? 'No description available';
      return content;
    } catch (e) {
      log('textAndImageInput', error: e);
      return 'Error occurred while getting description';
    }
  }
}
