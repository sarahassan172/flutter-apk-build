
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/image_controller.dart';
import '../controller/themecontroller.dart';
import '../widget/theme_button.dart';

class ReportIncident extends StatelessWidget {
  ReportIncident({super.key});

  final ImageController controller = Get.put(ImageController());
  final ThemeController themeController = Get.find<ThemeController>();

  Future<bool> canReportSevereIncident() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('verified') ?? false;
  }

  Widget buildGradientButton({
    required Widget child,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.deepPurple, Colors.blueGrey]
                : [Colors.blue, Colors.purple],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget buildGradientText(String text, {double fontSize = 24}) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDark = themeController.isDarkBg.value;
      final bool isWeb = kIsWeb;

      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ThemeToggleButton(),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildGradientText("Report Incident", fontSize: 28),
                const SizedBox(height: 16),


                Row(
                  children: [
                    buildGradientButton(
                      isDark: isDark,
                      onTap: controller.pickFromGallery,
                      child: Row(
                        children: const [
                          Icon(Icons.photo, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Gallery",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),


                Obx(() => SwitchListTile(
                  title: Text(
                    "Mark as Severe Incident",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  value: controller.isSevere.value,
                  activeColor: Colors.purple,
                  onChanged: (value) async {
                    if (value) {
                      bool allowed = await canReportSevereIncident();
                      if (!allowed) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Only verified users can report severe incidents"),
                        ));
                        return;
                      }
                    }
                    controller.isSevere.value = value;
                  },
                )),

                const SizedBox(height: 16),


                Expanded(
                  child: Obx(() {
                    final int itemCount = isWeb
                        ? controller.webImages.length
                        : controller.androidImages.length;

                    if (itemCount == 0) {
                      return Center(
                        child: Text(
                          "No images selected",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(itemCount, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              Container(
                                height: 150,
                                margin:
                                const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [Colors.deepPurple, Colors.blueGrey]
                                        : [Colors.blue, Colors.purple],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: isWeb
                                          ? Image.memory(
                                        controller.webImages[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                          : Image.file(
                                        File(controller
                                            .androidImages[index].path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        cacheWidth: 600,
                                        cacheHeight: 600,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: InkWell(
                                        onTap: () =>
                                            controller.deleteImage(index),
                                        child: const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.black54,
                                          child: Icon(Icons.close,
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    if (!isWeb)
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: InkWell(
                                          onTap: () => controller.editImage(
                                              context, index),
                                          child: const CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.black54,
                                            child: Icon(Icons.edit,
                                                size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),


                              TextFormField(
                                maxLines: 2,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Incident Details",
                                  labelStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                  hintText:
                                  "Describe the incident for this image",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    );
                  }),
                ),


                buildGradientButton(
                  isDark: isDark,
                  onTap: () async {
                    if (controller.isSevere.value &&
                        !(await canReportSevereIncident())) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text(
                            "Only verified users can report severe incidents"),
                      ));
                      return;
                    }

                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text("Incident reported successfully"),
                    ));
                  },
                  child: const Text(
                    "Submit Incident",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}