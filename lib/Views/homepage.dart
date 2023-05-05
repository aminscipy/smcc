import 'package:cc/Controllers/audio_controller.dart';
import 'package:cc/Controllers/image_controller.dart';
import 'package:cc/Controllers/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ImageController imageController = Get.put(ImageController());
    AudioController audioController = Get.put(AudioController());
    SignInController signInController = Get.put(SignInController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMCC'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: const Text('Log Out'),
                  onTap: () {
                    signInController.logOut();
                  })
            ];
          })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              alignment: Alignment.center,
              child: Obx(
                () => Image.network(
                  imageController.postPic.value == ''
                      ? 'https://firebasestorage.googleapis.com/v0/b/cc-smcc.appspot.com/o/monalisa.jpg?alt=media&token=128c3f04-9a92-477e-9cd5-ead4ccf647f0'
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
                if (audioController.downloadUrl.value != '') {
                  loading();
                  FlutterSoundPlayer player = FlutterSoundPlayer();
                  await player.openPlayer();
                  await player.startPlayer(
                      fromURI: audioController.downloadUrl.value);
                  Get.close(1);
                } else {
                  Fluttertoast.showToast(msg: 'No audio');
                }
              },
              icon: const Icon(Icons.play_arrow)),
        ],
      ),
    );
  }
}
