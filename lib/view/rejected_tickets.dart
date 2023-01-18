import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/rejected_ticket_list_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/view/reject_or_reassign.dart';

import '../res/components/sharedpreference.dart';


class ConsessionerRejectedTicketsList extends StatefulWidget {
  const ConsessionerRejectedTicketsList({super.key});

  @override
  State<ConsessionerRejectedTicketsList> createState() =>
      _ConsessionerRejectedTicketsListState();
}

class _ConsessionerRejectedTicketsListState
    extends State<ConsessionerRejectedTicketsList> {
  RejectedTicketsListResponse? rejectedTicketsListResponse;

   List<TicketList> _rejectedTicketListResponse = [];
  List<TicketList> _rejectedTicketSearchListResponse = [];
 
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
                Navigator.pushNamed(context, AppRoutes.consructiondemolitionwaste);
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
              "Consessioner Rejected Tickets List",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                  onChanged: (value) => _runFilter(value),
                  screenWidth: 1,
                  onPressed: () {},
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                          itemCount: _rejectedTicketSearchListResponse.length,
                          itemBuilder: (context, index) {
                            final details = _rejectedTicketSearchListResponse[index];
                                
                            return GestureDetector(
                              onTap: () async {
                                AppConstants.consessioner_rejected_ticket_id = "${details.tICKETID}";
                                AppConstants.consessioner_rejected_image = "${details.iMAGE1PATH}";
                                AppConstants.consessioner_rejected_reasons_for_rejection = "${details.rEASONFORREJECT}";
                                //AppConstants.show();
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RejectOrReassign(),
                                  )); 
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black87, width: 1),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Column(
                                      children: [
                                        RowComponent(
                                          TextConstants
                                              .ticketid,
                                          details.tICKETID,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .location,
                                          details.lOCATION,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .date,
                                          details.cREATEDDATE,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .reasonsforrejection,
                                          details.rEASONFORREJECT,
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
                                              return Image.asset(ImageConstants.no_uploaded,
                                              height: 100.0,
                                              width: 100.0,
                                              ); 
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
              ],
            ),
          ],
        ));
  }

  Line() {
    return Divider(
      thickness: 1.0,
      color: Colors.grey,
    );
  }

  showAlertImage(String? photo) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            actions: [
              Center(
                  child: Container(
                      child: Image.network(
                photo!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(ImageConstants.no_uploaded);
                },
              ))),
            ],
          );
        });
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

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
  }
  
  getdetails() async {
    var tokenid = await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    var empid = await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    const requestUrl =
        ApiConstants.cndw_baseurl + ApiConstants.consessioner_rejected_ticket_list_endpoint;

    final requestPayload = {
      "AMOH_EMP_ID": empid,
      "AMOH_EMP_WARD_ID":"",
      "DEVICEID":"5ed6cd80c2bf361b",
      "TOKEN_ID":tokenid};

    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requestUrl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = RejectedTicketsListResponse.fromJson(response.data);
      print(response.data);
      setState(() {
        if (data.sTATUSCODE == "200") {
          EasyLoading.dismiss();
          if (data.ticketList!= null) {
            rejectedTicketsListResponse = data;
             _rejectedTicketListResponse = rejectedTicketsListResponse!.ticketList!;
            _rejectedTicketSearchListResponse = _rejectedTicketListResponse;
          }
        }
        else if (data.sTATUSCODE == "600"){
          
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

  _runFilter(String enteredKeyword) {
    List<TicketList> results = [];
    if (enteredKeyword.isEmpty) {
      results = _rejectedTicketListResponse;
    } else {
      print(enteredKeyword);
      results = _rejectedTicketListResponse
          .where((element) =>
              element.tICKETID!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        _rejectedTicketSearchListResponse = results;
        print(_rejectedTicketSearchListResponse.length);
      });
    }
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
  }
  
  //

}