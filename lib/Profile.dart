import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/themecontroller.dart';
import '../widget/theme_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController cnicController = TextEditingController();
  bool isVerified = false;

  File? imageFile;
  Uint8List? webImage;

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    loadVerificationStatus();
  }

  Future<void> loadVerificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isVerified = prefs.getBool('verified') ?? false;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        webImage = await picked.readAsBytes();
      } else {
        imageFile = File(picked.path);
      }
      setState(() {});
    }
  }


  Future<void> verifyUser() async {

    if (cnicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CNIC cannot be empty")),
      );
      return;
    }

    if (cnicController.text.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid CNIC")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('verified', true);

    setState(() => isVerified = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User Verified Successfully")),
    );
  }


  Widget buildGradientButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGradientText(String text, {double fontSize = 24}) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [Colors.blue, Colors.purple])
              .createShader(bounds),
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

  Widget buildGradientBorderTextField(
      {required TextEditingController controller,
        required String label,
        required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
      ),
      padding: const EdgeInsets.all(2),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
          TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDark = themeController.isDarkBg.value;

      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ThemeToggleButton(),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: buildGradientText("User Profile", fontSize: 28),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: kIsWeb
                      ? (webImage != null
                      ? MemoryImage(webImage!)
                      : null)
                      : (imageFile != null
                      ? FileImage(imageFile!)
                      : null) as ImageProvider?,
                  child: (imageFile == null && webImage == null)
                      ? const Icon(Icons.camera_alt,
                      size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              buildGradientBorderTextField(
                  controller: cnicController,
                  label: "CNIC ",
                  isDark: isDark),
              const SizedBox(height: 20),
              buildGradientButton(text: "Verify User", onTap: verifyUser),
              const SizedBox(height: 20),
              Text(
                isVerified ? "Status: VERIFIED" : "Status: NOT VERIFIED",
                style: TextStyle(
                  color: isVerified ? Colors.blue : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
