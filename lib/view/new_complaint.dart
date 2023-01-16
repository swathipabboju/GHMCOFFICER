
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghmcofficerslogin/model/insert_grievance_response.dart';
import 'package:ghmcofficerslogin/model/new_complaint_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/model/where_am_i.dart';
import 'package:ghmcofficerslogin/res/components/imagepicker.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/providers/provider_notifiers.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/view/cutsom_info_window.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';

class NewComplaint extends StatefulWidget {
  const NewComplaint({super.key});

  @override
  State<NewComplaint> createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {

  InsertGrievanceResponse? insertGrievanceResponse;
  WhereAmIModel? whereAmIModel;

  String? currentAddress;
  Position? _currentPosition;
  bool frommap=false;
  var result;

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
  //BestTutorSite _site = BestTutorSite.javatpoint;
  NewComplaintResponse? newComplaintResponse;  

  XFile imageData1 = XFile("");
  XFile imageData2 = XFile("");
  XFile imageData3 = XFile("");

  TextEditingController nameController = TextEditingController();
  TextEditingController LandmarkController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController description = TextEditingController();
  String? gender;
  List type = [];
 String? fromlocatevalue;

 
  final locationList = ["Use Current Location", "Locate on Map"];
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
               complaint.value="select";
              
            }) 
            //() => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "New Complaint",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.bg),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  //Location(),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: ValueListenableBuilder(
                      valueListenable: location,
                      builder: (context, value, child) {
                        return RadioGroup<String>.builder(
                          horizontalAlignment: MainAxisAlignment.center,
                          textStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.black,
                          activeColor: Colors.black,
                          direction: Axis.horizontal,
                          groupValue: value ?? "",
                          onChanged: (value) async {
                            location.value = value;

                           if(location.value == "Use Current Location")
                           {
                           setState(() {
                              frommap=false;
                            });
                            _getCurrentPosition(); 
                           }
                           else {
                            setState(() {
                              frommap=true;
                            });
                           result= await Navigator.push(context, MaterialPageRoute(builder:(context) =>  CustomInfoWindowExample()));
                           }
                          },
                          items: locationList,
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                          ),
                        );
                      },
                    ),
                  ),
                  //name
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 3.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),

                  //dropdown
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 2.0),
                    child: ValueListenableBuilder(
                      valueListenable: newcomplaintdropdown,
                      builder: (context, value, child) {
                        return Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: DropdownButton(
                              underline: Container(color: Colors.transparent),
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
                              items: type.map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text("  $val"),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                newcomplaintdropdown.value = val;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  //Landmark
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 2.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: LandmarkController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Landmark",
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),

                  //Enter your Description

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 4.0),
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.15,
                      constraints: BoxConstraints(maxHeight: 75.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: TextField(
                            controller: description,
                            maxLines: null,
                            decoration: new InputDecoration.collapsed(
                                border: InputBorder.none,
                                hintText: "Enter your Description",
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //mobile
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 2.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Contact Number",
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),

                  //image pickers
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ImgPickerCamera(
                            callbackValue: (imageData) {
                              imageData1 = imageData;  
                            },
                          ),
                          ImgPickerCamera(
                            callbackValue: (imageData) {
                              imageData2 = imageData;
                            },
                          ),
                          ImgPickerCamera(
                            callbackValue: (imageData) {
                              imageData3 = imageData;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),

                  //submit
                  Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if(newcomplaintdropdown.value=="Select" || newcomplaintdropdown.value=="select"){
                            showToast("Please Select Complaint Status");
                          }
                          else if(description.text.isEmpty)
                          {
                            showToast("Please enter description");
                          }
                          else if(imageData1.path.isEmpty)
                          {
                            showToast("Please select an image");
                          }
                          else{//17.4366451 //78.3608528
                            
                            if(frommap == true)
                            {
                              whereAmIApiCall(result[0],result[1]);

                              /*  print("from map lattitude ${result[0]}");
                            print("from map longitude ${result[1]}"); */
                            //insertGrievance();
                            }
                            else
                            {
                              whereAmIApiCall(_currentPosition?.latitude, _currentPosition?.longitude);
                               /* print("current lattitude ${_currentPosition?.latitude}");
                            print("current longitude ${_currentPosition?.longitude}"); */
                            //insertGrievance(_currentPosition?.latitude,_currentPosition?.longitude);
                            }
                            //frommap?whereAmIApiCall(result[0],result[1]):whereAmIApiCall(_currentPosition?.latitude, _currentPosition?.longitude);
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rights Reserved @ GHMC",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Powered By CGG",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        )
        );
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

  @override
  void initState() {
    super.initState();
    newComplaintDetails();
    _getCurrentPosition();
    
  }

  newComplaintDetails() async {
    var gid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.grievance_type);
    var lat = await SharedPreferencesClass().readTheData(PreferenceConstants.latitude);
    var long = await SharedPreferencesClass().readTheData(PreferenceConstants.longitude);
    var emp_name =
        await SharedPreferencesClass().readTheData(PreferenceConstants.name);
    var mobile_no = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.mobileno);
    //creating request url with base url and endpoint
    //
    setState(() {
      nameController.text = emp_name;
      mobileController.text = mobile_no;
    });
    const requesturl =
        ApiConstants.baseurl + ApiConstants.new_complaint_endpoint;

    var requestPayload = {
      "Latitude": "17.436617",
      "Longitude": "78.3608504",
      "gid": gid,
      "password": AppConstants.password,
      "userid": AppConstants.userid
    };

    //no headers and authorization

    //creating dio object in order to connect package to server
    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requesturl,
        data: requestPayload,
      );
      var len = response.data.length;

      //converting response from String to json
      for (var i = 0; i < len; i++) {
        final data = NewComplaintResponse.fromJson(response.data[i]);

        setState(() {
          if (data.status == "success") {
            EasyLoading.dismiss();
            newComplaintResponse = data;
          }
          type.add(newComplaintResponse?.type);
        });
        //  print(type);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
// step 5: print the response
  }


  insertGrievance(double? latitude, double? longitude)async{

  var mobileno = await SharedPreferencesClass().readTheData(PreferenceConstants.mobileno);
  var gid =  await SharedPreferencesClass().readTheData(PreferenceConstants.grievance_type);
  var empname = await SharedPreferencesClass().readTheData(PreferenceConstants.name);

  const requesturl =
        ApiConstants.baseurl + ApiConstants.new_compliant_insert_grievance_submit;
  
  final requestPayload ={
    "userid":AppConstants.userid,
    "password":AppConstants.password,
    "remarks":description.text,
    "photo":imageData1.path,
    "latlon":"${latitude},${longitude}",//"17.436617,78.3608504",
    "mobileno":"${mobileno}-${mobileController.text}",
    "deviceid":"5ed6cd80c2bf361b",
    "compType":gid,
    "landmark":LandmarkController.text,
    "username":empname,
    "ward":"0",
    "source":"20",
    "empid":"",
    "agentid":""
    };
   final dioObject = Dio();

   try {
      final response = await dioObject.post(
        requesturl,
        data: requestPayload,
      );

      //converting response from String to json
     
        final data = InsertGrievanceResponse.fromJson(response.data);

        setState(() {
          if (data.status == "true") {
            //EasyLoading.dismiss();
            insertGrievanceResponse = data;
          }
          //type.add(newComplaintResponse?.type);
        });
        //  print(type);
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
}

 whereAmIApiCall(double? latitude, double? longitude) async {
    // print(double.parse(Latlong.latitude.toString()));
    //  print(Latlong.longitude.toString());
    final whereAmiUrl = ApiConstants.baseurl + ApiConstants.where_am_i;
       // "https://19cghmc.cgg.gov.in/myghmcwebapi/Grievance/WhereAmI";
    final whereami_payload = {
      "userid": AppConstants.userid,
      "password": AppConstants.password,
      "latitude": latitude,
      "longitude": longitude
    };
    final dio_obj = Dio();
    try {
      final whereami_response =
          await dio_obj.post(whereAmiUrl, data: whereami_payload);
    //  print("fhfhfg${whereami_response.data}");
     final data = WhereAmIModel.fromJson(whereami_response.data);
        setState(() {
        if(data.status == true)
        {
          insertGrievance(latitude, longitude);
        }
        else{
          showAlert();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }
   showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TextConstants.selected_location),
          // title: Text(message + text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(TextConstants.ok),
              //style: ButtonStyle(backgroundColor:),
            )
          ],
        );
      },
    );
  }

}


