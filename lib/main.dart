import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'splashscreen.dart';
import '../controller/themecontroller.dart';

void main() {

  Get.put(ThemeController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final ThemeController controller = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashscreen(), // Your SplashScreen
      theme: ThemeData(
        scaffoldBackgroundColor:
        controller.isDarkBg.value ? Colors.black : Colors.white,
      ),
    ));


}
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(/*
backgroundColor: Colors.deepOrangeAccent,
          title:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,

              children: [
               InkWell(
                 onTap:(){
                   Navigator.push(context,MaterialPageRoute(builder:(context)=> ReportIncident(),)
                   );
                 },
                 child: Row(
                   children: [
                     FaIcon(FontAwesomeIcons.personFallingBurst ,color:Colors.white),
                     Text("Report Incident",style: TextStyle(fontSize:12,color:Colors.white),),
                   ],
                 ),
               ),
               InkWell(
                 onTap:(){
                   Navigator.push(context,MaterialPageRoute(builder:(context)=> ViewMap(),)
                   );
                 },
                 child:  Row(
                   children: [
                     FaIcon(FontAwesomeIcons.mapLocation ,color:Colors.white),
                     Text("View Map",style: TextStyle(fontSize:12,color:Colors.white),),
                   ],
                 ),
               ),
                InkWell(
                  onTap:(){
                    Navigator.push(context,MaterialPageRoute(builder:(context)=> Alerts(),)
                    );
                  },
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.triangleExclamation ,color:Colors.white),
                      Text("Alerts",style: TextStyle(fontSize:12,color:Colors.white),),
                    ],
                  ),
                ),
               InkWell(
                 onTap:(){
                   Navigator.push(context,MaterialPageRoute(builder:(context)=> Profile(),)
                   );
                 },
                 child:  Row(
                   children: [
                     FaIcon(FontAwesomeIcons.addressCard ,color:Colors.white),
                     Text("Profile",style: TextStyle(fontSize:12,color:Colors.white),),
                   ],
                 ),
               ),
                InkWell(
                  onTap:(){
                    Navigator.push(context,MaterialPageRoute(builder:(context)=> SOS(),)
                    );
                  },
                  child:Row(
                    children: [
                      Icon(Icons.emergency_outlined ,color:Colors.white),
                      Text("SOS",style: TextStyle(fontSize:12,color:Colors.white),),
                    ],
                  ),
                ),


              ],
            ),
          )
      */),
     // body: Padding(
       // padding: const EdgeInsets.all(8.0),
        //child: Container(
       //   width:double.infinity,

       //   height: double.infinity,
      //    decoration: BoxDecoration(



         // ),

    //    ),
    //  ),
    );
 }
}
