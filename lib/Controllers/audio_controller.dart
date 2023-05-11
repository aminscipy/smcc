import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class AudioController extends GetxController {
  final fileName = ''.obs;
  final downloadUrl = ''.obs;
  var isLoading = false.obs;
  var audio = ''.obs;
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
        await player.startPlayer(
          fromURI: downloadUrl.value,
          whenFinished: () async {
            await player.closePlayer();
            isPlaying.value = false;
          },
        );
      } else {
        Fluttertoast.showToast(msg: 'No audio');
        isPlaying.value = false;
      }
    } catch (e) {
      isPlaying.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  var isConverting = false.obs;
  FlutterTts flutterTts = FlutterTts();
  textToAudio(text, language, gender) async {
    try {
      isConverting.value = true;
      final String serviceAccountJson =
          await rootBundle.loadString('assets/service-key.json');
      final Map<String, dynamic> serviceAccountMap =
          json.decode(serviceAccountJson);
      final credentials = ServiceAccountCredentials.fromJson(serviceAccountMap);
      final client = await clientViaServiceAccount(
          credentials, [TexttospeechApi.cloudPlatformScope]);
      final textToSpeechApi = TexttospeechApi(client);
      final synthesisInput = SynthesisInput(text: text);
      final audioConfig = AudioConfig(audioEncoding: 'MP3');
      final request = SynthesizeSpeechRequest(
        input: synthesisInput,
        voice: VoiceSelectionParams(
            languageCode: language == 'English'
                ? 'en-US'
                : language == 'Marathi'
                    ? 'mr-IN'
                    : language == 'Hindi'
                        ? 'hi-IN'
                        : 'pa-IN',
            name: gender == "Male" && language == 'English'
                ? 'en-US-Wavenet-B'
                : gender == "Female" && language == 'English'
                    ? 'en-US-Wavenet-C'
                    : gender == "Male" && language == 'Hindi'
                        ? 'hi-IN-Wavenet-B'
                        : gender == "Female" && language == 'Hindi'
                            ? 'hi-IN-Wavenet-A'
                            : gender == "Male" && language == 'Marathi'
                                ? 'mr-IN-Wavenet-B'
                                : gender == "Female" && language == 'Marathi'
                                    ? 'mr-IN-Wavenet-A'
                                    : gender == "Male" && language == 'Punjabi'
                                        ? 'pa-IN-Wavenet-B'
                                        : 'pa-IN-Wavenet-A'),
        audioConfig: audioConfig,
      );
      final response = await textToSpeechApi.text.synthesize(request);
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final outputFile = File('$path/audio.mp3');
      audio.value = '$path/audio.mp3';
      await outputFile.writeAsBytes(response.audioContentAsBytes);
      try {
        // Step 1: Upload the audio file to Firebase Storage
        Reference ref = storage.ref().child('audio');
        final metadata = SettableMetadata(contentType: 'audio/mp3');
        UploadTask uploadTask = ref.putFile(outputFile, metadata);
        TaskSnapshot taskSnapshot = await uploadTask;
        Fluttertoast.showToast(msg: 'converted and uploaded successfully!');
        // Step 2: Get the download URL of the audio file
        downloadUrl.value = await taskSnapshot.ref.getDownloadURL();
        debugPrint('Download URL: $downloadUrl');
        isConverting.value = false;
      } catch (error) {
        isConverting.value = false;
        debugPrint('Error: $error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      isConverting.value = false;
    }
  }
}
