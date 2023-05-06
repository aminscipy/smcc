import 'dart:convert';
import 'dart:io';
import 'package:cc/Controllers/image_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RunModel extends GetxController {
  void generateVideo(imagePath, audioPath) async {
    loading();
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
    // request.fields['padding'] = padding;

    // Send request and handle response
    var response = await request.send();
    if (response.statusCode == HttpStatus.ok) {
      var responseData = await response.stream.bytesToString();
      var parsedResponse = jsonDecode(responseData);
      Fluttertoast.showToast(msg: 'Video generated successfully.');
      Get.close(1);
    } else {
      Fluttertoast.showToast(msg: 'Failed to generate video.');
      Get.close(1);
    }
  }
}
