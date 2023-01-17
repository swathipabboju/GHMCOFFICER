import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghmcofficerslogin/model/get_staff_response.dart';
import 'package:ghmcofficerslogin/model/get_ward_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/model/takeaction_response.dart';
import 'package:ghmcofficerslogin/model/update_grievance_response.dart';
import 'package:ghmcofficerslogin/res/components/appbar.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/border_textfield.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showalert.dart';
import 'package:ghmcofficerslogin/res/components/showtoasts.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';

import '../res/components/textwidget.dart';
import '../res/constants/Images/image_constants.dart';
import '../res/constants/providers/provider_notifiers.dart';
import '../res/constants/text_constants/text_constants.dart';

class TakeActionNew extends StatefulWidget {
  const TakeActionNew({super.key});

  @override
  State<TakeActionNew> createState() => _TakeActionNewState();
}

class _TakeActionNewState extends State<TakeActionNew> {
  final _formKey = GlobalKey<FormState>();
  FocusNode mobilenofocusnode = new FocusNode();
  FocusNode emailidfocusnode = new FocusNode();
  FocusNode fineamountfocusnode = new FocusNode();
  FocusNode amountfocusnode = new FocusNode();
  FocusNode proofidfocusnode = new FocusNode();
  FocusNode tradenamefocusnode = new FocusNode();

  TextEditingController mobileno = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController fineamount = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController proofid = TextEditingController();
  TextEditingController tradename = TextEditingController();

  TextEditingController _controller = TextEditingController();
  bool modeidflag = false;
  var modeid;
  bool enabledropdown = false;
  var phototype = "";
  List RamkyItems = [];
  List<String> idproofs = ["select", "1", "2"];
  GetStaff? _getStaff;
  GetWard? _getWard;
  var takeaction_statusid = "";
  File? _image;
  Position? _currentPosition;
  Future getImage(ImageSource type) async {
    final img = await ImagePicker().pickImage(source: type);
    if (img == null) return;
    final tempimg = File(img.path);
    setState(() {
      this._image = tempimg;
      final bytes = tempimg.readAsBytesSync();
      String base64Image = "" + base64Encode(bytes);

      print("img_pan : $base64Image");
    });
  }

