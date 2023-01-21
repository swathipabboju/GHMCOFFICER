import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghmcofficerslogin/model/get_vehicles_reponse.dart';
import 'package:ghmcofficerslogin/model/raise_raise_request_submit_response.dart';
import 'package:ghmcofficerslogin/model/raise_request_demographics_response.dart';
import 'package:ghmcofficerslogin/model/raise_request_forward_to_nextward-response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showalert_singlebutton.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/providers/provider_notifiers.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RaiseRequest_RaiseRequest extends StatefulWidget {
  const RaiseRequest_RaiseRequest({super.key});

  @override
  State<RaiseRequest_RaiseRequest> createState() =>
      _RaiseRequest_RaiseRequestState();
}

class _RaiseRequest_RaiseRequestState extends State<RaiseRequest_RaiseRequest> {
  String? currentAddress;
  Position? _currentPosition;
  bool isDismissible = true;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  GetVehiclesResponse? getVehiclesResponse;
  RaiseRequestDemographicsResponse? raiseRequestDemographicsResponse;
  RaiseRequestForwardToNextWardResponse? raiseRequestForwardToNextWardResponse;
  RaiseRequestRaiseRequestSubmitResponse?
      raiseRequestRaiseRequestSubmitResponse;
  File? _image;
  Future getImage(ImageSource type) async {
    final XFile? img = await ImagePicker().pickImage(source: type);
    setState(() {
      _image = File(img!.path);
      //this.widget.callbackValue(img);
    });
  }

  bool places = false;
  List raiserequest_forwardwardname = [];
  List names = [];
  List raiserequest_vehicletype = ["Select Vehicle Type"];
  String? _selectedValue;
  TextEditingController landmark = TextEditingController();
  TextEditingController tripsController = TextEditingController();
  TextEditingController estimatedWasteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool ListItem = false;
  bool textamount = false;
  var escountlist = [];
  var amt;
  var vehicleid;
  var amountCount;
  var noOfTrips = 0,
      vehicletypeNo = 0,
      estwcount = 0,
      amount = 0,
      amounttext = 0;
  //deletedestcount = 0;
  var amountoriginal;
  var estd = 0;
  var amountd = 0;

  var i1;

