import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/model/login_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showtoast.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  StreamSubscription? connection;
  bool isoffline = false;

  TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();
  bool _isLoading = false;
  ghmc_login? ResponseData;
  String otpValue = '';
  String? mpin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BgImage(imgPath: ImageConstants.bg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 200.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              focusNode: myFocusNode,
                              controller: number,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              cursorColor: Color.fromARGB(255, 33, 184, 166),
                              decoration: InputDecoration(
                                //to hide maxlength
                                counterText: '',
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromARGB(255, 33, 184, 166),
                                )),

                                labelStyle: TextStyle(
                                    color: myFocusNode.hasFocus
                                        ? Color.fromARGB(255, 33, 184, 166)
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                                labelText: TextConstants.mobile_no,
                              ),
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return TextConstants.mobile_validation;
                                } else if (value.length < 10) {
                                  return TextConstants.mobile_count_validation;
                                }
                                return null;
                              }),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                var result =
                                    await Connectivity().checkConnectivity();
                                if (result == ConnectivityResult.mobile || 
                                result == ConnectivityResult.wifi || 
                                result == ConnectivityResult.bluetooth || 
                                result == ConnectivityResult.ethernet || 
                                result == ConnectivityResult.vpn) {
                                  if (_formKey.currentState!.validate()) {
                                  //print("onpressed");
                                  fetchLoginDetailsFromApi();
                                  if (_isLoading) return;
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  await Future.delayed(Duration(seconds: 1));

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                                } else if (result == ConnectivityResult.none) {
                                  //print("Check your internet connection");
                                  //ShowToast(Check your internet connection);
                                  ShowToats.showToast(
                                    "Check your internet connection", 
                                  gravity:  ToastGravity.CENTER,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black
                                  );
                                }

                              },
                              child: _isLoading
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Loading...",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Text(
                                      TextConstants.login,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink[400],
                                textStyle: TextStyle(fontSize: 16),
                                //minimumSize: Size.fromHeight(55),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();

  }

   @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  void fetchLoginDetailsFromApi() async {
    final requestUrl = ApiConstants.baseurl + ApiConstants.login_endpoint;

    final _dioObject = Dio();

    //Response
    try {
      final _response = await _dioObject
          .get(requestUrl, queryParameters: {"MOBILE_NO": number.text});

      final data = ghmc_login.fromJson(_response.data);
      print(_response.data);

      if (_response.data != null) {
        setState(() {
          this.ResponseData = data;
        });
        print("Login service - ${_response.data}");
        // print(ResponseData.status);

        if (ResponseData?.status == 'M') {
          print("checking ${ResponseData?.mpin.runtimeType}");
          if (ResponseData?.mpin != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.mpin, ResponseData?.mpin);
          }
          if(ResponseData?.mOBILENO != null){
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.mobileno, ResponseData?.mOBILENO);

          }
          if (ResponseData?.dESIGNATION != null) {
            await SharedPreferencesClass().writeTheData(
                PreferenceConstants.designation, ResponseData?.dESIGNATION);
          }
          if (ResponseData?.eMPD != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.empd, ResponseData?.eMPD);
          }
          if (ResponseData?.eMPNAME != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.name, ResponseData?.eMPNAME);
          }
          if (ResponseData?.message != null) {
            await SharedPreferencesClass().writeTheData(
                PreferenceConstants.message, ResponseData?.message);
          }
          if (ResponseData?.status != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.status, ResponseData?.status);
          }
          if (ResponseData?.tOKENID != null) {
            await SharedPreferencesClass().writeTheData(
                PreferenceConstants.tokenId, ResponseData?.tOKENID);
          }
          if (ResponseData?.tYPEID != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.typeid, ResponseData?.tYPEID);
          }
          if (ResponseData?.roleId != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.roleId, ResponseData?.roleId);
          }
          if (ResponseData?.ward != null) {
            await SharedPreferencesClass()
                .writeTheData(PreferenceConstants.ward, ResponseData?.ward);
          }
          Navigator.pushNamed(context, AppRoutes.newmpin);
        } else if (ResponseData?.status == 'O') {
          SharedPreferencesClass().writeTheData(
              PreferenceConstants.mobileno, ResponseData?.mOBILENO);
          print("otp from Api ${ResponseData?.otp}");
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.otp, ResponseData?.otp);
          SharedPreferencesClass().writeTheData(
              PreferenceConstants.category, ResponseData?.cATEGORY);
          SharedPreferencesClass().writeTheData(
              PreferenceConstants.designation, ResponseData?.dESIGNATION);
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.empd, ResponseData?.eMPD);
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.name, ResponseData?.eMPNAME);
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.message, ResponseData?.message);
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.status, ResponseData?.status);
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.tokenId, ResponseData?.tOKENID);
          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.typeid, ResponseData?.tYPEID);

          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.roleId, ResponseData?.roleId);

          SharedPreferencesClass()
              .writeTheData(PreferenceConstants.ward, ResponseData?.ward);

          print(ResponseData?.eMPNAME);
          Navigator.pushNamed(context, AppRoutes.otpscreen);
        } else if (ResponseData?.status == 'N') {
          showAlert(ResponseData!.message.toString());
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 ||
          e.response?.statusCode == 500 ||
          e.response?.statusCode == 404) {
        showAlert("${e.response?.statusMessage}");
      }
    }
  }

  showAlert(String message, {String text = ""}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextWidget(
              text: message + text,
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              fontsize: 15,
            ),
            // title: Text(message + text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(TextConstants.ok),
                //style: ButtonStyle(backgroundColor,
              )
            ],
          );
        }); //showDialog
  }

  /*  readsharedprefData() async {
    final otp = await SharedPreferencesClass().readTheData("otp");

    //print("otp value from sharedpre is $otp");

    setState(() {
      otpValue = otp;
    });
  } */
  /*  readsharedprefData() async {

    final m = await SharedPreferencesClass().readTheData(PreferenceConstants.mpin);

    //print("otp value from sharedpre is $otp");

    setState(() {
      mpin = m;
    });
  } */
}
