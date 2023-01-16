import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/crejection_ticketlist_res.dart';
import 'package:ghmcofficerslogin/model/crejectionlist_req.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';



class CRejectionTicketlist extends StatefulWidget {
  const CRejectionTicketlist({super.key});

  @override
  State<CRejectionTicketlist> createState() => _CRejectionTicketlistState();
}

class _CRejectionTicketlistState extends State<CRejectionTicketlist> {
  CRejectedTicketListRes? _cRejectedTicketListRes;
  List<TicketList> ticketlistResponse = [];
  List<TicketList> ticketlistSearchListResponse = [];
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
              "Concenssionaire Incharge Pickup Capture list",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14),
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
                    
                      itemBuilder: (context, index) {
                        final details =ticketlistSearchListResponse[index];
                            

                        return GestureDetector(
                          onTap: () async {
                            /* Navigator.pushNamed(
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
                                          .concessionaire_pickup_capturelist_ticketID,
                                      details.tICKETID,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concessionaire_pickup_capturelist_locatio,
                                      details.lOCATION,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concessionaire_pickup_capturelist_date,
                                      details.cREATEDDATE,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants
                                          .concenssionaire_incharge_manual_closing_tcikets_status,
                                      details.cREATEDDATE,
                                    ),
                                    Line(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Image.network(
                                        "${details.iMAGE1PATH}",
                                        height: 100.0,
                                        width: 100.0,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return  Image.asset(
                                  ImageConstants.no_uploaded,
                                  width: 200.0,
                                  height: 100.0,
                                  );  /* Image.asset(
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
    // TODO: implement initState
    super.initState();
    getdetails();
  }

  getdetails() async {
    final url = ApiConstants.concessionaire_baseurl +
        ApiConstants.crejection_ticketlist_endpoint;
    CRejectedTicketListReq cRejectedTicketListReq =
        new CRejectedTicketListReq();
    cRejectedTicketListReq.dEVICEID = "5ed6cd80c2bf361b";
    cRejectedTicketListReq.tOKENID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    cRejectedTicketListReq.aMOHEMPID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    cRejectedTicketListReq.aMOHEMPWARDID = "";
    final payload = cRejectedTicketListReq.toJson();
    final _dioObject = Dio();
    final response = await _dioObject.post(url, data: payload);
    final data = CRejectedTicketListRes.fromJson(response.data);
    if (data.sTATUSCODE == "200") {
      setState(() {
         _cRejectedTicketListRes = data;
      ticketlistResponse =
                _cRejectedTicketListRes!.ticketList!;
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
