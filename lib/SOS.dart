import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/themecontroller.dart';
import '../widget/theme_button.dart';

class SOS extends StatefulWidget {
  const SOS({super.key});

  @override
  _SOSState createState() => _SOSState();
}

class _SOSState extends State<SOS> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late AudioPlayer _player;
  bool isSosActive = false;

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
    _player = AudioPlayer();
  }

  void toggleSOS() async {
    if (!isSosActive) {
      _blinkController.repeat(reverse: true);

      await _player.setSource(AssetSource('alarm/alarm.mp3'));
      _player.setReleaseMode(ReleaseMode.loop);
      _player.resume();

      setState(() {
        isSosActive = true;
      });
    } else {
      _blinkController.stop();
      _player.stop();

      setState(() {
        isSosActive = false;
      });
    }
  }


  Future<void> _callNumber(String number) async {
    final Uri telUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot launch dialer for $number")),
      );
    }
  }

  void showContacts() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Obx(() {
          final bool isDark = themeController.isDarkBg.value;
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Emergency Contacts",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactCard("Police", "1234567890", isDark),
                _buildContactCard("Fire Department", "9876543210", isDark),
                _buildContactCard("Ambulance", "5555555555", isDark),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContactCard(String name, String number, bool isDark) {
    return InkWell(
      onTap: () {
        _callNumber(number);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.purple),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGradientText(String text, {double fontSize = 36}) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [Colors.blue, Colors.purple]).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDark = themeController.isDarkBg.value;

      return AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          Color backgroundColor = isSosActive
              ? Color.lerp(
              isDark ? Colors.grey[900]! : Colors.white,
              Colors.purple.shade100,
              _blinkController.value)!
              : isDark
              ? Colors.black
              : Colors.white;

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions:  [ThemeToggleButton()],
            ),
            body: Stack(
              children: [
                Center(
                  child: ScaleTransition(
                    scale: _blinkController,
                    child: InkWell(
                      onTap: toggleSOS,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text("SOS",style:TextStyle(fontSize: 36 ,color:Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 40,
                  right: 40,
                  child: InkWell(
                    onTap: showContacts,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Contacts",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
