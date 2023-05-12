import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io' as i;
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var postPic = ''.obs;
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