  String noOfTripUpdatevalue = '';
  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () async {
              EasyLoading.show();
              Navigator.pushNamed(
                  context, AppRoutes.consructiondemolitionwaste);
            },
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (() {
              Navigator.of(context).pop();
            })
            //() => Navigator.of(context).pop(),
            ),
        title: Center(
          child: Text(
            "Raise Request",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Stack(children: [
        BgImage(imgPath: ImageConstants.bg),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RowComponent(
                    TextConstants.currentdate,
                    DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now()),
                    Colors.white),
                RowComponent(
                    TextConstants.raise_request_zone,
                    raiseRequestDemographicsResponse?.zONENAME ?? "",
                    Colors.white),
                RowComponent(
                    TextConstants.raise_request_circle,
                    raiseRequestDemographicsResponse?.cIRCLENAME ?? "",
                    Colors.white),
                RowComponent(
                    TextConstants.raise_request_ward,
                    raiseRequestDemographicsResponse?.wARDNAME ?? "",
                    Colors.white),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    controller: landmark,
                    style: const TextStyle(color: Colors.white),
                    // keyboardType: TextInputType.number,
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
                              : Colors.white,
                          fontSize: 14.0),
                      labelText: TextConstants.raise_request_landmark,
                    ),
                  ),
                ),
                RowComponents(
                  TextConstants.raise_request_forward_to_another_ward,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(children: <Widget>[
                    Radio(
                      value: 'Yes',
                      groupValue: _selectedValue,
                      onChanged: (val) {
                        setState(() {
                          _selectedValue = val.toString();
                          places = true;
                        });
                      },
                    ),
                    Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Radio(
                      value: 'No',
                      groupValue: _selectedValue,
                      onChanged: (val) {
                        setState(() {
                          _selectedValue = val.toString();
                          places = false;
                          //id = 2;
                        });
                      },
                    ),
                    Text(
                      'No',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 2.0, right: 15.0, top: 2.0),
                  child: places
                      ? ValueListenableBuilder(
                          valueListenable: publicdropdown,
                          builder: (context, value, child) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: DropdownButton(
                                  underline:
                                      Container(color: Colors.transparent),
                                  hint: value == null
                                      ? Text('Select')
                                      : Text(
                                          " " + value,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                  style: TextStyle(color: Colors.black),
                                  items: raiserequest_forwardwardname.map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text("  $val"),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    publicdropdown.value = val;
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : Text(""),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add Vehicles",
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (raiserequest_vehicletype.length > 2) {
                          var vehicletypelistlen =
                              getVehiclesResponse?.vEHICLELIST?.length ?? 0;

                          showModalBottomSheet(
                              isDismissible: false,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return customBottomSheet();
                              });
                          for (int i = 0; i < vehicletypelistlen; i++) {
                            if (names[i][0] ==
                                raiserequest_vehicletypeslist.value) {
                              raiserequest_vehicletype
                                  .remove(raiserequest_vehicletypeslist.value);
                              raiserequest_vehicletypeslist.value =
                                  "Select Vehicle Type";
                            }
                          }
                        } else {
                          showToast("There are no vehicles to select");
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        // print("Amount amt ----- ${amt}");
                                        showAlert(
                                            names[index][0], names[index][3],
                                            (value) {
                                          setState(() {
                                            noOfTripUpdatevalue = value;
                                          });
                                        }, () {
                                          setState(() {
                                            names[index][1] =
                                                noOfTripUpdatevalue;

                                            names[index][2] =
                                                int.parse(noOfTripUpdatevalue) *
                                                    int.parse(amt);

                                            estwcount = 0;
                                            amounttext = 0;

                                            for (int i = 0;
                                                i < names.length;
                                                i++) {
                                              i1 = names[i][1];
                                            }

                                            estwcount +=
                                                int.parse(i1) * vehicletypeNo;
                                            estimatedWasteController.text =
                                                estwcount.toString();
                                            //print(estimatedWasteController);

                                            amounttext = amounttext +
                                                int.parse(
                                                        tripsController.text) *
                                                    int.parse(amt);
                                            //print(amounttext);
                                            amountController.text =
                                                amounttext.toString();
                                          });
                                          Navigator.pop(context);
                                        });
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        raiserequest_vehicletype
                                            .add(names[index][0]);
                                        setState(() {
                                          names.removeAt(index);
                                          print("names ${names}");
                                          estd = 0;
                                          amountd = 0;
                                          for (var i = 0;
                                              i < names.length;
                                              i++) {
                                            var splittedvehicled =
                                                names[i][0].split(" ");
                                            var lend = splittedvehicled.length;
                                            var vehiclenod =
                                                splittedvehicled[lend - 2];

                                            estd += int.parse(vehiclenod) *
                                                int.parse(names[i][1]);

                                            estimatedWasteController.text =
                                                estd.toString();

                                            //var a=names[i][2];
                                            amountd += names[i][2] as int;
                                            amountController.text =
                                                amountd.toString();
                                            /*  raiserequest_vehicletype
                                                .add(names[index][0]); */
                                          }
                                          print(
                                              "raised list ${raiserequest_vehicletype}");
                                        });
                                        if (names.isEmpty) {
                                          textamount = false;
                                        }
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  RowComponent("Vehicle Type", names[index][0],
                                      Colors.teal),
                                  RowComponent("No of Trips", names[index][1],
                                      Colors.teal),
                                  RowComponent(
                                      "Amount", names[index][2], Colors.teal)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                textamount
                    ? Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              enabled: false,
                              controller: estimatedWasteController,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelText: TextConstants.estimatedwasteintons,
                                  labelStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              enabled: false,
                              controller: amountController,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelText: TextConstants.amount,
                                  labelStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    : Text(""),
                RowComponents(
                  TextConstants.raise_request_image_waste,
                ),
                _image != null
                    ? Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            icon: Icon(Icons.camera_alt_outlined),
                            color: Colors.white,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: TextButton(
                        onPressed: () async{
                          if (landmark.text.isEmpty) {
                            showToast("Please enter landmark");
                          } else if (names.isEmpty) {
                            showToast("Please add atleast one vehicle data");
                          } else if (_image == null) {
                            showToast("Please select image");
                          } else {
                            await raiseRequestraiseRequestSubmit();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SingleButtonDialogBox(
                                    bgColor: Color.fromARGB(255, 53, 202, 27),
                                    title: "GHMC Officer App",
                                    descriptions:
                                        "${raiseRequestRaiseRequestSubmitResponse?.sTATUSMESSAGE}",
                                    Buttontext: "Ok",
                                    img: Image.asset("assets/check.png"),
                                    onPressed: () {
                                      Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              AppRoutes.consructiondemolitionwaste));
                                    });
                              },
                            );
                          }
                        },
                        child: Text(
                          TextConstants.raise_request_submit,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  showSubmitAlert(String? sTATUSMESSAGE) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    "version: 2.8",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w200),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "GHMC Officer App",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Text(
                  "${sTATUSMESSAGE}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            // title: Text(message + text),
            actions: [
              Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.05,
                  margin: EdgeInsets.only(left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(255, 53, 202, 27)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context,
                          ModalRoute.withName(
                              AppRoutes.consructiondemolitionwaste));
                    },
                    child: Text(
                      TextConstants.request_estimation_ok,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          );
        }); //showDialog
  }

  showAlert(var value, var amounttxt, void Function(String)? onchanged,
      void Function()? onpressed) {
    showDialog(
      //barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              RowComponent("Vehicle Type", value, Colors.teal),
              RowComponent("Amount(as per trips)", amounttxt, Colors.teal),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                  onChanged: onchanged,
                  keyboardType: TextInputType.number,
                  controller: tripsController,
                  decoration: InputDecoration(
                      hintText: "No of Trips",
                      hintStyle: TextStyle(color: Colors.teal)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Colors.teal,
                        child: TextButton(
                            onPressed: onpressed,
                            child: Text(
                              "UPDATE",
                              style: TextStyle(color: Colors.white),
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Colors.teal,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "CANCEL",
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  customBottomSheet() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 200,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Vehicle Type",
                style: TextStyle(color: Colors.black),
              ),
              ValueListenableBuilder(
                valueListenable: raiserequest_vehicletypeslist,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 20.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: DropdownButton(
                            underline: Container(color: Colors.transparent),
                            hint: value == null
                                ? Text('Select Vehicle Type')
                                : Text(
                                    " " + "${value}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                            isExpanded: true,
                            iconSize: 30.0,
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            items: raiserequest_vehicletype.map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text("  ${val}"),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              raiserequest_vehicletypeslist.value = val;

                              var vehicletypelistlen =
                                  getVehiclesResponse?.vEHICLELIST?.length ?? 0;
                              amt = 0;
                              for (int i = 0; i < vehicletypelistlen; i++) {
                                if (raiserequest_vehicletypeslist.value ==
                                    getVehiclesResponse
                                        ?.vEHICLELIST?[i].vEHICLETYPE) {
                                  amt = getVehiclesResponse
                                      ?.vEHICLELIST?[i].aMOUNT;
                                  vehicleid = getVehiclesResponse
                                      ?.vEHICLELIST?[i].vEHICLETYPEID;
                                }
                              }
                            }),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: tripsController,
                  decoration: InputDecoration(
                      hintText: "No of Trips",
                      hintStyle: TextStyle(color: Colors.teal)),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: TextButton(
                    onPressed: () {
                      //print("length ${raiserequest_vehicletype.length}");
                      //amountCount = 0;
                      if (raiserequest_vehicletypeslist.value ==
                          'Select Vehicle Type') {
                        showToast("Select Vehicle Type");
                      } else if (tripsController.text == '') {
                        showToast("Please enter valid number");
                      } else {
                        setState(() {
                          names.add([
                            raiserequest_vehicletypeslist.value,
                            tripsController.text,
                            amountCount = int.parse(tripsController.text) *
                                int.parse(amt),
                            amountoriginal = amt,
                            vehicleid,
                            //amounttext = int.parse(amounttext) + amountCount;
                          ]);
                          print(names);
                          ListItem = true;
                          textamount = true;
                          var f =
                              raiserequest_vehicletypeslist.value?.split(" ");

                          var len = f?.length;
                          var vehicleno = f?[len! - 2];
                          vehicletypeNo = int.parse("${vehicleno}");
                          for (int i = 0; i < names.length; i++) {
                            i1 = names[i][1];
                          }

                          estwcount += int.parse(i1) * vehicletypeNo;
                          estimatedWasteController.text = estwcount.toString();
                          amounttext = amounttext +
                              int.parse(tripsController.text) * int.parse(amt);
                          amountController.text = amounttext.toString();
                        });
                        Navigator.pop(context);
                      }
                      //raiserequest_vehicletypeslist.value = "Select Vehicle Type";
                    },
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  RowComponent(var data, var value, var color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.toString(),
              style: TextStyle(color: color, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  RowComponents(var data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          SizedBox(
            width: 4,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    raiserequestGetVehicleType();
    raiserequestgetDemographics();
    raiserequestForwardToWard();
    raiseRequestraiseRequestSubmit();
    _getCurrentPosition();
  }

  raiserequestGetVehicleType() async {
    const requestUrl =
        ApiConstants.cndw_baseurl + ApiConstants.get_vehicle_type;

    final dioObject = Dio();

    try {
      final response = await dioObject.get(
        requestUrl,
      );
      var len = response.data.length;
      //converting response from String to json
      final data = GetVehiclesResponse.fromJson(response.data);
      //print(response.data);

      setState(() {
        if (data != null) {
          if (data.sTATUSCODE == "200") {
            EasyLoading.dismiss();
            getVehiclesResponse = data;
            if (getVehiclesResponse?.vEHICLELIST != null) {
              var vehicletypelistlen =
                  getVehiclesResponse?.vEHICLELIST?.length ?? 0;
              for (var i = 0; i < vehicletypelistlen; i++) {
                raiserequest_vehicletype
                    .add("${getVehiclesResponse?.vEHICLELIST?[i].vEHICLETYPE}");
              }
            }
          }
        }
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
  }

  raiserequestgetDemographics() async {
    const requestUrl = ApiConstants.cndw_baseurl +
        ApiConstants.amoh_raise_request_demographics_endpoint;

    final requestPayload = {
      "USER_ID": AppConstants.userid,
      "PASSWORD": AppConstants.password,
      "LATITUDE": "17.4366278", //17.4366278
      "LONGITUDE": "78.3608636" //78.3608636
    };

    final dioObject = Dio();

    try {
      final response = await dioObject.post(requestUrl, data: requestPayload);
      var len = response.data.length;
      //converting response from String to json
      final data = RaiseRequestDemographicsResponse.fromJson(response.data);
      print("get demographics ${response.data}");

      setState(() {
        if (data.sTATUSCODE == "200") {
          EasyLoading.dismiss();
          raiseRequestDemographicsResponse = data;
        }
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
  }

  raiserequestForwardToWard() async {
    const requestUrl = ApiConstants.cndw_baseurl +
        ApiConstants.amoh_raise_request_forwar_to_next_ward;

    final requestPayload = {
      "USER_ID": AppConstants.userid,
      "PASSWORD": AppConstants.password,
    };

    final dioObject = Dio();

    try {
      final response = await dioObject.post(requestUrl, data: requestPayload);
      var len = response.data.length;
      //converting response from String to json
      final data =
          RaiseRequestForwardToNextWardResponse.fromJson(response.data);
      print(response.data);

      setState(() {
        if (data != null) {
          if (data.sTATUSCODE == "200") {
            EasyLoading.dismiss();
            raiseRequestForwardToNextWardResponse = data;
            if (raiseRequestForwardToNextWardResponse?.forwardWard != null) {
              var wardplaceslen =
                  raiseRequestForwardToNextWardResponse?.forwardWard?.length ??
                      0;
              for (var i = 0; i < wardplaceslen; i++) {
                raiserequest_forwardwardname.add(
                    "${raiseRequestForwardToNextWardResponse?.forwardWard?[i].wARDNAME}");
              }
            }
          }
        }
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
  }

  raiseRequestraiseRequestSubmit() async {
    var tokenid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    var empname =
        await SharedPreferencesClass().readTheData(PreferenceConstants.name);
    const requestUrl = ApiConstants.cndw_baseurl +
        ApiConstants.amoh_raise_raise_request_submit;

    final requestPayload = {
      "CIRCLE_ID": raiseRequestDemographicsResponse?.cIRCLEID,
      "CREATED_BY": empname,
      "DEVICEID": "5ed6cd80c2bf361b",
      "EST_WT": estimatedWasteController.text,
      "IMAGE1_PATH": _image?.path,
      "IMAGE2_PATH": "",
      "IMAGE3_PATH": "",
      "LANDMARK": landmark.text,
      "LATITUDE": "${_currentPosition?.latitude}",
      "LONGITUDE": "${_currentPosition?.longitude}",
      "TOKEN_ID": tokenid,
      "VEHICLE_DETAILS": [
        {"NO_OF_TRIPS": tripsController.text, "VEHICLE_TYPE_ID": vehicleid}
      ],
      "WARD_ID": raiseRequestDemographicsResponse?.wARDID,
      "ZONE_ID": raiseRequestDemographicsResponse?.zONEID
    };

    print("raise request ${requestPayload}");

    final dioObject = Dio();

    try {
      final response = await dioObject.post(requestUrl, data: requestPayload);
      var len = response.data.length;
      //converting response from String to json
      final data =
          RaiseRequestRaiseRequestSubmitResponse.fromJson(response.data);
      print("raise raise request ${response.data}");

      setState(() {
        if (data != null) {
          if (data.sTATUSCODE == "200") {
            EasyLoading.dismiss();
            raiseRequestRaiseRequestSubmitResponse = data;
          } else if (data.sTATUSCODE == "600") {
            EasyLoading.dismiss();
            raiseRequestRaiseRequestSubmitResponse = data;
            showDialog(
              context: context,
              builder: (context) {
                return SingleButtonDialogBox(
                    bgColor: Color.fromARGB(255, 225, 38, 38),
                    title: "GHMC OFFICER APP",
                    descriptions:
                        "${raiseRequestRaiseRequestSubmitResponse?.sTATUSMESSAGE}",
                    Buttontext: "Ok",
                    img: Image.asset("assets/cross.png"),
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(AppRoutes.myloginpage));
                    });
              },
            );
          }
        }
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
  }
}
