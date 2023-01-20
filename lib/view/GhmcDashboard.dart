import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ghmcofficerslogin/model/dashboard_response.dart';
import 'package:ghmcofficerslogin/model/mobile_menu_list_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/grievance_row.dart';
import 'package:ghmcofficerslogin/res/components/logo_details.dart';
import 'package:ghmcofficerslogin/res/components/navigation.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showtoast.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/view/total_grievances.dart';

class GhmcDashboard extends StatefulWidget {
  const GhmcDashboard({super.key});

  @override
  State<GhmcDashboard> createState() => _GhmcDashboardState();
}

class _GhmcDashboardState extends State<GhmcDashboard> {
  StreamSubscription? connection;
  bool isoffline = false;
  late DashboardResponse grievanceData;
  MobileMenuListResponse? mobileMenuListResponse;
  String tota = "";
  String totalid = "";
  String totalnumber = "";

  String slumname = "";
  String slumid = "";
  String slumcount = "";

  String allname = "";
  String allid = "";
  String allcount = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ReusableNavigation(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: SizedBox(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset(
                          ImageConstants.bg,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Center(
                        child: Container(
                          child: LogoAndDetails(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            BgImage(imgPath: ImageConstants.bg),
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (totalnumber == "0") {
                            showAlert();
                          } else {
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.mobile ||
                                result == ConnectivityResult.wifi) {
                              SharedPreferencesClass().writeTheData(
                                  PreferenceConstants.totalid, totalid);
                              EasyLoading.show();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyTotalGrievances()));
                            } else if (result == ConnectivityResult.none) {
                              ShowToats.showToast(
                                  "Check your internet connection",
                                  gravity: ToastGravity.BOTTOM,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black);
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black87, width: 1),
                          ),
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              tota,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            trailing: Text(
                              totalnumber,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (slumcount == "0") {
                            showAlert();
                          } else {
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.mobile ||
                                result == ConnectivityResult.wifi) {
                              SharedPreferencesClass().writeTheData(
                                  PreferenceConstants.totalid, slumid);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyTotalGrievances(),
                                  ));
                            } else if (result == ConnectivityResult.none) {
                              ShowToats.showToast(
                                  "Check your internet connection",
                                  gravity: ToastGravity.BOTTOM,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black);
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black87, width: 1),
                          ),
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              slumname,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            trailing: Text(
                              slumcount,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (allcount == "0") {
                            showAlert();
                          } else {
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.mobile ||
                                result == ConnectivityResult.wifi) {
                              EasyLoading.show();
                              SharedPreferencesClass().writeTheData(
                                  PreferenceConstants.totalid, allid);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyTotalGrievances(),
                                  ));
                            } else if (result == ConnectivityResult.none) {
                              ShowToats.showToast(
                                  "Please Check your internet connection",
                                  gravity: ToastGravity.BOTTOM,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black);
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black87, width: 1),
                          ),
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              allname,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            trailing: Text(
                              allcount,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Grievances(
                            height: 40.0,
                            img: ImageConstants.dash_grievances_icon,
                            text: TextConstants.raise_grievance,
                            textcolor: Colors.white,
                            onPressed: () async {
                              var result = await Connectivity().checkConnectivity();
                              if (result == ConnectivityResult.mobile ||
                                  result == ConnectivityResult.wifi) {
                                EasyLoading.show();
                                Navigator.pushNamed(
                                    context, AppRoutes.raisegrievance);
                              } else if (result == ConnectivityResult.none) {
                                ShowToats.showToast(
                                    "Please check your internet connection",
                                    gravity: ToastGravity.BOTTOM,
                                    bgcolor: Colors.white,
                                    textcolor: Colors.black);
                              }
                            },
                          ),
                          Grievances(
                              height: 40.0,
                              img: ImageConstants.dash_checkstatus,
                              text: TextConstants.check_status,
                              textcolor: Colors.white,
                              onPressed: () async {
                                var result =
                                    await Connectivity().checkConnectivity();
                                if (result == ConnectivityResult.mobile ||
                                    result == ConnectivityResult.wifi) {
                                  EasyLoading.show();
                                  Navigator.pushNamed(
                                      context, AppRoutes.checkstatusnew);
                                } else if (result == ConnectivityResult.none) {
                                  ShowToats.showToast(
                                      "Check your internet connection",
                                      gravity: ToastGravity.BOTTOM,
                                      bgcolor: Colors.white,
                                      textcolor: Colors.black);
                                }
                              }),
                          Grievances(
                              img: ImageConstants.construction_icon,
                              height: 50,
                              text: TextConstants.CNDW,
                              textcolor: Colors.white,
                              onPressed: () async{
                                var result = await Connectivity().checkConnectivity();
                                if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
                                {
                                EasyLoading.show();
                                Navigator.pushNamed(context,
                                    AppRoutes.consructiondemolitionwaste);
                                }
                                else if(result == ConnectivityResult.none)
                                {
                                  ShowToats.showToast(
                                    "Check your internet connection", 
                                  gravity:  ToastGravity.BOTTOM,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black
                                  );
                                }
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: mobileMenuListResponse?.rOW?.length ?? 0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final data = mobileMenuListResponse?.rOW?[index];
                            return GestureDetector(
                              onTap: () async {
                                var result = await Connectivity().checkConnectivity();
                                if(result == ConnectivityResult.mobile ||
                                 result == ConnectivityResult.wifi ||
                                  result == ConnectivityResult.bluetooth || 
                                  result == ConnectivityResult.ethernet ||
                                   result == ConnectivityResult.vpn)
                                {
                                EasyLoading.show();
                                await SharedPreferencesClass().writeTheData(
                                    PreferenceConstants.grievance_type,
                                    data?.iMENUID);
                                Navigator.pushNamed(
                                    context, AppRoutes.newcomplaint);
                                }
                                else if(result == ConnectivityResult.none)
                                {
                                  ShowToats.showToast(
                                    "Check your internet connection", 
                                  gravity:  ToastGravity.CENTER,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black
                                  );
                                }
                              },
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      "${data?.uRL}",
                                      height: 40,
                                    ),
                                    // SizedBox(
                                    //   height: 5.0,
                                    // ),
                                    Text(
                                      "${data?.mENUNAME}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
    GrievanceDetails();
    GrievanceGridDetails();
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  void GrievanceDetails() async {
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    var typeid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.typeid);
    //creating request url with base url and endpoint
    const requesturl = ApiConstants.baseurl + ApiConstants.endpoint;

    //creating payload because request type is POST
    var requestPayload = {
      "userid": AppConstants.userid,
      "password": AppConstants.password,
      "uid": uid,
      "type_id": typeid
    };

    //no headers and authorization

    //creating dio object in order to connect package to server
    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requesturl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = DashboardResponse.fromJson(response.data);
      print(response.data);

      setState(() {
        if (data.status == "true") {
          EasyLoading.dismiss();
          if (data.row != null && data.row!.length > 0) {
            String tot = data.row![0].total!;
            final splitted = tot.split('-');
            tota = splitted[2];
            totalid = splitted[1];
            totalnumber = splitted[0];

            String slum = data.row![0].sLF!;
            final slumsplit = slum.split('-');
            slumname = slumsplit[2];
            slumid = slumsplit[1];
            slumcount = slumsplit[0];

            String all = data.row![0].nONSLF!;
            final allsplit = all.split('-');
            allname = allsplit[2];
            allid = allsplit[1];
            allcount = allsplit[0];
          }
        }
      });
      EasyLoading.dismiss();
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

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(TextConstants.no_grievance_available),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(TextConstants.ok),
              )
            ],
          );
        }); //showDialog
  }

  GrievanceGridDetails() async {
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    // var typeid =
    //     await SharedPreferencesClass().readTheData(PreferenceConstants.typeid);
    //creating request url with base url and endpoint
    const requesturl = ApiConstants.baseurl + ApiConstants.mobile_menu_list;

    //creating payload because request type is POST
    var requestPayload = {
      "userid": AppConstants.userid,
      "password": AppConstants.password,
      "empid": uid
    };

    //no headers and authorization

    //creating dio object in order to connect package to server
    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requesturl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = MobileMenuListResponse.fromJson(response.data);
      print(response.data);

      setState(() {
        if (data.rOW != null) {
          if (data.status == "true") {
            mobileMenuListResponse = data;
          }
        }
      });
      EasyLoading.dismiss();
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
  } //

}
