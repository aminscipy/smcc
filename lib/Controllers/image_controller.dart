import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as i;
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var postPic =
      'https://firebasestorage.googleapis.com/v0/b/cc-smcc.appspot.com/o/monalisa.jpg?alt=media&token=128c3f04-9a92-477e-9cd5-ead4ccf647f0'
          .obs;
  var isLoading = false.obs;
  postPicture() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    XFile? postImage;
    try {
      isLoading.value = true;
      postImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      Reference reference = storage.ref().child("image");
      UploadTask uploadTask = reference.putFile((i.File(postImage!.path)));
      postPic.value = (await (await uploadTask).ref.getDownloadURL());
      isLoading.value = false;
    } catch (e) {
      'image not selected';
      isLoading.value = false;
    }
  }
}

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