  TakeActionModel? takeActionModel;
  UpdateGrievanceResponse? _updateGrievanceResponse;
  Map items = {};
  List<String> warditems = [];
  final imagePickingOptions = [
    "Choose from Gallery",
    "Take Photo",
    "Choose Document",
    "cancel"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (() {
              Navigator.of(context).pop();
            })),
        title: Center(
          child: Text(
            "Take Action",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ),
      body: modeidflag
          ? Stack(
              children: <Widget>[
                BgImage(imgPath: ImageConstants.bg),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: BorderTextfield(
                          horizantalpadding: 4.0,
                          verticalpadding: 4.0,
                          containerheight: 0.05,
                          containerwidth: 0.9,
                          controller: tradename,
                          focusNode: tradenamefocusnode,
                          hinttext: TextConstants.take_action_citizen,
                          hinttextcolor: Colors.grey,
                          contentpadding: 5.0,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: takeactionIdproofsDropdown,
                          builder: ((context, value, child) {
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.88,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: DropdownButton(
                                      underline:
                                          Container(color: Colors.transparent),
                                      // value: selectedCountry.value,
                                      hint: value == null
                                          ? Text('Please Select ')
                                          : Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                      isExpanded: true,
                                      iconSize: 30.0,
                                      dropdownColor: Colors.white,
                                      iconEnabledColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      items: idproofs.map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text("$val"),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        takeactionIdproofsDropdown.value = val;
                                      }),
                                ),
                              ),
                            );
                          })),
                      BorderTextfield(
                        horizantalpadding: 4.0,
                        verticalpadding: 4.0,
                        containerheight: 0.05,
                        containerwidth: 0.9,
                        controller: proofid,
                        focusNode: proofidfocusnode,
                        hinttext: TextConstants.take_action_Proofid,
                        hinttextcolor: Colors.grey,
                        contentpadding: 5.0,
                        textAlign: TextAlign.start,
                      ),
                      BorderTextfield(
                        horizantalpadding: 4.0,
                        verticalpadding: 4.0,
                        containerheight: 0.05,
                        containerwidth: 0.9,
                        controller: mobileno,
                        maxlines: 10,
                        focusNode: mobilenofocusnode,
                        hinttext: TextConstants.take_action_mobileno,
                        hinttextcolor: Colors.grey,
                        contentpadding: 5.0,
                        textAlign: TextAlign.start,
                      ),
                      BorderTextfield(
                        horizantalpadding: 10.0,
                        verticalpadding: 4.0,
                        containerheight: 0.05,
                        containerwidth: 0.9,
                        controller: emailid,
                        maxlines: 10,
                        focusNode: emailidfocusnode,
                        hinttext: TextConstants.take_action_emailid,
                        hinttextcolor: Colors.grey,
                        contentpadding: 5.0,
                        textAlign: TextAlign.start,
                      ),
                      BorderTextfield(
                        horizantalpadding: 10.0,
                        verticalpadding: 4.0,
                        containerheight: 0.05,
                        containerwidth: 0.9,
                        controller: fineamount,
                        maxlines: 10,
                        focusNode: fineamountfocusnode,
                        hinttext: TextConstants.take_action_fine_amount,
                        hinttextcolor: Colors.grey,
                        contentpadding: 5.0,
                        textAlign: TextAlign.start,
                      ),
                      BorderTextfield(
                        horizantalpadding: 10.0,
                        verticalpadding: 4.0,
                        containerheight: 0.15,
                        containerwidth: 0.9,
                        controller: amount,
                        maxlines: 10,
                        focusNode: amountfocusnode,
                        hinttext: TextConstants.take_action_amount,
                        hinttextcolor: Colors.grey,
                        contentpadding: 5.0,
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Card(
                          color: Colors.transparent,
                          child: ElevatedButton(
                              onPressed: () {
                                updateGrievanceDetails();
                                if (tradename.text.isEmpty) {
                                  ShowToats.showToast(
                                      "please enter trade name");
                                } else if (takeactionIdproofsDropdown.value ==
                                    "select") {
                                  ShowToats.showToast(
                                      "please select idproof type");
                                } else if (proofid.text.isEmpty) {
                                  ShowToats.showToast("please enter proof id");
                                } else if (mobileno.text.isEmpty) {
                                  ShowToats.showToast("please enter mobile no");
                                } else if (emailid.text.isEmpty) {
                                  ShowToats.showToast("please enter email ");
                                } else if (fineamount.text.isEmpty) {
                                  ShowToats.showToast(
                                      "please enter fine  amount");
                                } else if (amount.text.isEmpty) {
                                  ShowToats.showToast(
                                      "please enter total amount");
                                } else {
                                  
                                  getStaffshowAlert(
                                      "${_updateGrievanceResponse?.compid}");
                                }

                                /*  ShowToats.showToast(
                                    "${_updateGrievanceResponse?.compid}",
                                    textcolor: Colors.black,
                                    bgcolor: Colors.amber,
                                    gravity: ToastGravity.CENTER); */
                                // Alerts.showAlertDialog(context, "Thanks for updating", Title: "Alert", onpressed: (){});
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent),
                              child: Text("Submit")),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Stack(
              children: <Widget>[
                BgImage(imgPath: ImageConstants.bg),
                Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: takeActionTypes1,
                      builder: (context, value, child) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.88,
                              decoration: BoxDecoration(color: Colors.white),
                              child: DropdownButton(
                                  underline:
                                      Container(color: Colors.transparent),
                                  // value: selectedCountry.value,
                                  hint: value == null
                                      ? Text('Please Select ')
                                      : Text(
                                          value,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                  style: TextStyle(color: Colors.black),
                                  items: items.keys.toList().map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text("  $val"),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    print(" $val");
                                    print("id ${items[val]}");
                                    takeaction_statusid = items[val];
                                    takeActionTypes1.value = "$val";

                                    if (val == "Forward to Ramky") {
                                      RamkyItems = [
                                        "select",
                                        "Claimed",
                                        "Unclaimed"
                                      ];
                                      setState(() {
                                        enabledropdown = true;
                                        ramkyvalues1.value = "select";
                                      });
                                    } else if (val ==
                                        "Forward to Lower Staff") {
                                      getStaffshowAlert("${_getStaff?.tag}");
                                      setState(() {
                                        enabledropdown = false;
                                      });
                                    } else if (val ==
                                        "Forward to another ward") {
                                      RamkyItems = warditems;
                                      setState(() {
                                        enabledropdown = true;
                                        ramkyvalues1.value = "select";
                                      });
                                    } else {
                                      setState(() {
                                        enabledropdown = false;
                                      });
                                    }
                                  }),
                            ),
                          ),
                        );
                      },
                    ),
                    enabledropdown ? subDropdown() : Text(""),
                    Center(
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.88,
                        constraints: BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _controller,
                                maxLines: null,
                                decoration: new InputDecoration.collapsed(
                                    hintText: "Enter Your Remarks",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    _image != null
                        ? GestureDetector(
                            onTap: (() {
                              showAlert("Add Photo");
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
                                  showAlert("Add Photo");
                                }),
                                icon: Icon(Icons.camera_alt_outlined),
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Card(
                      color: Colors.transparent,
                      child: ElevatedButton(
                          onPressed: () {
                            updateGrievanceDetails();
                            print("id on submit ${takeaction_statusid}");

                            if (_controller.text.isEmpty) {
                              showToast("please enter remarks");
                            }
                            switch (takeActionTypes1.value) {
                              case "select":
                                showToast("please select complaint status");

                                break;
                              case "Resolved by Officer":
                                if (_image?.path == null) {
                                  showToast("please select image");
                                } else {
                                  getStaffshowAlert(
                                      "${_updateGrievanceResponse?.compid}");
                                }

                                break;
                              case "Forward to another ward":
                                if (ramkyvalues1.value == "select") {
                                  showToast(
                                      "please select sub complaint status");
                                } else {
                                  getStaffshowAlert(
                                      "${_updateGrievanceResponse?.compid}");
                                }

                                break;
                              case "Forward to Ramky":
                                if (ramkyvalues1.value == "select") {
                                  showToast("please select status");
                                } else {
                                  getStaffshowAlert(
                                      "${_updateGrievanceResponse?.compid}");
                                }

                                break;

                              default:
                                getStaffshowAlert(
                                    "${_updateGrievanceResponse?.compid}");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent),
                          child: Text("Submit")),
                    ),
                  ),
                ),
              ],
            ),
    ); /*   */
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
    ForwarToLowerStaffDetails();
    GetWardDetails();
