import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_community_safety_app/Login.dart';
class GradientFaIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientFaIcon( {
    required this.icon,
    required this.gradient,
    this.size = 24.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, size, size),
      ),
        child: FaIcon(
            icon,
            size: size,
            color: Colors.white
    ),
    );
  }
}
class splashscreen extends StatefulWidget{
  @override
  _splashscreenState createState()=>_splashscreenState();
}
class _splashscreenState extends State<splashscreen>{

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 10),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login())));

  }
  Widget build(BuildContext context){
    return Scaffold(

      body:Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.purple,
            ],)
        ),

        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
               radius:70,
                child: GradientFaIcon(
icon:FontAwesomeIcons.userShield,
                  size: 70,
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                ),





              ),
                  SizedBox(height:20),


                  Text("Community Safety",style: TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold,fontFamily:'Arial'),),
                  Text("Stronger Communities.Safer Lives.",style: TextStyle(color:Colors.white,fontSize: 12,fontFamily: 'Arial')),


            ],
          )


        ),
      ),

    );}}