import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as i;
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var postPic = ''.obs;
  postPicture() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    XFile? postImage;
    loading();
    try {
      postImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      Reference reference = storage.ref().child("image/image");
      UploadTask uploadTask = reference.putFile((i.File(postImage!.path)));
      postPic.value = (await (await uploadTask).ref.getDownloadURL());
      Get.close(1);
    } catch (e) {
      'image not selected';
      Get.close(1);
    }
  }
}

loading() {
  Get.dialog(const Center(
    child: CircularProgressIndicator(color: Colors.white),
  ));
}