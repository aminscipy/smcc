import 'package:cc/Controllers/audio_controller.dart';
import 'package:cc/Controllers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ImageController imageController = Get.put(ImageController());
    AudioController audioController = Get.put(AudioController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMCC'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              alignment: Alignment.center,
              // color: Colors.black12,
              child: Obx(
                () => Image.network(
                  imageController.postPic.value == ''
                      ? 'https://firebasestorage.googleapis.com/v0/b/smcc-21cb2.appspot.com/o/image%2F21294.png?alt=media&token=229c6eb0-91eb-4e47-90f7-2f80f08f069f'
                      : imageController.postPic.value,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await imageController.postPicture();
              },
              icon: const Icon(Icons.image)),
          Obx(() => Text(audioController.fileName.value == ''
              ? 'No audio added'
              : audioController.fileName.value)),
          IconButton(
              onPressed: () async {
                await audioController.uploadAudio();
              },
              icon: const Icon(Icons.audio_file)),
          IconButton(
              onPressed: () async {
                FlutterSoundPlayer player = FlutterSoundPlayer();
                await player.openPlayer();
                await player.startPlayer(
                    fromURI: audioController.downloadUrl.value);
              },
              icon: const Icon(Icons.play_arrow)),
        ],
      ),
    );
  }
}
