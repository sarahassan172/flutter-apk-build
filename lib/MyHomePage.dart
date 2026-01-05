import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../widget/theme_button.dart';
import '../controller/themecontroller.dart';
import 'Report_Incident.dart';
import 'View_Map.dart';
import 'Alerts.dart';
import 'Profile.dart';
import 'SOS.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ThemeController controller = Get.find();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String searchText = "";

  final List<Map<String, String>> incidents = [
    {"title": "Commerical Market", "image": "assets/images/comercial.jpg"},
    {"title": "Numl fire", "image": "assets/images/numl.jpg"},
    {"title": "Flood Alert", "image": "assets/images/teargas.jpg"},];

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: controller.isDarkBg.value ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: searchController,
          focusNode: searchFocus,
          onChanged: (val) {
            setState(() {
              searchText = val.toLowerCase();
            });
          },
          style: TextStyle(
            color: controller.isDarkBg.value ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "Search incidents...",
            hintStyle: TextStyle(
                color: controller.isDarkBg.value ? Colors.white54 : Colors.black54),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(colors: [Colors.blue, Colors.purple])
                      .createShader(bounds),
              child: const Icon(Icons.search, color: Colors.white),
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,),
          ),),
      ),);
  }

  List<Widget> getFilteredIncidents() {
    List<Map<String, String>> filtered = incidents
        .where((item) => item["title"]!.toLowerCase().contains(searchText))
        .toList();

    return filtered.map((item) {
      return Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: controller.isDarkBg.value ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  item["image"]!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  item["title"]!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: controller.isDarkBg.value ? Colors.white : Colors.black,
                  ),),
              ),
            ],),),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: controller.isDarkBg.value ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: controller.isDarkBg.value ? Colors.black : Colors.white,
        elevation: 0,
        actions: [ThemeToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(colors: [Colors.blue, Colors.purple])
                      .createShader(bounds),
              child: Text(
                "Recent Incidents",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: controller.isDarkBg.value
                      ? Colors.white
                      : Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildSearchBar(),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getFilteredIncidents(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: controller.isDarkBg.value ? Colors.black : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportIncident()));
              },
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(colors: [Colors.blue, Colors.purple])
                        .createShader(bounds),
                child: const Icon(FontAwesomeIcons.personFallingBurst,
                    size: 28, color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewMap()));
              },
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(colors: [Colors.blue, Colors.purple])
                        .createShader(bounds),
                child: const Icon(FontAwesomeIcons.mapLocationDot,
                    size: 28, color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Alerts()));
              },
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(colors: [Colors.blue, Colors.purple])
                        .createShader(bounds),
                child: const Icon(FontAwesomeIcons.triangleExclamation,
                    size: 28, color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(colors: [Colors.blue, Colors.purple])
                        .createShader(bounds),
                child: const Icon(FontAwesomeIcons.addressCard,
                    size: 28, color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SOS()));
              },
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(colors: [Colors.blue, Colors.purple])
                        .createShader(bounds),
                child: const Icon(Icons.emergency_outlined,
                    size: 28, color: Colors.white),
              ),
            ),],),),
    ));
  }
}
