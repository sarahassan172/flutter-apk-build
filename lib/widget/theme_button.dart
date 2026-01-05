import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/themecontroller.dart';




class ThemeToggleButton extends StatelessWidget {
  ThemeToggleButton({super.key});
  final ThemeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
      onPressed: controller.toggleBackground,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: controller.isDarkBg.value
            ? const Icon(Icons.dark_mode, key: ValueKey("dark"), color: Colors.purple)
            : const Icon(Icons.light_mode, key: ValueKey("light"), color: Colors.blue),
      ),
    ));
  }
}
