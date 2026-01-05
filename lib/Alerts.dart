import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../controller/themecontroller.dart';
import '../widget/theme_button.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final ThemeController themeController = Get.find<ThemeController>();

  final List<String> dummyAlerts = [
    "Flood alert in Sector F-10",
    "Traffic accident near Mall Road",
    "Fire reported in Commercial Market",
  ];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initAndroid();
    }
  }


  Future<void> _initAndroid() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(settings);


    final androidImpl = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();
  }

  void _sendNotification() {
    if (kIsWeb) {
      _sendWebNotification();
    } else {
      _sendAndroidNotification();
    }
  }


  Future<void> _sendAndroidNotification() async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'alerts_channel',
      'Alerts',
      channelDescription: 'Emergency alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'Emergency Alert',
      'This is a test notification',
      details,
    );
  }


  void _sendWebNotification() {
    if (!html.Notification.supported) {
      _snack("Browser does not support notifications");
      return;
    }

    if (html.Notification.permission == 'granted') {
      html.Notification(
        'Emergency Alert',
        body: 'This is a test notification',
      );
    } else {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(
            'Emergency Alert',
            body: 'This is a test notification',
          );
        } else {
          _snack("Notification permission denied");
        }
      });
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget buildGradientText(String text, {double fontSize = 24}) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [Colors.blue, Colors.purple])
              .createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return InkWell(
      onTap: _sendNotification,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient:
          const LinearGradient(colors: [Colors.blue, Colors.purple]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
          actions: [ThemeToggleButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildGradientText("Alerts", fontSize: 32),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: dummyAlerts.length,
                  itemBuilder: (_, i) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      dummyAlerts[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              buildButton("Send Test Notification"),
            ],
          ),
        ),
      );
    });
  }
}
