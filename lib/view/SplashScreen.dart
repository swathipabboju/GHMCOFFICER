import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/model/splash_versioncheck_model.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';




class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => VersoinChecking());
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splashscreenghmc.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  VersoinChecking() async {
    //step1: create request url with base url and endpoint
    const requestUrl = "https://19cghmc.cgg.gov.in/myghmcwebapi/Grievance/" +
        "versionCheckOfficer";

//step 2: create payload if request post ,put,option
    final requestPayload = {"userid": "cgg@ghmc", "password": "ghmc@cgg@2018"};

// step 3: create headders and autherazation
    // Map<String, String> requestHeaders = {'Content-Type': 'application/json; charset=UTF-8', 'Access-Control-Allow-Origin': '*'};
// step 4: dio or http use this package connect to server
    final _dioObject = Dio();

    try {
      final _response = await _dioObject.post(requestUrl, data: requestPayload);
      //convet this response from json to modelclass

      print(_response.data);
      final splashResopnse = VersionCheck.fromJson(_response.data);
      if (splashResopnse.status == true) {
        Navigator.pushNamed(context, AppRoutes.myloginpage);
      } 
      else {
        Fluttertoast.showToast(
            msg: splashResopnse.message ?? "", // message
            toastLength: Toast.LENGTH_LONG, // length
            gravity: ToastGravity.CENTER, // location
            timeInSecForIosWeb: 1 // duration
            );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        final errorMessage = e.response?.statusMessage;
        Fluttertoast.showToast(
            msg: errorMessage ?? "", // message
            toastLength: Toast.LENGTH_LONG, // length
            gravity: ToastGravity.CENTER, // location
            timeInSecForIosWeb: 1 // duration
            );
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
// step 5: print the response
  }
}
