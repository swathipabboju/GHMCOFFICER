import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import '../model/resend_otp_response.dart';
import '../res/components/button.dart';
import '../res/components/sharedpreference.dart';
import '../res/components/textwidget.dart';
import '../res/constants/ApiConstants/api_constants.dart';

class OtpNewScreen extends StatefulWidget {
  const OtpNewScreen({super.key});

  @override
  State<OtpNewScreen> createState() => _OtpNewScreenState();
}

class _OtpNewScreenState extends State<OtpNewScreen> {
  ResendOtpModel? _resendOtpResponse;
  String? newOtp;
  bool enableResend = false;
  int start = 10;
  Timer? countdownTimer;
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();
  TextEditingController Otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Verification Code",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.50,
            color: const Color.fromARGB(255, 58, 71, 77),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const TextWidget(
                      text: "Please type the verification code \nsent to ",
                      textcolor: Colors.white,
                      fontsize: 17,
                      left: 10,
                      right: 80,
                      top: 20,
                      bottom: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 150, left: 160),
                      child: TextFormField(
                        controller: Otp,
                        
                        maxLength: 4,
                        style: const TextStyle(color: Colors.white),
                        onTap: () {
                          // FocusNode().hasFocus ? valid() : v();
                        },
                        cursorColor: const Color.fromRGBO(33, 121, 110, 1),
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                            counterText: '',
                            hintText: "0000",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: myFocusNode.hasFocus
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            )),
                      ),
                    ),
                    enableResend ? valid() : v()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    
    super.initState();
    startTimer();
    fetchDetails();
  }

  fetchDetails() async {
    final requestUrl =
        ApiConstants.baseurl + ApiConstants.resend_otp_endpoint;
    final requestPayload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "mobile_no": "8008554962"
    };

    final _dioObject = Dio();
    try {
      final _response = await _dioObject.post(requestUrl, data: requestPayload);
      final data = ResendOtpModel.fromJson(_response.data);
      setState(() {
        _resendOtpResponse = data;
      });
      newOtp = _resendOtpResponse?.otp;
      // print(_resendOtpResponse?.otp);
      //print("response from resend otp is ${_response.data}");
      // print("resend otp is ${_resendOtpResponse?.otp}");
    } on DioError catch (e) {
      print(e);
    }
  }

  //methods

  startTimer() {
    const onsec = Duration(seconds: 1);
    countdownTimer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          countdownTimer!.cancel();
          enableResend = true;

          // valid();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  v() {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: (() async {
                 final result =
                    await SharedPreferencesClass().readTheData("otp");
                 print("otp from shared preference ${result}");
                // print("user enterd otp ${Otp.text}");
                if (result == Otp.text) {
                 // Navigator.pushNamed(context, AppRoutes.newresetmpinscreen);
                } else {
                  showAlert("Invalid OTP");
                }
              }), child: const Text("Validate")),
          TextWidget(
            text: "Waiting for OTP: 00: $start ",
            textcolor: Colors.white,
            fontsize: 17,
            left: 0,
            right: 0,
            top: 20,
            bottom: 0,
          ),
        ],
      ),
    );
  }

  valid() {
    return Container(
      child: Column(
        children: [
          textButton(
            text: "VALIDATE",
            height: 45,
            width: 150,
            backgroundcolor: Colors.pinkAccent,
            onPressed: (() {
              print("newotp is ${newOtp}");
              print("user enterd otp is ${Otp.text}");
              if (newOtp == Otp.text) {
                Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
              } else if(Otp.text.isEmpty){
                showAlert("Please Enter Valid Otp");
              }
            }),
          ),
          TextWidget(
            text: "Did't Recieve the code? ",
            textcolor: Colors.white,
            fontsize: 17,
            left: 0,
            right: 0,
            top: 20,
            bottom: 0,
          ),
          textButton(
            text: "RESEND OTP",
            onPressed: (() async {
              
              print(newOtp);
            }),
            height: 45,
            width: 150,
            backgroundcolor: Colors.pinkAccent,
          )
        ],
      ),
    );
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
                  print("clicked");
                  // print("button Action");
                  Navigator.pop(context);
                },
                child: Text("ok"),
                //style: ButtonStyle(backgroundColor,
              )
            ],
          );
        }); //showDialog
  } //

}
