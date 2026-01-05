import 'package:flutter/material.dart';
import 'package:get/get.dart';




class ThemeController extends GetxController {
  RxBool isDarkBg = false.obs;

  void toggleBackground() {
    isDarkBg.value = !isDarkBg.value;
  }
}

