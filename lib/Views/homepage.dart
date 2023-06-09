import 'package:cc/Controllers/audio_controller.dart';
import 'package:cc/Controllers/image_controller.dart';
import 'package:cc/Controllers/video_controller.dart';
import 'package:cc/Controllers/sign_in_controller.dart';
import 'package:cc/Views/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String gender = 'Female';
String language = 'English';
String text = '';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ImageController imageController = Get.put(ImageController());
    AudioController audioController = Get.put(AudioController());
    SignInController signInController = Get.put(SignInController());
    VideoController runModel = Get.put(VideoController());
    List padding = [0, 0, 0, 0];
    // List of items in our dropdown menu
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMCC'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: const Text('Video Player'),
                  onTap: () {
                    Future.delayed(const Duration(seconds: 0))
                        .then((value) => Get.to(() => const PlayVideo()));
                  }),
              PopupMenuItem(
                  child: const Text('Log Out'),
                  onTap: () async {
                    await signInController.logOut();
                  }),
            ];
          })
        ],
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                alignment: Alignment.center,
                child: Obx(() => FadeInImage.assetNetwork(
                      placeholder: 'assets/monalisa.jpg',
                      image: imageController.postPic.value,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 500),
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => imageController.isLoading.value
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: const Center(
                                child: LinearProgressIndicator(
                              color: Colors.black,
                            ))),
                      )
                    : TextButton.icon(
                        style: TextButton.styleFrom(iconColor: Colors.black),
                        label: const Text(
                          'add image',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          await imageController.postPicture();
                        },
                        icon: const Icon(Icons.add_a_photo))),
                Obx(() => audioController.isLoading.value
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Center(
                            child: LinearProgressIndicator(
                          color: Colors.black,
                        )))
                    : TextButton.icon(
                        style: TextButton.styleFrom(iconColor: Colors.black),
                        label: const Text('add audio',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () async {
                          await audioController.uploadAudio();
                        },
                        icon: const Icon(Icons.audio_file))),
                Obx(() => audioController.isPlaying.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: const Center(
                                child: LinearProgressIndicator(
                              color: Colors.black,
                            ))),
                      )
                    : TextButton.icon(
                        style: TextButton.styleFrom(iconColor: Colors.black),
                        label: const Text('Play audio',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () async {
                          await audioController.playAudio();
                        },
                        icon: const Icon(Icons.play_arrow))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Flexible(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        padding = value.split(',');
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add padding - 4 values',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: Row(
                children: [
                  Flexible(
                      child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        text = value;
                      },
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Text to Audio',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: gender,
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female'))
                  ],
                  onChanged: (newValue) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
                DropdownButton(
                  value: language,
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                    DropdownMenuItem(value: 'Marathi', child: Text('Marathi')),
                    DropdownMenuItem(value: 'Punjabi', child: Text('Punjabi')),
                  ],
                  onChanged: (newValue) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      language = newValue!;
                    });
                  },
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
                Obx(() => audioController.isConverting.value
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Center(
                            child: LinearProgressIndicator(
                          color: Colors.black,
                        )))
                    : TextButton.icon(
                        onPressed: () async {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          if (text != '') {
                            await audioController.textToAudio(
                                text, language, gender);
                          } else {
                            Fluttertoast.showToast(msg: 'Add text first');
                          }
                        },
                        icon: const Icon(
                          Icons.run_circle,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Convert',
                          style: TextStyle(color: Colors.black),
                        )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Obx(() => TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (audioController.downloadUrl.value != '' &&
                          imageController.postPic.value != '') {
                        runModel.isLoading.value == false
                            ? runModel.generateVideo(
                                imageController.postPic.value,
                                audioController.downloadUrl.value,
                                padding)
                            : null;
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please add image and audio');
                      }
                    },
                    child: runModel.isLoading.value
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: const Center(
                                child: LinearProgressIndicator(
                              color: Colors.black,
                            )))
                        : const Text('generate',
                            style: TextStyle(color: Colors.black)))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
