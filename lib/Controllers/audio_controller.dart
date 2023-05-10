import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioController extends GetxController {
  final fileName = ''.obs;
  final downloadUrl = ''.obs;
  var isLoading = false.obs;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> uploadAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      fileName.value = result.files.single.name;

      try {
        isLoading.value = true;
        // Step 1: Upload the audio file to Firebase Storage
        Reference ref = storage.ref().child('audio');

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;

        Fluttertoast.showToast(msg: 'Audio file uploaded successfully!');

        // Step 2: Get the download URL of the audio file
        downloadUrl.value = await taskSnapshot.ref.getDownloadURL();

        debugPrint('Download URL: $downloadUrl');
        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        debugPrint('Error: $error');
      }
    }
  }

  var isPlaying = false.obs;
  playAudio() async {
    try {
      if (downloadUrl.value != '') {
        isPlaying.value = true;
        FlutterSoundPlayer player = FlutterSoundPlayer();
        await player.openPlayer();
        await player.startPlayer(fromURI: downloadUrl.value);
        isPlaying.value = false;
      } else {
        Fluttertoast.showToast(msg: 'No audio');
        isPlaying.value = false;
      }
    } catch (e) {
      isPlaying.value = false;
      Fluttertoast.showToast(msg: 'Somethin went wrong, please upload again');
    }
  }

  FlutterTts flutterTts = FlutterTts();
  var hindiFemale = {"name": "hi-in-x-cfn#female_1-local", "locale": "hi-IN"};
  var hindiMale = {"name": "hi-in-x-cfn#male_2-local", "locale": "hi-IN"};
  var englishMale = {"name": "en-us-x-sfg#male_3-local", "locale": "en-US"};
  var englishFemale = {"name": "en-us-x-sfg#female_2-local", "locale": "en-US"};

  textToAudio(gender, text, language) async {
    try {
      await flutterTts
          .setVoice(gender == 'Male' && language == 'English'
              ? englishMale
              : gender == 'Female' && language == 'English'
                  ? englishFemale
                  : gender == 'Female' && language == 'Hindi'
                      ? hindiFemale
                      : hindiMale)
          .then((value) => flutterTts.synthesizeToFile(
                text,
                Platform.isAndroid ? "audio.wav" : "audio.caf",
              ));

      print(language + gender);
      File audioFile =
          File('/storage/emulated/0/Android/data/com.cc.smcc/files/audio.wav');
      try {
        isLoading.value = true;
        // Step 1: Upload the audio file to Firebase Storage
        Reference ref = storage.ref().child('audio');

        UploadTask uploadTask = ref.putFile(audioFile);
        TaskSnapshot taskSnapshot = await uploadTask;

        Fluttertoast.showToast(msg: 'converted and uploaded successfully!');

        // Step 2: Get the download URL of the audio file
        downloadUrl.value = await taskSnapshot.ref.getDownloadURL();

        debugPrint('Download URL: $downloadUrl');
        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        debugPrint('Error: $error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong, please upload again');
    }
  }
}
