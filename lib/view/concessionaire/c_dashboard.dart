import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/logo_details.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';

import '../../model/concessioner/concessionaire_dashboard_request.dart';
import '../../model/concessioner/concessioner_dashboard_list_res.dart';
import '../../res/components/background_image.dart';
import '../../res/constants/text_constants/text_constants.dart';

class ConcessionaireDashboard extends StatefulWidget {
  const ConcessionaireDashboard({super.key});

  @override
  State<ConcessionaireDashboard> createState() =>
      _ConcessionaireDashboardState();
}

class _ConcessionaireDashboardState extends State<ConcessionaireDashboard> {
  ConcessionerDashboardListRes? _concessionerDashboardListRes;
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
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                      itemCount:
                          _concessionerDashboardListRes?.aMOHList?.length ?? 0,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: (() {
                                if (_concessionerDashboardListRes
                                        ?.aMOHList?[index]
                                        .cONCESSIONERTICKETSCOUNT ==
                                    "0") {
                                  showAlert("No records availble");
                                } else {
                                  Navigator.pushNamed(
                                      context, AppRoutes.cinchargeticketlist);
                                }
                              }),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black87, width: 1),
                                ),
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    "Concessionaire Incharge Ticket list",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  trailing: Text(
                                    "${_concessionerDashboardListRes?.aMOHList?[index].cONCESSIONERTICKETSCOUNT}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                if (_concessionerDashboardListRes
                                        ?.aMOHList?[index]
                                        .cONCESSIONERPICKUPCAPTURECOUNT ==
                                    "0") {
                                  showAlert("No records available");
                                } else {
                                  print("data");
                                  Navigator.pushNamed(
                                      context,
                                      AppRoutes
                                          .concessionairinchargepickupcapturelist);
                                }
                              }),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black87, width: 1),
                                ),
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    "Concessionaire Incharge Pickup Capture list",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  trailing: Text(
                                    "${_concessionerDashboardListRes?.aMOHList?[index].cONCESSIONERPICKUPCAPTURECOUNT}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                if (_concessionerDashboardListRes
                                        ?.aMOHList?[index]
                                        .cONCESSIONERREJECTEDCOUNT ==
                                    "0") {
                                  showAlert("No records available");
                                } else {
                                  Navigator.pushNamed(
                                      context, AppRoutes.crejectionticketlist);
                                }
                              }),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black87, width: 1),
                                ),
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    "Concesionaire Incharge Rejected list",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  trailing: Text(
                                    "${_concessionerDashboardListRes?.aMOHList?[index].cONCESSIONERREJECTEDCOUNT}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                if (_concessionerDashboardListRes
                                        ?.aMOHList?[index]
                                        .cONCESSIONERCLOSEDCOUNT ==
                                    "0") {
                                  showAlert("No records available");
                                } else {
                                  Navigator.pushNamed(
                                      context, AppRoutes.cclosedlist);
                                }
                              }),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black87, width: 1),
                                ),
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    "Concessionaire Incharge Closed list",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  trailing: Text(
                                    "${_concessionerDashboardListRes?.aMOHList?[index].cONCESSIONERCLOSEDCOUNT}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                if (_concessionerDashboardListRes
                                        ?.aMOHList?[index]
                                        .cONCESSIONERCLOSINGTICKETCOUNT ==
                                    "0") {
                                  showAlert("No records available");
                                } else {
                                  Navigator.pushNamed(
                                      context,
                                      AppRoutes
                                          .concessionaireinchargemanualclosingticketslist);
                                }
                              }),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black87, width: 1),
                                ),
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    "Concessionaire Incharge Manual Closing Tickets",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  trailing: Text(
                                    "${_concessionerDashboardListRes?.aMOHList?[index].cONCESSIONERCLOSINGTICKETCOUNT}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDetails();
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
                child: Text(TextConstants.ok),
                //style: ButtonStyle(backgroundColor,
              )
            ],
          );
        }); //showDialog
  } //

  GetDetails() async {
    final url = ApiConstants.concessionaire_baseurl +
        ApiConstants.concessionaire_dashboard_endpoint;
    ConcessionerDashboardListReq concessionerDashboardListReq =
        new ConcessionerDashboardListReq();
    concessionerDashboardListReq.dEVICEID = "5ed6cd80c2bf361b";
    concessionerDashboardListReq.eMPLOYEEID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    concessionerDashboardListReq.tOKENID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);

    final payload = concessionerDashboardListReq.toJson();

    print(payload);
    final _dioObject = Dio();
    try {
      final response = await _dioObject.post(url, data: payload);
      print(response);
      final data = ConcessionerDashboardListRes.fromJson(response.data);
      setState(() {
        if (data.sTATUSCODE == "200") {
          if (data.aMOHList != "null") {
            setState(() {
              _concessionerDashboardListRes = data;
            });
          }
        } else if (data.sTATUSCODE == "400") {
          showAlert("${data.sTATUSMESSAGE}");
        } else if (data.sTATUSCODE == "600") {
          print(data.sTATUSMESSAGE);
        }
      });
    } on DioError catch (e) {
      print(e);
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
              'GHMC Officer App',
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
