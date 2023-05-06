import 'package:cc/Controllers/audio_controller.dart';
import 'package:cc/Controllers/image_controller.dart';
import 'package:cc/Controllers/run_model.dart';
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
    RunModel runModel = Get.put(RunModel());
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  alignment: Alignment.center,
                  child: Obx(
                    () => Image.network(
                      imageController.postPic.value,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                  style: TextButton.styleFrom(iconColor: Colors.black),
                  label: const Text(
                    'add image',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    await imageController.postPicture();
                  },
                  icon: const Icon(Icons.add_a_photo)),
              TextButton.icon(
                  style: TextButton.styleFrom(iconColor: Colors.black),
                  label: const Text('add audio',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    await audioController.uploadAudio();
                  },
                  icon: const Icon(Icons.audio_file)),
              TextButton.icon(
                  style: TextButton.styleFrom(iconColor: Colors.black),
                  label: const Text('Play audio',
                      style: TextStyle(color: Colors.black)),
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
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        loading();
                        runModel.generateVideo(imageController.postPic.value,
                            audioController.downloadUrl.value);
                        Get.close(1);
                      },
                      child: const Text('generate',
                          style: TextStyle(color: Colors.black))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
