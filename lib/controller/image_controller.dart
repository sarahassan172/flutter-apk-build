import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
var isSevere=false.obs;
  RxList<XFile> androidImages = <XFile>[].obs;
  RxList<Uint8List> webImages = <Uint8List>[].obs;


  Future<void> pickFromGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null || images.isEmpty) return;

    if (kIsWeb) {
      for (var img in images) {
        final bytes = await img.readAsBytes();
        webImages.add(bytes);
      }
    } else {
      androidImages.addAll(images);
    }
  }


  Future<void> pickFromCamera() async {
    if (kIsWeb) {
      Get.snackbar("Notice", "Camera not supported on Web");
      return;
    }

    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      androidImages.add(image);
    }
  }


  void deleteImage(int index) {
    if (kIsWeb) {
      webImages.removeAt(index);
    } else {
      androidImages.removeAt(index);
    }
  }


  Future<void> editImage(BuildContext context, int index) async {
    if (kIsWeb) return;

    File file = File(androidImages[index].path);

    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (cropped != null) {
      androidImages[index] = XFile(cropped.path);
    }
  }
}
