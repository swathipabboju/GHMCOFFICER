import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/c_closed_list_req.dart';
import 'package:ghmcofficerslogin/model/c_closed_list_res.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/internetcheck.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/showtoasts.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import '../../res/components/background_image.dart';
import '../../res/components/sharedpreference.dart';
import '../../res/constants/Images/image_constants.dart';
import '../../res/constants/text_constants/text_constants.dart';

class CClosedList extends StatefulWidget {
  const CClosedList({super.key});

  @override
  State<CClosedList> createState() => _CClosedListState();
}

class _CClosedListState extends State<CClosedList> {
  CClosedListRes? _cClosedListRes;
  List<TicketList> ticketlistResponse = [];
  List<TicketList> ticketlistSearchListResponse = [];
  StreamSubscription? connection;
  bool isoffline = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: (() {
                Navigator.of(context).pop();
              })
              //() => Navigator.of(context).pop(),
              ),
          title: Center(
            child: Text(
              "Concenssionaire  Incharge Ticket list",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            BgImage(imgPath: ImageConstants.bg),
            Column(
              children: [
                ReusableSearchbar(
                  bgColor: Colors.white,
                  screenHeight: 0.05,
                  searchIcon: Icon(Icons.search),
                  topPadding: 8.0,
                  onChanged: ((value) {
                    _runFilter(value);
                  }),
                  screenWidth: 1,
                  onPressed: () {},
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                      itemCount: ticketlistSearchListResponse.length,
                      // _cRejectedTicketListRes?.ticketList?.length
                      //_cRejectedTicketListRes?.ticketList?[index];
                      itemBuilder: (context, index) {
                        final details = ticketlistSearchListResponse[index];

                        return GestureDetector(
                          onTap: () async {
                            var result =
                                await Connectivity().checkConnectivity();
                                if (result == ConnectivityResult.wifi ||result == ConnectivityResult.mobile || result == ConnectivityResult.bluetooth || result == ConnectivityResult.vpn || result == ConnectivityResult.ethernet) {
                              // navigate
                            } else if (result == ConnectivityResult.none) {
                              ShowToats.showToast(TextConstants.internetcheck);
                            }
                            /*  Navigator.pushNamed(
                                context, AppRoutes.concessionairepickupcapture); */
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.black87, width: 1),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_ticketid,
                                      details.tICKETID,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_locatio,
                                      details.lOCATION,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .c_closed_list_ticketraiseddate,
                                      details.tICKETRAISEDDATE,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants.c_closed_list_closeddate,
                                      details.tICKETCLOSEDDATE,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_zone,
                                      details.zONENAME,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_circle,
                                      details.cIRCLENAME,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_ward,
                                      details.wARDNAME,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .c_closed_list_concessionairename,
                                      details.cONCESSIONERNAME,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_status,
                                      details.sTATUS,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Image.network(
                                        "${details.iMAGE1PATH}",
                                        height: 100.0,
                                        width: 100.0,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Text(
                                              ""); /* Image.asset(
                                  ImageConstants.ghmc_logo_new,
                                  width: 200.0,
                                  height: 100.0,
                                  ); */
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rights Reserved @ GHMC",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Powered By CGG",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  @override
  void initState() {
    NetCheck();
    // TODO: implement initState
    super.initState();
    getdetails();
  }

  getdetails() async {
    final url = ApiConstants.concessionaire_baseurl +
        ApiConstants.cclosed_list_endpoint;
    CClosedListReq cClosedListReq = new CClosedListReq();
    cClosedListReq.dEVICEID = "5ed6cd80c2bf361b";
    cClosedListReq.tOKENID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    cClosedListReq.cONCEMPID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);

    final payload = cClosedListReq.toJson();
    final _dioObject = Dio();
    final response = await _dioObject.post(url, data: payload);
    final data = CClosedListRes.fromJson(response.data);
    if (data.sTATUSCODE == "200") {
      setState(() {
        _cClosedListRes = data;
        ticketlistResponse = _cClosedListRes!.ticketList!;
        ticketlistSearchListResponse = ticketlistResponse;
      });
    } else if (data.sTATUSCODE == "400") {
    } else if (data.sTATUSCODE == "600") {}

    print(response.data);
  }

  Line() {
    return Divider(
      thickness: 1.0,
      color: Colors.grey,
    );
  }

  RowComponent(var data, var value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Color.fromARGB(255, 125, 120, 120),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  _runFilter(String enteredKeyword) {
    List<TicketList> results = [];
    if (enteredKeyword.isEmpty) {
      results = ticketlistResponse;
      print(results);
    } else {
      results = ticketlistResponse
          .where((element) => element.tICKETID!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        ticketlistSearchListResponse = results;
      });
    }
  }
}
