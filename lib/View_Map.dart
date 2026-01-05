import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controller/themecontroller.dart';
import '../widget/theme_button.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  List<MarkerData> markers = [];

  final ThemeController themeController = Get.find<ThemeController>();

  void _addMarker(LatLng point) {
    setState(() {
      markers.add(
        MarkerData(
          position: point,
          title: 'New Marker',
        ),
      );
    });
  }

  void _editMarker(int index) {
    TextEditingController controller =
    TextEditingController(text: markers[index].title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [Colors.blue, Colors.purple])
                  .createShader(bounds),
          child: Text(
            'Edit Marker',
            style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Marker Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                markers[index].title = controller.text;
              });
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteMarker(int index) {
    setState(() {
      markers.removeAt(index);
    });
    Navigator.pop(context);
  }

  Widget buildGradientContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      LinearGradient(colors: [Colors.blue, Colors.purple])
                          .createShader(bounds),
                  child: Text(
                    "View Map",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: buildGradientContainer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(33.6844, 73.0479),
                        initialZoom: 13,
                        onTap: (tapPosition, point) {
                          _addMarker(point);
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: List.generate(markers.length, (index) {
                            return Marker(
                              point: markers[index].position,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor:
                                      isDark ? Colors.grey[900] : Colors.white,
                                      title: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                              colors: [Colors.blue, Colors.purple],
                                            ).createShader(bounds),
                                        child: Text(
                                          markers[index].title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: Text(
                                        'Choose an action',
                                        style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      actions: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            _editMarker(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.purple
                                                  ]),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'Edit',
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => _deleteMarker(index),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.red,
                                                    Colors.orange
                                                  ]),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'Delete',
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                  ).createShader(bounds),
                                  child: const Icon(
                                    Icons.location_pin,
                                    size: 40,
                                    color: Colors.white,),),
                              ),);
                          }),
                        ),],
                    ),),),
              ],
            ),
          ),),);});
  }
}

class MarkerData {
  LatLng position;
  String title;

  MarkerData({required this.position, required this.title});
}
