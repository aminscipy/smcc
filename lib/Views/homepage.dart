import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

TextToSpeech tts = TextToSpeech();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    tts.setRate(0.9);
    tts.getDisplayLanguages();
    tts.setLanguage('hindi');
    tts.setPitch(0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () {
              tts.speak(
                  'इस लेख में आप दुनिया के एक बहुत महान शासक सिकंदर महान का इतिहास के बारे में बताने वाले है। जिसमे हम आपको इनके जीवन की पूरी कहानी (Great Story) देंगे और साथ ही इनकी द्वारा लड़े गए कुछ महत्वपूर्ण युद्धों के बारे में बात करेंगे।');
            },
            icon: const Icon(Icons.play_arrow)),
      ),
    );
  }
}