// updateGrievanceDetails();
    _getCurrentPosition();
  }

  fetchDetails() async {
    // modeid = "15";
     var modeid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.userdetails);
    if (modeid == "15") {
      setState(() {
        modeidflag = true;
      });
    } else {
      setState(() {
        modeidflag = false;
      });
    }
    var typeid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.typeid);
    var des = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.designation);
    const url = ApiConstants.baseurl + ApiConstants.takeaction_endpoint;

    // "https://19cghmc.cgg.gov.in/myghmcwebapi/Grievance/getStatusType";
    final pload = {
      "userid": AppConstants.userid,
      "password": AppConstants.password,
      "type_id": typeid,
      "designation": des
    };
    final _dioObject = Dio();
    try {
      final _response = await _dioObject.post(url, data: pload);
      var len = _response.data.length;
      //print(_response.data.length);

      for (var i = 0; i < len; i++) {
        final data = TakeActionModel.fromJson(_response.data[i]);

        setState(() {
          if (data.status == "success") {
            EasyLoading.dismiss();
            takeActionModel = data;
            // print("status id ${takeActionModel?.id}");
            items[takeActionModel?.type] = takeActionModel?.id;
            // items.add(data.type.toString());
            // print(items);
          }
        });
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  //forward to lower staff
  ForwarToLowerStaffDetails() async {
    var empid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    const url =
        ApiConstants.baseurl + ApiConstants.takeaction_getlowerstaff_endpoint;
    // "https://19cghmc.cgg.gov.in/myghmcwebapi/Grievance/getLowerStaff?empId=978";

    final _dioObject = Dio();
    try {
      final _response =
          await _dioObject.get(url, queryParameters: {"empId": empid});
      final data = GetStaff.fromJson(_response.data);
      // print(data.tag);
      setState(() {
        _getStaff = data;
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  GetWardDetails() async {
    const url = ApiConstants.baseurl + ApiConstants.get_ward_endpoint;

    final _dioObject = Dio();
    final getward_payload = {
      "userid": AppConstants.userid,
      "password": AppConstants.password
    };

    try {
      final _response = await _dioObject.post(url, data: getward_payload);
      final data = GetWard.fromJson(_response.data);
      //
      //print(data.tag);
      if (data.status == "true") {
        EasyLoading.dismiss();
        setState(() {
          _getWard = data;
        });
        print(_getWard?.tag);

        var ward_len = _getWard?.data?.length ?? 0;
        // print(ward_len);

        for (var i = 0; i < ward_len; i++) {
          // print(_getWard!.data![i].ward);
          warditems.add(_getWard!.data![i].ward.toString());
        }
      }
      // print(warditems);
    } on DioError catch (e) {
      print(e);
    }
  }

  updateGrievanceDetails() async {
    var compid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.historydetails);
    const url = ApiConstants.baseurl + ApiConstants.update_grievance_end_point;
    var typeid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.typeid);
    var mobileno = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.mobileno);
    var name =
        await SharedPreferencesClass().readTheData(PreferenceConstants.name);

    final payload = {
      "userid": AppConstants.userid,
      "password": AppConstants.password,
      "type_id": typeid,
      "mobileno":
          "${mobileno}-${name}-{\"userid\":\"${AppConstants.userid}\",\"password\":\"${AppConstants.password}\",\"type_id\":\"${typeid}\"}",
      "updatedstatus": takeaction_statusid,
      "compId": compid,
      "remarks": _controller.text,
      "latlon": "${_currentPosition?.latitude},${_currentPosition?.longitude}",
      // "17.4366254,78.3608523"
      "deviceid": "5ed6cd80c2bf361b",
      "no_of_trips": "",
      "total_net_weight": amount.text ?? "",
      "trader_name": tradename.text,
      "id_proof_type": takeactionIdproofsDropdown.value ?? "",
      "id_proof_no": proofid.text ?? "",
      "nmos_mobile_no": mobileno ?? "",
      "email": emailid.text ?? "",
      "fine_amount": fineamount.text ?? "",
      "source": modeid,
      "vehicleNo": "",
      "photo": "",
      "PhotoType": phototype,
      "claimant_status": "",
      "lower_staff_id": ""
    };
    print("payload ${payload}");
    final _dioObject = Dio();
    try {
      final _response = await _dioObject.post(url, data: payload);
      final data = UpdateGrievanceResponse.fromJson(_response.data);

      setState(() {
        EasyLoading.dismiss();
        _updateGrievanceResponse = data;
      });

      //  print(" update grievance data ${_updateGrievanceResponse?.status}");
      //
    } on DioError catch (e) {
      print(e);
    }
  }

  getStaffshowAlert(String message, {String text = ""}) {
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
                  if (message == _getStaff?.tag) {
                    Navigator.pop(context);
                  } else if (message == _updateGrievanceResponse?.compid) {
                    if (_updateGrievanceResponse?.status == "False") {
                      Navigator.pushNamed(context, AppRoutes.takeaction);
                    } else if (_updateGrievanceResponse?.status == "True") {
                      Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
                    }
                  }
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

  showAlert(String message, {String text = ""}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 45, 88, 124),
            title: Center(
              child: TextWidget(
                text: message + text,
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                fontsize: 15,
                textcolor: Colors.white,
              ),
            ),

            // title: Text(message + text),
            actions: [
              ValueListenableBuilder(
                valueListenable: imageOptions,
                builder: (context, value, child) {
                  return RadioGroup<String>.builder(
                    textStyle: TextStyle(color: Colors.white),
                    groupValue: value ?? "",
                    onChanged: (value) {
                      imageOptions.value = value;
                      phototype = imageOptions.value!;
                      if (value == "Choose Document") {
                        getImage(ImageSource.gallery);
                      } else if (value == "Take Photo") {
                        getImage(ImageSource.camera);
                      } else if (value == "Choose from Gallery") {
                        getImage(ImageSource.gallery);
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

  subDropdown() {
    return ValueListenableBuilder(
      valueListenable: ramkyvalues1,
      builder: (context, value, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.88,
              decoration: BoxDecoration(color: Colors.white),
              child: DropdownButton(
                  underline: Container(color: Colors.transparent),
                  hint: value == null
                      ? Text('Please Select ')
                      : Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  dropdownColor: Colors.white,
                  iconEnabledColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  items: RamkyItems.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text("$val"),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    print("$val");
                    ramkyvalues1.value = "$val";
                  }),
            ),
          ),
        );
      },
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services adre disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

//get current location
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
