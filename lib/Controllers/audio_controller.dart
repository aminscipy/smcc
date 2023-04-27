import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AudioController extends GetxController {
  final fileName = ''.obs;
  final downloadUrl = ''.obs;

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
        // Step 1: Upload the audio file to Firebase Storage
        Reference ref = storage.ref().child('audio.mp3');

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;

        print('Audio file uploaded successfully!');

        // Step 2: Get the download URL of the audio file
        downloadUrl.value = await taskSnapshot.ref.getDownloadURL();

        print('Download URL: $downloadUrl');

        // // Step 3: Play the audio from the download URL
        // FlutterSoundPlayer player = FlutterSoundPlayer();
        // await player.openAudioSession();
        // await player.startPlayer(fromURI: _downloadUrl.value);
      } catch (error) {
        print('Error: $error');
      }
    }
  }
}
