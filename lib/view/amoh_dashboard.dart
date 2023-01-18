
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/amoh_dashboard_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/logo_details.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';


class AmohDashboardList extends StatefulWidget {
  const AmohDashboardList({super.key});

  @override
  State<AmohDashboardList> createState() => _AmohDashboardList();
}

class _AmohDashboardList extends State<AmohDashboardList> {
  AMOHDashboardListResponse? amohDashboardListResponse;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  delegate: MySliverAppBar(expandedHeight: 200.0),
                  pinned: true,
                ),
              ];
            },
            body: Stack(
              children: [
                BgImage(imgPath: ImageConstants.bg),
                Column(
                  children: [
                    listCardWidget(
                      text1: 'No of Requests by Citizen',
                      text2:
                          '${amohDashboardListResponse?.aMOHList?[0].nOOFREQUESTS ?? ""}',
                      onTap: (() {
                        if (amohDashboardListResponse
                                ?.aMOHList?[0].nOOFREQUESTS ==
                            "0") {
                          showAlert();
                        } else {
                          print("data");
                          Navigator.pushNamed(
                              context, AppRoutes.requestlist);
                        }
                      }),
                    ),
                    
                    listCardWidget(
                        text1: 'No of Requests by AMOH',
                        text2: '16',
                        onTap: () {
                           Navigator.pushNamed(
                             context, AppRoutes.requestbyamoh);
                        }),

                    listCardWidget(
                      text1: 'Payment Confirmation',
                      text2:
                          '${amohDashboardListResponse?.aMOHList?[0].pAYMENTCONFIRMATION ?? ""}',
                      onTap: (() {
                        if (amohDashboardListResponse
                                ?.aMOHList?[0].pAYMENTCONFIRMATION ==
                            "0") {
                          showAlert();
                        } else {
                          
                          Navigator.pushNamed(
                              context, AppRoutes.amohamountpayedlist);
                              EasyLoading.show();
                        }
                      }),
                    ),

                    listCardWidget(
                      text1: 'Raise Request',
                      text2: '',
                      onTap: () {
                        
                          Navigator.pushNamed(
                              context, AppRoutes.raiserequest_raiserequest);
                        } 
                    ),

                    listCardWidget(
                        text1: 'Concessioner Rejected',
                        text2:
                            '${amohDashboardListResponse?.aMOHList?[0].cONCESSIONERREJECTED ?? ""}',
                        onTap: () {
                          if (amohDashboardListResponse
                                ?.aMOHList?[0].cONCESSIONERREJECTED ==
                            "0") {
                          showAlert();
                        } else {
                          Navigator.pushNamed(
                              context, AppRoutes.rejectedtickets);
                        }
                        }
                        ),

                    listCardWidget(
                        text1: 'Concessioner Close Tickets',
                        text2:
                            '${amohDashboardListResponse?.aMOHList?[0].cONCESSIONERCLOSETICKETS ?? ""}',
                        onTap: () {
                            if (amohDashboardListResponse
                                ?.aMOHList?[0].cONCESSIONERCLOSETICKETS == "0") {
                          showAlert();
                        } else {
                          Navigator.pushNamed(
                              context, AppRoutes.closedticketlist);
                        }
                        }
                        ),

                    listCardWidget(
                        text1: 'AMOH Close Tickets',
                        text2:
                            '${amohDashboardListResponse?.aMOHList?[0].aMOHCLOSETICKETS ?? ""}',
                        onTap: () {
                          if (amohDashboardListResponse
                                ?.aMOHList?[0].aMOHCLOSETICKETS ==
                            "0") {
                          //showAlert("No records available");
                        } else {
                           Navigator.pushNamed(
                               context, AppRoutes.amohclosedticketlist);
                        }
                        }
                        ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget listCardWidget(
      {required String text1, required text2, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black87, width: 1),
        ),
        color: Colors.transparent,
        margin: const EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text1,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                text2,
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("no records available"),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAmohDashboardDetails();
  }

  fetchAmohDashboardDetails() async {
    var tokenid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    var empid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    const requestUrl =
        ApiConstants.cndw_baseurl + ApiConstants.amoh_dash_list_endpoint;

    final requestPayload = {
      "EMPLOYEE_ID": empid,
      "DEVICEID": "5ed6cd80c2bf361b",
      "TOKEN_ID": tokenid
    };

    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requestUrl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = AMOHDashboardListResponse.fromJson(response.data);
      print(response.data);
      setState(() {
        if (data.sTATUSCODE == "200") {
          EasyLoading.dismiss();
          if (data.aMOHList != null) {
            amohDashboardListResponse = data;
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

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              BgImage(imgPath: ImageConstants.bg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: const Text(
              'AMOH Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 5 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: LogoAndDetails(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
