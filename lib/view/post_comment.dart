import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/model/postcomment_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/providers/provider_notifiers.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';

class PostComment extends StatefulWidget {
  const PostComment({super.key});

  @override
  State<PostComment> createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  PostCommentResponse? _postCommentResponse;
  final options = ["with photo", "without photo"];
  TextEditingController remarks = new TextEditingController();
  bool flag = false;
  File? _image;
  final imagePickingOptions = ["Take Photo", "Choose from Library", "cancel"];

  Future getImage(ImageSource type) async {
    final img = await ImagePicker().pickImage(source: type);
    if (img == null) return;
    final tempimg = File(img.path);
    setState(() {
      this._image = tempimg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.black),
              onPressed: () async{
                EasyLoading.show();
                Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed:(() {
               Navigator.of(context).pop();
              
              
            }) 
            //() => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "Post Comment",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: postcommentoptions,
              builder: (context, value, child) {
                return RadioGroup<String>.builder(
                  horizontalAlignment: MainAxisAlignment.center,
                  textStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.black,
                  activeColor: Colors.black,
                  direction: Axis.horizontal,
                  groupValue: value ?? "",
                  onChanged: (value) {
                    postcommentoptions.value = value;
                    if (postcommentoptions.value == "with photo") {
                      setState(() {
                        flag = true;
                      });
                    } else {
                      setState(() {
                        flag = false;
                      });
                    }

                    //Navigator.push(context, MaterialPageRoute(builder:(context) => const MapSample()));
                  },
                  items: options,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                );
              },
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              margin: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.15,
              constraints: BoxConstraints(maxHeight: 75.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: TextField(
                    controller: remarks,
                    maxLines: null,
                    decoration: new InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: "Enter your Description",
                        hintStyle: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            flag
                ? (_image != null
                    ? GestureDetector(
                        onTap: (() {
                          ImageOptionAlert("Add Photo");
                        }),
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            onPressed: (() {
                              ImageOptionAlert("Add Photo");
                            }),
                            icon: Icon(Icons.camera_alt_outlined),
                            color: Colors.white,
                          ),
                        ),
                      ))
                : Text(""),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.05,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: TextButton(
                  onPressed: () {
                    if (remarks.text.isEmpty) {
                      showToast("Please enter remarks");
                    } else if (postcommentoptions.value == "with photo" &&
                        _image == null) {
                      showToast("Please select image");
                    } else {
                      print(_postCommentResponse?.compid);
                      SubmitAlert("${_postCommentResponse?.compid}");
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    getdetails();
  }

  getdetails() async {
    var cid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.check_status_id);
    const url = ApiConstants.baseurl + ApiConstants.postcomment_endpoint;
    var payload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "remarks": "test",
      "photo": "",
      "latlon": "17.4366736,78.3609231",
      "mobileno": "8008554962-Dr.K.S.Ravi",
      "deviceid": "5ed6cd80c2bf361b",
      "updatedstatus": "2",
      "compId": cid
    };
    final dioObject = Dio();
    try {
      final response = await dioObject.post(
        url,
        data: payload,
      );
      final data = PostCommentResponse.fromJson(response.data);
      setState(() {
        if (data.status == "True") {
          _postCommentResponse = data;
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  SubmitAlert(String message, {String text = ""}) {
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
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.ghmcdashboard));
                },
                child: Text(
                  TextConstants.ok,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        }); //showDialog
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.transparent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  ImageOptionAlert(String message, {String text = ""}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: TextWidget(
                text: message + text,
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                fontsize: 15,
                textcolor: Colors.black,
              ),
            ),

            // title: Text(message + text),
            actions: [
              ValueListenableBuilder(
                valueListenable: imageOptions,
                builder: (context, value, child) {
                  return RadioGroup<String>.builder(
                    textStyle: TextStyle(color: Colors.black),
                    groupValue: value ?? "",
                    onChanged: (value) {
                      imageOptions.value = value;
                      if (value == "Choose from Library") {
                        getImage(ImageSource.gallery);
                      } else if (value == "Take Photo") {
                        getImage(ImageSource.camera);
                      } else if (value == "cancel") {
                        // Navigator.pop(context);
                      }
                      Navigator.pop(context);
                    },
                    items: imagePickingOptions,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  );
                },
              ),
            ],
          );
        });
    //showDialog
  }
}
