import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:community_build/voice_assistance/featues_box.dart';
import 'package:community_build/voice_assistance/geminiai_services.dart';
import 'package:community_build/voice_assistance/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gif/gif.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistance extends StatefulWidget {
  const VoiceAssistance({super.key});

  @override
  State<VoiceAssistance> createState() => _VoiceAssistanceState();
}

class _VoiceAssistanceState extends State<VoiceAssistance>
    with TickerProviderStateMixin {
  final Gemini gemini = Gemini.instance;
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final GeminiAIService geminiAIService = GeminiAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  late final GifController controller;
  File? _image;

  @override
  void initState() {
    controller = GifController(vsync: this);
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  Future<void> selectAndUploadImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('Ahana'),
        ),
        // leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // virtual assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 125,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Gif(
                        autostart: Autostart.loop,
                        placeholder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        image: const AssetImage('assets/images/vassm1.gif'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Hola, what task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null ? 25 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // features list
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'Gemini',
                      descriptionText:
                          'A smarter way to stay organized and informed with Gemini',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Image Description',
                      descriptionText:
                          'Get inspired, stay creative and ask about whatever image you want with your personal assistant powered by Gemini',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Get the best of assistance in the app itself, now you don\'t have to go anywhere else for help with a voice assistant',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          ZoomIn(
            delay: Duration(milliseconds: start + 3 * delay),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Pallete.firstSuggestionBoxColor,
                onPressed: () async {
                  if (await speechToText.hasPermission &&
                      speechToText.isNotListening) {
                    await startListening();
                  } else if (speechToText.isListening) {
                    final speech = await geminiAIService
                        .geminiAPIf("Give response of " + lastWords);
                    if (speech.contains('https')) {
                      setState(() {
                        generatedImageUrl = speech;
                        generatedContent = null;
                      });
                    } else {
                      setState(() {
                        generatedImageUrl = null;
                        generatedContent = speech;
                      });
                      await systemSpeak(speech);
                    }
                    await stopListening();
                  } else {
                    initSpeechToText();
                  }
                },
                child: Icon(
                  speechToText.isListening ? Icons.stop : Icons.mic,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0), // Adjust as needed
            child: ZoomIn(
              delay: Duration(milliseconds: start + 3 * delay),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Pallete.secondSuggestionBoxColor,
                  onPressed: () async {
                    try {
                      await selectAndUploadImage();
                      if (_image != null) {
                        final speech = await geminiAIService.imagedescription(
                          'Describe the given image in details',
                          _image!,
                        );
                        setState(() {
                          generatedContent = speech;
                        });
                        await systemSpeak(speech);
                      } else {
                        // Handle the case where no image was picked
                        print('No image selected');
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: const Icon(Icons.upload),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
