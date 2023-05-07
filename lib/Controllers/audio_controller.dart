import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AudioController extends GetxController {
  final fileName = ''.obs;
  final downloadUrl = ''.obs;
  var isLoading = false.obs;
  Future<void> uploadAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      fileName.value = result.files.single.name;

      final FirebaseStorage storage = FirebaseStorage.instance;

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

  var isPlay = false.obs;
  playAudio() async {
    if (downloadUrl.value != '') {
      isPlay.value = true;
      FlutterSoundPlayer player = FlutterSoundPlayer();
      await player.openPlayer();
      await player.startPlayer(fromURI: downloadUrl.value);
      isPlay.value = false;
    } else {
      Fluttertoast.showToast(msg: 'No audio');
    }
  }
}
