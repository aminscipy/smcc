import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RunModel extends GetxController {
  var isLoading = false.obs;
  void generateVideo(imagePath, audioPath) async {
    try {
      isLoading.value = true;
      var imageUrl = imagePath; // Replace with actual image URL
      var audioUrl = audioPath; // Replace with actual audio URL
      // var padding = pads; // Or any other value you want to use for padding

      // Download image and audio files from network
      var imageResponse = await http.get(Uri.parse(imageUrl));
      var audioResponse = await http.get(Uri.parse(audioUrl));
      // Create multipart files from downloaded files
      var image = http.MultipartFile.fromBytes(
        'image',
        imageResponse.bodyBytes,
        filename: 'image.png',
      );
      var audio = http.MultipartFile.fromBytes(
        'audio',
        audioResponse.bodyBytes,
        filename: 'audio.wav',
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.43.201:5000/generate-video'),
      );
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files.add(image);
      request.files.add(audio);

      // Send request and handle response
      var response = await request.send();
      if (response.statusCode == HttpStatus.ok) {
        var responseData = await response.stream.bytesToString();
        // ignore: unused_local_variable
        var parsedResponse = jsonDecode(responseData);
        Fluttertoast.showToast(msg: 'Video generated successfully.');
      } else {
        Fluttertoast.showToast(msg: 'Failed to generate video.');
      }
      isLoading.value = false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to generate video.');
      isLoading.value = false;
    }
  }
}
