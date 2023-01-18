import 'package:flutter/material.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';


class MyResetMpin extends StatefulWidget {
  const MyResetMpin({super.key});

  @override
  State<MyResetMpin> createState() => _MyResetMpinState();
}

class _MyResetMpinState extends State<MyResetMpin> {
  final formkey = GlobalKey<FormState>();
  TextEditingController mobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Reset MPIN",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width*1,
        height: MediaQuery.of(context).size.height*1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.bg),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 40.0),
                child: Card(
                  elevation: 15.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 150.0),
                  color: const Color(0x66000000),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Mobile",
                            hintStyle: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          controller: mobile,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            final v = value ?? "";
                            if (v.isEmpty) {
                              //value!.isEmpty
                              return "Please Enter PhoneNumber";
                            } else if (!isValidMobile(v)) {
                              return "Please Enter Valid PhoneNumber";
                            }
                            return null;
                          },
                        ),

                        //login button
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {}
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValidMobile(String mobile) {
    return RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(mobile);
  }
}
